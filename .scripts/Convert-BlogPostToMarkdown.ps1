<#
.SYNOPSIS
    Converts a single extracted blog post's HTML body to Markdown, localizing
    old-domain links, validating external links, and downloading images as WebP.

.DESCRIPTION
    Takes the path to one of the .md files produced by Export-WordPressPosts.ps1
    (frontmatter + raw HTML body with a "TODO: convert this post's content to
    Markdown" comment) and:

    - Downloads every <img> referenced in the post, converts it to WebP (via
      cwebp/gif2webp), saves it to public/assets/blog/, and rewrites the <img>
      src to point at the local copy. Images that fail to download or convert
      are left untouched.
    - Rewrites <a href> links pointing at colinmackay.scot or colinmackay.co.uk
      (the blog's own current and former domains) to local site paths.
    - Validates every other <a href> link is reachable.
    - Converts the (now locally-rewritten) HTML body to Markdown via pandoc.

    Whatever succeeds or fails, the script never aborts partway through a post.
    Every problem encountered (conversion failure, broken link, failed image)
    is recorded as an "<!-- ISSUE: ... -->" comment at the top of the body,
    replacing the original TODO comment. If nothing went wrong, no comment is
    left at all.

    Requires pandoc and the webp CLI tools (cwebp, gif2webp) to be installed
    and on PATH (e.g. `brew install pandoc webp`).

.PARAMETER Path
    Path to the blog post .md file to convert.

.EXAMPLE
    pwsh .scripts/Convert-BlogPostToMarkdown.ps1 -Path src/data/blog-posts/2005/04/22/passing-values-between-forms-in-net.md
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [string]$Path
)

$ErrorActionPreference = 'Stop'

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot '..')
$assetsDir = Join-Path $repoRoot 'public/assets/blog'
New-Item -ItemType Directory -Path $assetsDir -Force | Out-Null

$ownDomains = @('colinmackay.scot', 'www.colinmackay.scot', 'colinmackay.co.uk', 'www.colinmackay.co.uk')
$webRequestArgs = @{
    TimeoutSec          = 20
    MaximumRedirection  = 10
    UserAgent           = 'Mozilla/5.0 (compatible; blog-migration-script/1.0)'
    SkipCertificateCheck = $true
}

function Get-PostParts {
    param([string]$Content)

    if ($Content -notmatch '(?s)^(---\r?\n.*?\r?\n---\r?\n)(.*)$') {
        throw 'Could not find a frontmatter block (--- ... ---) at the top of the file.'
    }
    $frontmatter = $Matches[1]
    $body = $Matches[2]

    # Strip any leading HTML comments (the original TODO comment, or ISSUE
    # comments left by a previous run of this script) so they aren't carried
    # into the converted output.
    $body = $body -replace '(?s)^\s*(<!--.*?-->\s*)+', ''

    if ($frontmatter -notmatch '(?m)^slug:\s*(\S+)\s*$') {
        throw 'Could not find "slug" in frontmatter.'
    }
    $slug = $Matches[1]

    if ($frontmatter -notmatch '(?m)^publishDate:\s*"?([^"\r\n]+?)"?\s*$') {
        throw 'Could not find "publishDate" in frontmatter.'
    }
    $publishDate = [datetime]::ParseExact($Matches[1], 'dd MMM yyyy', [System.Globalization.CultureInfo]::InvariantCulture)

    [pscustomobject]@{
        Frontmatter = $frontmatter
        Body        = $body
        Slug        = $slug
        PublishDate = $publishDate
    }
}

function Get-ImageExtensionFromContent {
    param([string]$FilePath)

    $bytes = [System.IO.File]::ReadAllBytes($FilePath)
    if ($bytes.Length -ge 4 -and $bytes[0] -eq 0x89 -and $bytes[1] -eq 0x50 -and $bytes[2] -eq 0x4E -and $bytes[3] -eq 0x47) { return '.png' }
    if ($bytes.Length -ge 3 -and $bytes[0] -eq 0xFF -and $bytes[1] -eq 0xD8 -and $bytes[2] -eq 0xFF) { return '.jpg' }
    if ($bytes.Length -ge 3 -and [System.Text.Encoding]::ASCII.GetString($bytes, 0, 3) -eq 'GIF') { return '.gif' }
    if ($bytes.Length -ge 12 -and [System.Text.Encoding]::ASCII.GetString($bytes, 0, 4) -eq 'RIFF' -and [System.Text.Encoding]::ASCII.GetString($bytes, 8, 4) -eq 'WEBP') { return '.webp' }
    if ($bytes.Length -ge 2 -and [System.Text.Encoding]::ASCII.GetString($bytes, 0, 2) -eq 'BM') { return '.bmp' }
    return ''
}

function Save-PostImageAsWebp {
    param(
        [string]$Url,
        [string]$DestinationDir,
        [string]$BaseName
    )

    $tempFile = New-TemporaryFile
    try {
        try {
            Invoke-WebRequest -Uri $Url -OutFile $tempFile.FullName @webRequestArgs | Out-Null
        } catch {
            throw "download failed - $($_.Exception.Message)"
        }

        $knownExts = @('.png', '.jpg', '.jpeg', '.gif', '.webp', '.bmp', '.tiff', '.tif')
        $ext = [System.IO.Path]::GetExtension(($Url -split '[?#]')[0]).ToLowerInvariant()
        if ($ext -notin $knownExts) {
            $sniffed = Get-ImageExtensionFromContent -FilePath $tempFile.FullName
            if (-not $sniffed) { throw "unsupported or unrecognized image format ('$ext')" }
            $ext = $sniffed
        }

        $destPath = Join-Path $DestinationDir "$BaseName.webp"

        switch ($ext) {
            '.webp' {
                Copy-Item -Path $tempFile.FullName -Destination $destPath -Force
            }
            { $_ -in '.gif' } {
                $out = & gif2webp -quiet $tempFile.FullName -o $destPath 2>&1
                if ($LASTEXITCODE -ne 0) { throw "gif2webp failed: $out" }
            }
            { $_ -in '.png', '.jpg', '.jpeg', '.bmp', '.tiff', '.tif' } {
                $out = & cwebp -quiet $tempFile.FullName -o $destPath 2>&1
                if ($LASTEXITCODE -ne 0) { throw "cwebp failed: $out" }
            }
            default {
                throw "unsupported image format '$ext'"
            }
        }

        return "/assets/blog/$BaseName.webp"
    } finally {
        Remove-Item -Path $tempFile.FullName -ErrorAction SilentlyContinue
    }
}

function Test-ExternalLink {
    param([string]$Url)

    try {
        Invoke-WebRequest -Uri $Url -Method Head @webRequestArgs | Out-Null
        return $null
    } catch {
        try {
            Invoke-WebRequest -Uri $Url -Method Get @webRequestArgs | Out-Null
            return $null
        } catch {
            if ($_.Exception.Response) {
                return "status $([int]$_.Exception.Response.StatusCode)"
            }
            return $_.Exception.Message
        }
    }
}

function ConvertTo-LocalPostPath {
    param([string]$Url)

    $uri = [uri]$Url
    $path = $uri.AbsolutePath
    if ($path -match '^/blog/(.*)$') { $path = "/$($Matches[1])" }
    if (-not $path.StartsWith('/')) { $path = "/$path" }
    if (-not $path.EndsWith('/')) { $path = "$path/" }
    return $path
}

function Convert-BodyImages {
    param(
        [string]$Body,
        [string]$Slug,
        [datetime]$PublishDate,
        [string]$AssetsDir
    )

    $state = [pscustomobject]@{ Seq = 0 }
    $issues = [System.Collections.Generic.List[string]]::new()
    $datePrefix = $PublishDate.ToString('yyyy-MM-dd')

    $pattern = '<img\b(?<pre>[^>]*?)\bsrc\s*=\s*(?<q>"|'')(?<src>[^"'']*)\k<q>(?<post>[^>]*)>'
    $evaluator = {
        param($m)

        $src = $m.Groups['src'].Value
        if ($src -notmatch '^https?://') { return $m.Value }

        $state.Seq++
        $n = $state.Seq

        try {
            $localSrc = Save-PostImageAsWebp -Url $src -DestinationDir $AssetsDir -BaseName "$datePrefix-$Slug-$n"
            return '<img' + $m.Groups['pre'].Value + 'src=' + $m.Groups['q'].Value + $localSrc + $m.Groups['q'].Value + $m.Groups['post'].Value + '>'
        } catch {
            $issues.Add("image #${n} (${src}): $($_.Exception.Message)")
            return $m.Value
        }
    }

    $newBody = [regex]::Replace($Body, $pattern, $evaluator, [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    [pscustomobject]@{ Body = $newBody; Issues = $issues }
}

function Convert-BodyLinks {
    param([string]$Body)

    $issues = [System.Collections.Generic.List[string]]::new()

    $pattern = '<a\b(?<pre>[^>]*?)\bhref\s*=\s*(?<q>"|'')(?<href>[^"'']*)\k<q>(?<post>[^>]*)>'
    $evaluator = {
        param($m)

        $href = $m.Groups['href'].Value
        if ($href -notmatch '^https?://') { return $m.Value }

        $uri = $null
        if (-not [uri]::TryCreate($href, [System.UriKind]::Absolute, [ref]$uri)) { return $m.Value }

        if ($ownDomains -contains $uri.Host) {
            $localHref = ConvertTo-LocalPostPath -Url $href
            return '<a' + $m.Groups['pre'].Value + 'href=' + $m.Groups['q'].Value + $localHref + $m.Groups['q'].Value + $m.Groups['post'].Value + '>'
        }

        $problem = Test-ExternalLink -Url $href
        if ($problem) {
            $issues.Add("link (${href}): ${problem}")
        }
        return $m.Value
    }

    $newBody = [regex]::Replace($Body, $pattern, $evaluator, [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    [pscustomobject]@{ Body = $newBody; Issues = $issues }
}

function Get-PreBlockLanguage {
    param(
        [string]$Attrs,
        [string]$Content
    )

    # Some highlighter plugins (e.g. the classic "CopySourceAsHtml"/CSharpCode
    # WLW plugin) name the language directly in the <pre> class - trust that
    # over any guesswork.
    if ($Attrs -match '(?i)class\s*=\s*(?<q>"|'')(?<class>[^"'']*)\k<q>') {
        $class = $Matches['class']
        if ($class -match '(?i)\bcsharpcode\b') { return 'csharp' }
        if ($class -match '(?i)\bvbcode\b') { return 'vb' }
        if ($class -match '(?i)\bsqlcode\b') { return 'sql' }
    }

    # Otherwise only guess a language for blocks that actually carry
    # syntax-highlighting markup (span tags) - a plain <pre> with no spans is
    # just as likely to be sample output or an XML snippet as it is source
    # code, so leave those untagged rather than mislabeling them.
    if ($Content -notmatch '<span\b') { return $null }

    if ($Content -match '(?im)\bEnd\s+(Sub|Function|Class|Module|If)\b|^\s*Dim\s+\w+\s+As\b|^\s*(Public|Private|Protected|Friend)\s+(Sub|Function|Module)\b') {
        return 'vb'
    }
    if ($Content -match '(?i)\b(SELECT\s+.+?\s+FROM|INSERT\s+INTO|UPDATE\s+.+?\s+SET|DELETE\s+FROM|CREATE\s+(TABLE|PROCEDURE|VIEW))\b') {
        return 'sql'
    }

    # This blog's highlighted snippets are overwhelmingly C#, and the classic
    # VS "paste as code" color scheme (blue/teal/maroon) doesn't distinguish
    # language on its own, so fall back to the blog's dominant language.
    return 'csharp'
}

function ConvertTo-NormalizedPreBlocks {
    param([string]$Html)

    # WordPress content commonly uses bare <pre>...</pre> (no nested <code>) for
    # code samples, sometimes with per-token <span> highlighting. Pandoc's HTML
    # reader only recognizes a <pre> as a code block when it wraps a <code>
    # element with at least one attribute (otherwise it's read as ordinary
    # prose/raw HTML - losing indentation, leaking <span> tags into the output
    # verbatim, and escaping underscores as if they were markdown italics).
    # Wrap bare <pre> content in <code>, tagging it with the detected language
    # (so the fenced block keeps syntax highlighting on the site) or a harmless
    # marker attribute when no language can be determined.
    $pattern = '(?is)<pre\b(?<attrs>[^>]*)>(?!\s*<code\b)(?<content>.*?)</pre>'
    [regex]::Replace($Html, $pattern, {
        param($m)

        $attrs = $m.Groups['attrs'].Value
        # Browsers ignore a single leading line feed right after <pre>; mirror
        # that so a source newline doesn't become a stray blank line in the
        # fenced block.
        $content = $m.Groups['content'].Value -replace '^\r?\n', ''

        $lang = Get-PreBlockLanguage -Attrs $attrs -Content $content

        # Pandoc's HTML reader takes the fenced-block's language from a
        # "language-*" class on the outer <pre> (not the inner <code>) when
        # both are present, so the class has to go there - merging with the
        # <pre>'s own class attribute (e.g. class="code") if it has one.
        if ($lang) {
            if ($attrs -match '(?i)class\s*=\s*("|'')') {
                $attrs = [regex]::Replace($attrs, '(?i)class\s*=\s*(?<q>"|'')(?<class>[^"'']*)\k<q>', {
                    param($cm)
                    'class=' + $cm.Groups['q'].Value + ($cm.Groups['class'].Value + ' language-' + $lang).Trim() + $cm.Groups['q'].Value
                })
            } else {
                $attrs = $attrs + ' class="language-' + $lang + '"'
            }
        }

        '<pre' + $attrs + '><code data-pandoc-force-fence="1">' + $content + '</code></pre>'
    })
}

function ConvertTo-SimplifiedAnchors {
    param([string]$Html)

    # Pandoc's HTML reader falls back to preserving an <a> tag as raw HTML
    # (instead of converting it to markdown link syntax) whenever it carries
    # an attribute markdown can't represent, e.g. target="_blank", rel, or
    # class - href and title are the only ones that survive the round trip.
    # Strip everything else so pandoc emits a normal [text](href) link.
    $pattern = '<a\b(?<pre>[^>]*?)\bhref\s*=\s*(?<q>"|'')(?<href>[^"'']*)\k<q>(?<post>[^>]*)>'
    $evaluator = {
        param($m)

        $title = ''
        $rest = $m.Groups['pre'].Value + ' ' + $m.Groups['post'].Value
        if ($rest -match '(?i)\btitle\s*=\s*("[^"]*"|''[^'']*'')') {
            $title = ' title=' + $Matches[1]
        }

        '<a href="' + $m.Groups['href'].Value + '"' + $title + '>'
    }
    [regex]::Replace($Html, $pattern, $evaluator, [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
}

function Invoke-PandocHtmlToMarkdown {
    param([string]$Html)

    $tempIn = New-TemporaryFile
    $tempErr = New-TemporaryFile
    try {
        Set-Content -Path $tempIn.FullName -Value $Html -NoNewline
        $stdoutLines = & pandoc -f html -t gfm --wrap=preserve $tempIn.FullName 2>$tempErr.FullName
        $exitCode = $LASTEXITCODE
        if ($exitCode -ne 0) {
            $stderrText = Get-Content -Path $tempErr.FullName -Raw
            throw "pandoc exited with code ${exitCode}: $stderrText"
        }
        # Pandoc writes fenced code blocks as "``` lang" (space before the
        # language); this repo's existing posts use "```lang" (no space).
        $markdown = ($stdoutLines -join "`n")
        return ($markdown -replace '(?m)^``` (\S+)$', '```$1')
    } finally {
        Remove-Item -Path $tempIn.FullName, $tempErr.FullName -ErrorAction SilentlyContinue
    }
}

# --- main ---

$resolvedPath = (Resolve-Path -Path $Path).ProviderPath
$content = Get-Content -Path $resolvedPath -Raw

$parts = Get-PostParts -Content $content

$imageResult = Convert-BodyImages -Body $parts.Body -Slug $parts.Slug -PublishDate $parts.PublishDate -AssetsDir $assetsDir
$linkResult = Convert-BodyLinks -Body $imageResult.Body

$issues = [System.Collections.Generic.List[string]]::new()

$markdownBody = $null
try {
    $normalizedHtml = ConvertTo-NormalizedPreBlocks -Html $linkResult.Body
    $normalizedHtml = ConvertTo-SimplifiedAnchors -Html $normalizedHtml
    $markdownBody = Invoke-PandocHtmlToMarkdown -Html $normalizedHtml
} catch {
    $issues.Add("conversion: $($_.Exception.Message)")
}

$issues.AddRange($linkResult.Issues)
$issues.AddRange($imageResult.Issues)

$finalBody = if ($null -ne $markdownBody) { $markdownBody } else { $linkResult.Body }

$header = ''
if ($issues.Count -gt 0) {
    $header = (($issues | ForEach-Object { "<!-- ISSUE: $_ -->" }) -join "`n") + "`n`n"
}

$newContent = $parts.Frontmatter + $header + $finalBody.Trim() + "`n"
Set-Content -Path $resolvedPath -Value $newContent -NoNewline

Write-Host "Converted: $resolvedPath"
if ($issues.Count -gt 0) {
    Write-Host "  $($issues.Count) issue(s) recorded:"
    $issues | ForEach-Object { Write-Host "    - $_" }
} else {
    Write-Host '  No issues.'
}
