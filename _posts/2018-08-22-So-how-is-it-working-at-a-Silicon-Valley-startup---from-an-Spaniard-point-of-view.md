---
title: >-
  So how is it working at a Silicon Valley startup? <sup><sub><sub>(from a Spaniard point of
  view)</sub></sub></sup>
date: 2018-08-22
excerpt: >-
  I already had been in the loop a couple of times. So when the headhunter told me it was a long and exhausting process
  I was not surprised. A month later I was flying to San Francisco to start my new adventure.
categories:
  - Personal
  - Software Engineering
tags:
  - personal
  - intro
  - startups
  - engineering
toc: false
toc_sticky: true
header:
    teaser:        /assets/images/posts/So-how-is-it-working-at-a-Silicon-Valley-startup/hardik-pandya--Ey_0PMz900-unsplash-hdpi.jpg
    overlay_image: /assets/images/posts/So-how-is-it-working-at-a-Silicon-Valley-startup/jordi-vich-navarro-hmL0CzO9XMY-unsplash-xxhdpi.jpg
    overlay_filter: 0.5
classes: wide
---

# The Loop

I already have been *in the loop* a couple of times.

The first one was at a hiring event from Amazon at Madrid. I got the first call late August, and I was interviewing 
on-site on the first week of September. I had not prepared the interview properly, I had a lot of fun and met a lot of
[interesting](https://www.linkedin.com/in/terryleeper/) [people](https://www.linkedin.com/in/viveksagi/).

To be honest, I think I messed up those both interviews; first because my English skills were British based, and 
I found really hard to understand American accents (and Terry’s accent when spelling *restaurant* was something 
I couldn’t handle) and second, because I messed up an algorithm to generate uuid's... I over-engineered it
with offline producers, caches and other fancy stuff instead of just using big hashes with low collision certainty... 
I have grown as engineer since that one, *heh!*

The second one was also an attempt at Amazon a couple of years later, but this time I got like a month to prepare.
Yes, I know people spend even a couple of years preparing for the big four, but I was not eager to move. I did not meet 
as interesting people as the first time and though I enjoyed the time spent preparing the interview, working on 
algorithms, refreshing big-O and big-T specs and doing a lot of practice. I did not enjoy the interview itself since 
didn’t feel as a challenge (*hint for applicants:* a [radix sort](https://www.cs.usfca.edu/~galles/visualization/RadixSort.html) 
backed by an array, or a heap backed by an array are good exercises to get involved in any language; move later to a 
balanced tree — bonus points if you back it in an array, again; and some dynamic programming after that, and you’ll be 
almost ready).

Again I messed up with the raiser and ended talking about nice to haves instead of focusing on must haves. 
I realized that during the interview, but I got nervous and was unable to re-steer, so I gave up and never thought about 
switching back to *software engineering* again (as a job, keeping that as a hobby).

So there I was, CTO of a *fin-tech*, which usually means that you have to do or at least touch everything, when a 
headhunter called me about an opportunity on a Silicon Valley startup building an engineering team in Madrid.

As I said, *I already had been in the loop a couple of times.* So when the headhunter told me it was a long and 
exhausting process (***headhunter tip:*** use *intense* instead) I was not surprised. 

Having to do a [hackerrank](https://www.hackerrank.com/) test was normal for me, but I learned later (when I was the 
one interviewing) that it surprised some fellow Spanish engineers. Nor was I shocked by having to meet several people 
during the process. I enjoyed the process and I gathered enough information during it to make my mind about the 
company (***applicant tip:*** ask about how is the job / challenges faced / etc.; ***company tip:*** I’m going to browse
your LinkedIn employees profiles so make us a favor and put a *team.html* page in your website!)

# San Francisco

So there I was, a month and a half later, in a flight from Madrid to San Francisco that got redirected to Oslo, arriving
more than 24h late to my first day in the valley.

<img src="/assets/images/posts/So-how-is-it-working-at-a-Silicon-Valley-startup/standing-desk-300x400.jpg" 
     alt="Image of a standing desk with an ultrawide monitor" />{: .align-right}

One thing that gladly surprised me was that **there was indeed an on-boarding process**, in this case a github repo in 
form of a wiki that was being moved to confluence and being updated constantly by every new engineer joining the 
company. I really appreciated that. One can check the history and see how it evolved or how things were done in the 
past. This is not so common in Spain or Europe, at least on the big companies I had been working with. Usually it was
me holding the hand of new people during a couple of weeks, but being alone with the *wiki* while having the coworkers
just one table from your desk is an improvement and also can serve as first week fit-or-not-fit as needed. This also
improves the team itself since there is no holding hands involved and thus, not biased impressions.

I was assigned one of those standing desk (the owner was at Madrid training one of our Ruby engineers, thanks Tom!), 
and I loved it. So there I was, fighting with a Mac after +20 years of Linux / windows keyboards(*note to applicants:* 
it gets really weird to use a different shortcut keys for common tasks; muscle memory is a handicap) and following the 
documentation, until I gave up and finally I got the courage to ask about all those services around our infra.

## As-A-Service

> *This is the standard technology stack here in the valley*. Expect *Everything-as-a-Service* approach.

This means everything is serviced, not just the servers running our micro-services.

_E-v-e-r-y-t-h-i-n-g._
 
Database documentation and versioning? there is a SaaS that does just that. BI? Same. Logs? Collected in a SaaS 
platform. Metrics, CI? Yup, also as-a-service.

Here, in Spain, even companies struggle to use their code repositories as a service.
Why if an old desktop with a couple of hard disks can serve that purpose... ? (seriously, even today, I find companies 
hosting their own solutions **without** a proper sysadmin or devops dedicated to their repos or, if any, their CI 
processes).

## Agile

And I got an architecture *brown-bag* (I love brown-bags!). A *brown-bag* is the paper bag where you pack your lunch. 
In the *slang* of the agile methodologies usually means that everyone is expected to bring a brown-bag while a coworker
explains something during lunch, or more *formal* definition (pun intended) *an informal meeting, training, or 
presentation that happens in the workplace*.

## Onboarding

So there I was. I spent the rest of my first week setting up my computer, this time, knowing exactly what I was doing 
(that is, understanding that a given setup page was referring, for example, to the tool that collected the logs, while 
another part of the setup was for a VPN access to another tool, etc.) and exploring our documentation, browsing the 
database and trying to hack my new MacOS shortcuts (*hint: resistance is futile*)

# Surprises
One thing that really surprised me was the lack of email communication. I really enjoyed that. At my previous job, 
I was handling over 250 emails per day, of which only half of them were alerts and about two thirds of the remaining 
ones were actionable. Really! I had developed a small google apps script to monitor email usage across the organization, 
and it was funny to see the stats, specially over the weekends, where the CXOs were replying between 10 and 25 
emails / day... *on weekends!*

I had tried, back in 2004 to implement internal messaging with [Openfire](https://en.wikipedia.org/wiki/Openfire) 
(just before they had to change their name) while using Netbeans pairing features (even remote debugging, that collab 
suite tool was really ahead of its time... you can see more of it in action 
[here](https://netbeans.org/kb/articles/quickstart-collaboration.html)) and implement pair-programming in Spain 
by 2004–2005 but I had no success (*hint: managerial skills and tons of experience are needed to manage the managers 
above you*).

Working in a company that is really agile, where every bit of communication is handled on slack is impressive.
Every alert, from lambdas to GitHub or build processes, the #911 channels (for Europeans, that is #112), 
integration with almost every tool you can imagine (Jira, confluence, google apps, Hangouts, Webex, skype...). 

A dream come true.

Another thing that hits you (specially if you come from a big corporation) is the ownership feeling. 

I have always wanted owners in my coworkers and when I have been hiring ownership is always more important than 
knowledge (once there is a basic level of aptitude, attitude is really important). 
Do you see an improvement anywhere? Create a ticket or PR to fix / improve it. 
There is no “not my project”; there are repos where you are codeowner but the **product is us**. 
Everyone is eager to help, there are no one-man shows nor one-man mistakes. 
If somebody messes up something, makes no sense talking about it but how to avoid it next time, 
what *postmortem* conclusions can we as a team extract to add mitigation measures or alerts to completely prevent it 
from happening again.

# Startup Philosophy

Working in a startup is amazing; specially if you are lucky enough to find one that feeds your internal hunger
(I have!). 

Expect to learn **a lot**. Not only new tools but new paradigms or languages. 
I have been an avid Java engineer in the past and now I’m loving Kotlin. 
I had never tried functional programming before but once you start feeling confident, the code just flows.

Coworkers are amazing. The most junior engineer is light-years ahead of the so-called seniors in Spanish companies, 
at least on my startup. 

You can talk with them about any advanced computer science concept face to face, mind to mind.

Every month spent here is worth a semester on a European corporation.

Also, it has its drawbacks; frustration, feeling rusty, like back in college (hey, why the hell is this not working) 
and then getting that feeling, the push... when you are working and time passes, and you wanna keep writing code 
(or a cool blog post), or go through the rabbit hole to understand how this new piece of tech internals work, but you 
can’t because *a)* you have a family to attend or *b)* deadlines!

## Ownership

This last bit is really important.

There is no product pushing your to develop some functionality (well, it is but that’s not the point). 
Runway ahead, code needs to be pushed, or we ran out of asphalt, fuel or *money.*

This is competitive, against other startups that are either trying to copy you or are ahead of you. 
It is you who focus on the functionalities, even if product tries to push you. 
Everyone is *rowing in the boat* in the same direction, no exceptions. 
If anyone is getting behind, we all help him but if there is no way to set him or her for success, then we all lost, so 
it is usually better to let them go. No exceptions. That one can be me or you fellow reader. 

There is always a second opportunity but keep in mind that the cultural differences are shocking sometimes.
 
The cultural barrier for Europeans there is really big. For example, feedback where people don’t tell you what you need 
to do but what worked for them, so sometimes one starts thinking if a given advice is a *yellow flag* or just advice. 
This helps to develop the trust in the teams but is shocking at first from an European (specially Mediterranean)
perspective. Maybe this post is getting too big, and I need to talk about it later.

# Epilogue

So this is how it feels, from the point of view an engineer that has been working on different kinds 
(size, sector, scope) companies, working in an Silicon Valley startup.

I’m looking forward to my next visit to SF to keep learning. If one month in a startup is worth six in a corporation, 
one week there (SF) is worth a month away.

How productive we could be if only the managers of the big software factories in Spain opened their minds and adopted a 
*learning posture* instead of that demigod behavior they have sometimes 
(disclaimer: not everyone, specially if you are reading this there is a high chance you are the exception, my friend).

_Originally published in_ [<i class="fab fa-fw fa-medium"></i>Medium](https://medium.com/@juan_ara/so-how-is-it-working-at-an-american-startup-from-an-spaniard-point-of-view-a04260b517b0)
