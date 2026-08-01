---
title: "The new Model VIew Controller"
slug: the-new-model-view-controller
publishDate: 23 Jun 2007
description: "I've always had an inkling that there was something not quite right about Model-View-Controller pattern. Something didn't sit right with me that (1) the View..."
tags:
  - { name: "design patterns", slug: design-patterns }
  - { name: "mvc", slug: mvc }
  - { name: "mvp", slug: mvp }
---
<!-- TODO: convert this post's content to Markdown -->

I've always had an inkling that there was something not quite right about Model-View-Controller pattern. Something didn't sit right with me that (1) the View ask the Controller to do something, (2) the Controller in turn manipulated the Model, (3) the Model would emit events to tell the View that it had changed and finally (4) the View would query the Model to in order to update the display.

<img src="http://static.flickr.com/50/143674227_87e7c6f6e0_o.png" alt="MVC" width="616" height="485" />

In the traditional fashion the Model knows nothing of the View - which is just as it should be. But the View, in my opinion, knew too much about the Model.

I felt that the View shouldn't know anything about the Model. But many books on the subject seemed to be suggesting strongly that this was the correct way to do things. It seems that many people shared my opinion which is why there is the Model-View-Presenter pattern which is now gaining acceptance.

First off, let's take a step back. What are the Model, View and Controller?

The View is the visualisation of the Model to the user; It is the web page or the windows form.

The Model contains the business objects, although it could just be a proxy for a service layer.

The Controller is the thing that manipulates the Model on behalf of the view. In many applications the Controller gets tightly coupled to the view as it is absobed into the code behind class in Web Forms and so on. Strictly speaking, it should be a separate class. When the Controller is a separate class, it can be part of the Strategy pattern, which means that one controller class can be swapped for another if you want the view to have different behaviour.

So, what about this Presenter? Well the presenter is the replacement for the controller. In this case (1) the View ask the Presenter to do something, (2) the Presenter in turn manipulated the Model, which are the same steps as in the Model-View-Controller, but finally (3) the Presenter updates the View. In this case the Model does not emit events that are handled in the View and the View does not know anything about the Model.

<img src="http://static.flickr.com/52/143681783_0dcb5982b2_o.png" alt="MVP" width="639" height="512" />

Now the interesting thing is that the Presenter has no knowledge of UI controls at all. It does not depend on the view. It just depends on an interface that the view implements. This has a big benefit when it comes to unit testing. The UI class can be mocked with another class that implements the same interface and so the Presenter, which contains the bulk of the user interaction code, can be unit tested easily.

You'll notice that in the second diagram there were no events being fired by the Model. This can still occur if necessary. For example, if there are many views open and the user updates one, the model can emit events that the presenters responsible for the other views can pick up on. So, the difference is just in which object receives and handles the events.

If you want to se a practical demonstration of the Model-View-Presenter pattern then you might like to download the dnrTV show by <a href="http://www.dnrtv.com/default.aspx?showID=14">Jean-Paul Boodhoo on the MVP pattern</a>.

<em>NOTE: This was rescued from the Google Cache. The original date was Wednesday, 10th May, 2006.</em>

Tags: <a rel="tag" href="http://technorati.com/tag/mvc"><img style="border:0;vertical-align:middle;margin-left:.4em;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=mvc" alt=" " />mvc</a> <a rel="tag" href="http://technorati.com/tag/model+view+controller"><img style="border:0;vertical-align:middle;margin-left:.4em;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=model+view+controller" alt=" " />model view controller</a> <a rel="tag" href="http://technorati.com/tag/mvp"><img style="border:0;vertical-align:middle;margin-left:.4em;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=mvp" alt=" " />mvp</a> <a rel="tag" href="http://technorati.com/tag/model+view+presenter"><img style="border:0;vertical-align:middle;margin-left:.4em;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=model+view+presenter" alt=" " />model view presenter</a> <a rel="tag" href="http://technorati.com/tag/ui"><img style="border:0;vertical-align:middle;margin-left:.4em;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=ui" alt=" " />ui</a> <a rel="tag" href="http://technorati.com/tag/presentation+layer"><img style="border:0;vertical-align:middle;margin-left:.4em;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=presentation+layer" alt=" " />presentation layer</a> <a rel="tag" href="http://technorati.com/tag/business+layer"><img style="border:0;vertical-align:middle;margin-left:.4em;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=business+layer" alt=" " />business layer</a> <a rel="tag" href="http://technorati.com/tag/model"><img style="border:0;vertical-align:middle;margin-left:.4em;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=model" alt=" " />model</a> <a rel="tag" href="http://technorati.com/tag/view"><img style="border:0;vertical-align:middle;margin-left:.4em;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=view" alt=" " />view</a> <a rel="tag" href="http://technorati.com/tag/controller"><img style="border:0;vertical-align:middle;margin-left:.4em;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=controller" alt=" " />controller</a> <a rel="tag" href="http://technorati.com/tag/presenter"><img style="border:0;vertical-align:middle;margin-left:.4em;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=presenter" alt=" " />presenter</a> <a rel="tag" href="http://technorati.com/tag/design+patterns"><img style="border:0;vertical-align:middle;margin-left:.4em;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=design+patterns" alt=" " />design patterns</a> <a rel="tag" href="http://technorati.com/tag/design"><img style="border:0;vertical-align:middle;margin-left:.4em;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=design" alt=" " />design</a>
