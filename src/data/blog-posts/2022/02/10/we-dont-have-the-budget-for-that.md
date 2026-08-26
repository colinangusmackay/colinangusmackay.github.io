---
title: "We don't have the budget for that"
slug: we-dont-have-the-budget-for-that
publishDate: 10 Feb 2022
description: "Over 20 years ago, I was asked by the company I worked for to fly out and help a client with an issue. It seems that they had trouble printing in certain..."
tags: []
---
Over 20 years ago, I was asked by the company I worked for to fly out and help a client with an issue. It seems that they had trouble printing in certain scenarios and they wanted me to fix the problem.

The client did a lot of civil engineering projects and needed to print out large (A0 sized) maps with the details of the works to be completed marked up on them. However, when the map was rotated it often cropped the last few centimetres off the print, and often times this meant it cropped off the legend at the edge of the map or other important details.

I arrived at the client's office and within a few hours I'd diagnosed the issue. When the map was printed with north pointing up everything was fine. Same for a rotation of 90, 180 or 270 degrees. But any other angle and the print out would be cropped to some degree or another.

The software used some optimisations for the multiple of 90 degree rotations, but couldn't do that for other arbitrary rotations. As a result more memory was being used.... and somehow that translated into the print being cropped.

So, within a few hours of being on-site I had worked out what the issue was. I found out the right type of memory needed and how much, and I told the client.

"Sorry, we don't have the budget for that," I was told. "We need you to find a way for the software to use less memory".

So I told them that would take me a while and would certainly cost more than my company was charging them to fly me out, put me up in a hotel, and billing them for my time once I was actually on site. In fact, the memory upgrade would cost somewhere around 1 or 2 days of my time, whereas I had no idea how long it would take me (if it was even possible) to re-write the software to do what they wanted.

They were adamant that I stay and find a software solution to their problem as they had money in a different budget that they could spend on my time. So, for the next few weeks I flew out each Monday, was put up in a hotel, and flew home on the Friday trying to find a software solution to their problem.

Then the money in the budget they were using to pay for my time ran out too. They had paid the company I worked for the equivalent of about 15 to 20 memory upgrades by this point.

About 3 months later I got an email from one of the people in that office to say they had started a new financial year, had got a new budget, and had bought the memory upgrade I suggested they needed on day one. It had worked perfectly. The printouts were no longer being cropped regardless of how the map was being rotated.
