<#
.SYNOPSIS
    Extracts published posts from a WordPress WXR export into Astro content-collection markdown files.

.DESCRIPTION
    Reads a WordPress eXtended RSS (WXR) export XML file, finds every <item> where
    wp:post_type is "post" and wp:status is "publish", and writes one .md file per
    post into src/data/blog-posts/<year>/<month>/<day>/<slug>.md (dates from
    wp:post_date_gmt), with frontmatter matching the site's content collection schema
    (title, slug, publishDate, description, tags). Tags are taken from each item's
    <category domain="post_tag"> elements, using WordPress's own "nicename" as the
    tag slug.

    Post bodies are copied verbatim as HTML (WordPress content:encoded is HTML, not
    Markdown) with a TODO comment at the top of the body flagging them for manual
    conversion to Markdown.

.PARAMETER XmlPath
    Path to the WordPress export XML file. Defaults to the first *.xml file found in
    the repo's .data directory.

.PARAMETER OutputDir
    Directory to write the extracted posts into. Defaults to src/data/blog-posts
    relative to the repo root.

.EXAMPLE
    pwsh .scripts/Export-WordPressPosts.ps1
#>
[CmdletBinding()]
param(
    [string]$XmlPath,
    [string]$OutputDir
)

$ErrorActionPreference = 'Stop'

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot '..')

if (-not $XmlPath) {
    $dataDir = Join-Path $repoRoot '.data'
    $xmlFile = Get-ChildItem -Path $dataDir -Filter '*.xml' -File | Select-Object -First 1
    if (-not $xmlFile) {
        throw "No .xml file found in $dataDir. Pass -XmlPath explicitly."
    }
    $XmlPath = $xmlFile.FullName
}

if (-not $OutputDir) {
    $OutputDir = Join-Path $repoRoot 'src/data/blog-posts'
}

function ConvertTo-YamlDoubleQuoted {
    param([string]$Value)
    $escaped = $Value -replace '\\', '\\\\' -replace '"', '\"'
    return '"' + $escaped + '"'
}

function ConvertTo-PlainText {
    param([string]$Html)
    $text = $Html -replace '<[^>]+>', ' '
    $text = [System.Net.WebUtility]::HtmlDecode($text)
    $text = $text -replace '\s+', ' '
    return $text.Trim()
}

function Get-Description {
    param([string]$Html, [int]$MaxLength = 160)
    $text = ConvertTo-PlainText -Html $Html
    if ($text.Length -le $MaxLength) {
        return $text
    }
    $truncated = $text.Substring(0, $MaxLength)
    $lastSpace = $truncated.LastIndexOf(' ')
    if ($lastSpace -gt 0) {
        $truncated = $truncated.Substring(0, $lastSpace)
    }
    return $truncated.TrimEnd() + '...'
}

function Get-PostTags {
    param([System.Xml.XmlElement]$Item, [System.Xml.XmlNamespaceManager]$NsManager)
    $tagNodes = $Item.SelectNodes('category[@domain="post_tag"]', $NsManager)
    return @(foreach ($tagNode in $tagNodes) {
        [PSCustomObject]@{
            Name = [System.Net.WebUtility]::HtmlDecode($tagNode.InnerText)
            Slug = $tagNode.Attributes['nicename'].Value
        }
    })
}

function ConvertTo-YamlTagsBlock {
    param([array]$Tags)
    if ($Tags.Count -eq 0) {
        return 'tags: []'
    }
    $lines = foreach ($tag in $Tags) {
        "  - { name: $(ConvertTo-YamlDoubleQuoted $tag.Name), slug: $($tag.Slug) }"
    }
    return "tags:`n" + ($lines -join "`n")
}

Write-Host "Loading $XmlPath ..."
[xml]$xml = Get-Content -Path $XmlPath -Raw

$nsManager = New-Object System.Xml.XmlNamespaceManager($xml.NameTable)
$nsManager.AddNamespace('wp', 'http://wordpress.org/export/1.2/')
$nsManager.AddNamespace('content', 'http://purl.org/rss/1.0/modules/content/')
$nsManager.AddNamespace('excerpt', 'http://wordpress.org/export/1.2/excerpt/')

$items = $xml.SelectNodes('//item[wp:post_type="post" and wp:status="publish"]', $nsManager)
Write-Host "Found $($items.Count) published posts."

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
$count = 0

foreach ($item in $items) {
    $title = $item.SelectSingleNode('title', $nsManager).InnerText
    $slug = $item.SelectSingleNode('wp:post_name', $nsManager).InnerText
    $dateGmtRaw = $item.SelectSingleNode('wp:post_date_gmt', $nsManager).InnerText
    $bodyHtml = $item.SelectSingleNode('content:encoded', $nsManager).InnerText

    $dateGmt = [DateTime]::ParseExact($dateGmtRaw, 'yyyy-MM-dd HH:mm:ss', [System.Globalization.CultureInfo]::InvariantCulture)

    $decodedTitle = [System.Net.WebUtility]::HtmlDecode($title)
    $description = Get-Description -Html $bodyHtml
    $publishDate = $dateGmt.ToString('dd MMM yyyy', [System.Globalization.CultureInfo]::InvariantCulture)
    $tags = Get-PostTags -Item $item -NsManager $nsManager

    $year = $dateGmt.ToString('yyyy')
    $month = $dateGmt.ToString('MM')
    $day = $dateGmt.ToString('dd')

    $postDir = Join-Path $OutputDir (Join-Path $year (Join-Path $month $day))
    New-Item -ItemType Directory -Path $postDir -Force | Out-Null
    $filePath = Join-Path $postDir "$slug.md"

    $frontMatter = @(
        '---'
        "title: $(ConvertTo-YamlDoubleQuoted $decodedTitle)"
        "slug: $slug"
        "publishDate: $publishDate"
        "description: $(ConvertTo-YamlDoubleQuoted $description)"
        (ConvertTo-YamlTagsBlock $tags)
        '---'
    ) -join "`n"

    $content = $frontMatter + "`n" + "<!-- TODO: convert this post's content to Markdown -->`n`n" + $bodyHtml + "`n"

    [System.IO.File]::WriteAllText($filePath, $content, $utf8NoBom)
    $count++
}

Write-Host "Extracted $count posts into $OutputDir"
