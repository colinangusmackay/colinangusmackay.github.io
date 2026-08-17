---
title: "Microsoft Surface"
slug: microsoft-surface
publishDate: 10 Oct 2008
description: "Last weekend I was in Reading for the UK and Ireland MVP Open Day. And one of the highlights of the day was being invited to the Microsoft Technology Center at..."
tags:
  - { name: "Microsoft Surface", slug: microsoft-surface }
---

Last weekend I was in Reading for the UK and Ireland MVP Open Day. And one of the highlights of the day was being invited to the Microsoft Technology Center at Microsoft's Thames Valley Park campus and to able to have a wee play on a Microsoft Surface device.

![Microsoft Surface](/assets/blog/2008-10-10-microsoft-surface-1.webp)

I'm sure you've seen the videos of it and it looks as if it is really cool. But, the videos that are shown are all aimed at how cool the device is to use. They are designed to sell it to hotels and casinos and other companies that could use it to entertain or sell to their customers. How cool would it be to go along to a pub quiz and have your team answer on a surface device rather than on a paper form. The quiz could have extra features that you can't have in pub quizzes currently. The device could be used to show video or pictures to the quiz takers. In a tie-breaking situation the devices could record how quickly a team answered the questions and the tie is broken by the quickness of the responses. In fact there are a ton of things that you could do with it.

Now, I did see some of the cool applications for the surface device, such as the one to the left, but I also saw something that was way better to a geeky software developer like me. I saw some of the diagnostic side of it. I have to say that I'm really impressed.

![](/assets/blog/2008-10-10-microsoft-surface-2.webp)

First off lets start with what the device itself sees. It works by having a bunch of video cameras on the underside pointing up at the surface. The cameras aren't far reaching and can only really make out things that are within a few millimetres, or actually touching, the surface. As you pull your hand away the image gets faint very quickly. There is the ability to see what the cameras see in inverse (because if you have your hand touching the surface then the you won't see the image because your hand is obscuring it). As you can see from the image on the right the hand that is touching the device is very clear, where as the others that are perhaps only a few centimetres above aren't very visible, if at all. This means that any user who is animated about what is on the screen and is gesticulating during conversation is unlikely to accidentally affect the application unless they are near enough to almost touch it.

![](/assets/blog/2008-10-10-microsoft-surface-3.webp)

That's all very well and good, but what about writing applications. I don't want to have to interpret camera images. That's fine because all that is wrapped up in a framework that gives you useful information. For example, the picture to the left shows the information the Surface device feeds to the application developer when a person touches their finger to it. It is clever enough to identify the shape as a finger tip, it knows where it is on the surface and it can tell you the orientation. The fingers can be used in a similar way to a mouse, but with much more versatility.

![](/assets/blog/2008-10-10-microsoft-surface-4.webp)

One of the key points about the Microsoft Surface device is that it is multi-touch. As you can see from the image on the right the device has successfully recognised that there are 5 fingers touching it (no pedantic comments about thumbs, please) and there are 5 contacts in total (I'll come to the other types of contact in a moment). Under each contact point it displays a green oval representing where the touch is happening.

![](/assets/blog/2008-10-10-microsoft-surface-5.webp)

A blob is an object that is too large to be a finger is placed on the device, whereas a tag is something that has a recognisable tag attached to it. The tag identifies a portable device to the Surface. In the image on the left the phone has a tag attached to it. It allows the Surface to identify it. It can also determine the orientation of the phone (as can bee seen by the white arrow drawn on the Surface). Once the Surface recognises the device it can then interact with it.

If all this looks a bit much, it isn't. A Microsoft Surface device is simply running Microsoft Windows Vista and the applications are written in WPF with an extra bit of goo that allows multi-touch interaction in an almost Minority Report kind of way, if only it were wall mounted and 2m by 3m in size.

All in all, it was an excellent demo, if a bit short. I would have liked to ask more questions about the SDK and actually seen how some of the applications were written (but that's just me - I like to read code).
