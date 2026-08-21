---
title: "Tasks that create more work"
slug: tasks-that-create-more-work
publishDate: 01 Apr 2011
description: "I’m creating a program that parses a web page then follows the links and then parses the next set of web pages to eventually build a picture of an entire site...."
tags:
  - { name: ".NET", slug: net }
  - { name: "C#", slug: c }
  - { name: "ConcurrentDictionary", slug: concurrentdictionary }
  - { name: "ConcurrentQueue", slug: concurrentqueue }
  - { name: "Parallel.ForEach", slug: parallel-foreach }
  - { name: "parallelisation", slug: parallelisation }
  - { name: "parallelization", slug: parallelization }
  - { name: "TaskCreationOptions", slug: taskcreationoptions }
  - { name: "Tasks", slug: tasks }
---
I’m creating a program that parses a web page then follows the links and then parses the next set of web pages to eventually build a picture of an entire site. This means that as the program runs more work is being generated and more tasks can be launched to process each new page as it is discovered.

My original solution was simply to create code like this:

```csharp
private void ProcessLink(string link)
{
    var page = GetPageInformation(link);
    var newLinks = GetNewLinks(page);
 
    foreach(var newLink in newLinks)
    {
        Action action = () => {  ProcessLink(newLink); };
        Task.Factory.StartNew(action, TaskCreationOptions.AttachedToParent);
    }
}
```

The premise is simple enough, build a list of new links from a page then for each of the new links start a new task. The new task is attached to the parent task (the task that is launching the new set of tasks)

However, it soon became apparent that this was quickly getting out of control and I had no idea what was still waiting to be processed, or that the same link was being queue up multiple times in many different threads and so on. I ended up putting in place so many mechanisms to prevent the code processing the same page over again in different threads that it was getting silly. For a small number of new tasks being launched, I’m sure that Task.Factory.StartNew() is perfectly suitable.

I eventually realised that I was heading down the wrong way and I needed to rethink my strategy altogether. I wanted to make the code parallelisable so that while I was waiting on one page I could be parsing and processing another page. So, I eventually refactored it to this:

```csharp
public class SiteScraper
{
    private ConcurrentDictionary<string, ScraperResults> completedWork = 
        new ConcurrentDictionary<string, ScraperResults>();
 
    private List<string> currentWork;
 
    private ConcurrentQueue<string> futureWorkQueue = 
        new ConcurrentQueue<string>();
 
    public void GetSiteInformation(string startingUrl)
    {
        currentWork = new List<string();
        currentWork.Add(startingUrl.ToLowerInvariant());
 
        while(currentWork.Any())
        {
            Parallel.ForEach(currentWorkQueue, item => GetPageInformation(item));
            BuildWorkQueue();
        }
    }
 
    private void BuildWorkQueue()
    {
        currentWork = new List<string>(futureWorkQueue
            .Select(link => link.ToLowerInvariant()).Distinct()
            .Where(link => IsLinkToBeProcessed(link)));
 
        futureWorkQueue = new ConcurrentQueue<string>();
    }
 
    private void GetPageInformation(string url)
    {
        // Do stuff
        ProcessNewLinks(newLinks)
    }
 
    private void ProcessNewLinks(IEnumerable<string> newLinks)
    {
        foreach (string url in newLinks.Where(l => IsLinkToBeProcessed(l)))
        {
            futureWorkQueue.Enqueue(url);
        }
    }
 
    // Other bits
}
```

There is still some code to ensure duplicates are removed and not processed, but it become much easier to debug and know what has been processed and what is still to be processed than it was before.

The method `GetSiteInformation` (lines 11-21) handles the main part of the parallelisation. This is the key to this particular algorithm.

Before discussing what that does, I just want to explain the three collections set up as fields on the class (lines 3 to 9). The completedWork is a dictionary keyed on the url containing an object graph representing the bits of the page we are interested in. The `currentWork` (line 6) is a list of the current urls that are being processed. Finally, the `futureWorkQueue` contains a queue of all the new links that are discovered, which will feed into the next iteration.

The `GetSiteInformation` class creates the initial list of `currentWork` and processes it using `Parallel.ForEach` (line 18). On the first iteration only one item will be processed, but it should result in many new links to be processed. A call to `BuildWorkQueue` builds the new work queue for the next iteration which is controlled by the while loop (lines 16-20). When BuildWorkQueue creates no new items for the workQueue then the work is complete and the while loop exits.

`BuildWorkQueue` is called when all the existing work is completed. It then builds the new set of urls to be processed. The `futureWorkQueue` is the collection that was populated when the links get processed (see later). All the links are forced into lower case (while this may not be advisable for all websites, for my case it is sufficient), only distinct elements are processed as the futureWorkQueue could quite easily have been filled with duplicates and finally a check is made to ensure that the link has not already been processed (lines 25-27).

During the processing of a specific URL (lines 32-36 – mostly not shown) new links may be generated. Each of these will be be added to the futureWorkQueue (lines 40-43). Before enqueuing any link a check is made to ensure it has not already been processed.

There are other bits of the class that are not shown. For example the IsLinkToBeProcessed method (which checks the domain, whether it has been processed already and so on) and the code that populates the completedWork.

In this version of the code it is much easier to see what has been completed and what is still to do (or at least, what has been found to do).
