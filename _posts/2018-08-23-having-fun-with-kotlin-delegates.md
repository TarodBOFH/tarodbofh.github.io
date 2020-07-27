---
template: post
title: Having fun with Kotlin delegates
date: 2018-08-23
excerpt: >-
  I have been learning Kotlin lately, and I have been playing with delegates and
  reified functions. By using composition over inheritance, we'll compose some classes with kotlin data classes and 
  delegate some properties to either other properties or method calls. 
classes: wide
categories:
  - Software Engineering
tags:
  - kotlin
  - reified
  - delegate pattern
  - tips
header:
    teaser:        /assets/images/kotlin/louis-tsai-lqcvMiBABHw-unsplash-hdpi.jpg
    overlay_image: /assets/images/kotlin/matt-mckenna-LfjR6IOL7ts-unsplash-xxhdpi.jpg
    overlay_filter: 0.75
---
I have been learning Kotlin [lately]({% post_url 2018-08-22-So-how-is-it-working-at-a-Silicon-Valley-startup---from-an-Spaniard-point-of-view %}),
and playing with delegates and reified functions.
For those that don’t know yet, a [delegate](https://en.wikipedia.org/wiki/Delegation_pattern) is an object-oriented 
design or programming pattern. As [Grady Booch](https://www.linkedin.com/in/gradybooch) stated: *“ is a way to make 
composition as powerful for reuse as inheritance”*

Our code generator generated [kotlin data classes](https://kotlinlang.org/docs/reference/data-classes.html) to be used 
as POJOs/DTOs from *jooq*, but being as paranoid as possible with database normalization some business needs involving 
fields from more than a few distinct POJOs. We are not using nor will use lazy fetching nor collections / entity trees 
even on the near future — *I could probably write an entry about why it is bad in the near future*; so some boilerplate 
code was involved. To be completely honest, I was trying to write some [reified](https://kotlinlang.org/docs/reference/inline-functions.html) 
code to try to make a wrapper/delegate pattern on the data classes, but I gave up before the third or fourth tunnel deep 
in the rabbit hole.

The main *problem* and **advantage** with data classes in Kotlin is that they are final. You cannot inherit from them. 
So you cannot override them, which is good, but in my case, just wanting to add some flavor to already existing objects 
was a pain:

{% gist e4f7e0237ddc8adcf8161e4a974a1dda %}

What I have above is a scaffolding setup for users based on a tenant. 
Say my service is used by tenants whose users interact through their API with my platform. 
I have my `User`, the `ExternalUser` and the `Tenants` tables, which translate to the rough POJOs in kotlin (yes, data 
classes in kotlin generate those pesky getters, setters, equals and hashcode methods for you).
Each of my tenants users have some credit (we all want to make money, yay!).

So what happens when I need to know the credit a given external user holds within a given tenant? 
Either I have to write a new POJO or [delegate](https://kotlinlang.org/docs/reference/delegated-properties.html) 
it (hint: *same effort*):

{% gist 2015ccb2b6351265988f6a876b27fc24 %}

The above code, through pretty, won’t compile (d’oh!) but fortunately, we potentially can use delegates and reified 
inline functions to work around it:

{% gist 3fb3c6657d9b69a8bfdfd0e03de70683 %}

A reified function is a function that will allow typed values based on where and how it is used. 
The compiler will *guess* the proper types and make its magic for us. 
I have implemented two functions, one accepts a block that returns any value `T` and other one accepts a value `T`. 
The good thing of them is that one can extend the functionality easily:

{% gist 12f2fd4024caccd09aee3f73472092b9 %}

I have removed the value based `delegate` since you can use the functional now (much more readable!), and we added 
another type of users that have bonus credit (use your imagination here). 
For the sake of the reader I added a main function, so you can run this code whenever you want or in the 
online [kotlin interpreter](https://try.kotlinlang.org) (just paste the code there and hit run).

So in my real case I called my *decorated* classes DTO (how original, isn’t it?) instead of using delegation, and I 
added some flavor to them because I needed to transform to a custom library JSON object that I could not modify.

What is the deal then and why did I write my own DTO as the first example instead? 
When writing the tests, I personally find easier to mock a given object and not all the delegation or delegate ones, 
but on the other hand, delegation allows you to skip that part of the tests (well, the delegated object will have its 
own tests, right?). 
I’m still playing around with Kotlin, so I have not yet made up my mind about which approach to use.

Performance wisely speaking, even having caches between your data layer and your service, you will need to query either 
the caches or the database for all the objects. 
While in the past minimizing data packets was a gain, I don’t think it is anymore, specially as I have stated that the 
databases are properly normalized and no redundant information sits there. 
Of course if you are using a document-based database you will probably have other issues and needs but surely you’ll 
have learnt something from this.

_Originally published in_ [<i class="fab fa-fw fa-medium"></i>Medium](https://medium.com/@juan_ara/having-fun-with-kotlin-delegates-5c819007b343)
