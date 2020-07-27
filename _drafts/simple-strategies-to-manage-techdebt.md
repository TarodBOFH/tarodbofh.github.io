---
template: post
title: "Strategies to manage Technical Debt"

excerpt: >- 
    Sometimes teams struggle to identify which technical debt items are worth investing into or how to align them to 
    company goals. 
    We recently had some internal sessions to discuss this topic, and we came with a simple strategy to classify and 
    measure techdebt across teams while having a chance to align it with product needs.
toc: false
toc_sticky: true
categories:
  - Software Engineering
tags: 
    - software architecture
    - enterprise architecture
    - technical debt
    - tech-debt
    - techdebt
header:
    teaser:        /assets/images/posts/simple-strategies-to-manage-techdebt/alice-pasqual-Olki5QpHxts-unsplash-hdpi.jpg
    overlay_image: /assets/images/posts/simple-strategies-to-manage-techdebt/ruth-enyedi-zuwx2tvI_iM-unsplash-xxhdpi.jpg
    overlay_filter: 0
classes: wide

gallery1:
  - image_path: ""
  - url: /assets/images/unsplash-gallery-image-2.jpg
    image_path: /assets/images/unsplash-gallery-image-2-th.jpg
    alt: "placeholder image 2"
    title: "Image 2 title caption"
  - image_path: ""
---

Recently I had a meeting to share ideas about how to help a team (engineering and product owners alike) not only aware
of the importance of their tech-debt but also how to take ownership of it. For some reasons, this team had heavy rotation
and the engineers did not find a way to remove their pain points during their sprints.

Working with some team members, we had already identified some points in various repositories and services, but we had 
not been able to onboard everyone in the importance of those items. For example, there were some _code smells_, some 
services had tons _legacy code_ (with few tests or no documentation) and other stuff that usually is considered
technical debt.

So we gathered together again, this time hands-on to try to find the best approach to the problems they were facing:

- How to identify if something was really tech-debt or just false positives
- How to measure the impact of each tech-debt item 
- How to reach consensus within the team (including product owner) that a given piece of software needed some love 
:heart_eyes: :hearts: <sup>:hearts: <sup>:hearts:</sup></sup>

# The first iteration

We tried to start small, with specific examples and use cases, in order to then iterate over them trying to find
generalizations.

So we started with a very basic question:

>What things do we have that we believe are tech-debt right now? (aka what are our current pain points?)

We identified some of them (and left some for the next iterations):

{% include figure 
    image_path="/assets/images/posts/simple-strategies-to-manage-techdebt/tech-debt-1.jpg"
    caption="This were the pain points detected with the team on the first iteration"
    alt="Image with boxes about identified tech debt items with the titles Monotliths, Obsolote Stuff, Not Scaling, Unstable, Monitoring, Not using platform tools, Testing, Documentation, and Code Smells"  
%}

Once we got some working examples, we could extract common information from them, this is trying to _classify_ them.
In order classify something, you need a criterion. Our criteria were not clear at that moment but became clearer when 
we saw the impacts, much later on. At this stage we saw some _**"architectural deficiencies"**_, some _**"things related
to production"**_ and finally other _stuff_ related to _**"how fast and happy the team was"**_
while working on certain code bases.

We used the initials `A`, `O` and `S` to tag our items:

{% include figure 
    image_path="/assets/images/posts/simple-strategies-to-manage-techdebt/tech-debt-2.jpg"
    caption="Grouping the different pain points into categories"
    alt="Previous image updated with categories (Architecture, Operations and Speed)"  
%}

We had reached a stage where we could simply add some tags to given tech-debt items that gave some inspiration to 
categorize them, but most importantly, we were able to extract the impact.
Effectively, the impact of a given item was directly involved on how we were categorizing it.

{% include figure 
    image_path="/assets/images/posts/simple-strategies-to-manage-techdebt/tech-debt-3.jpg"
    caption="Grouping the different pain points into categories"
    alt="Previous image deriving the impact from each category: Company Strategy, Bugs/Production problems and Time to Market"  
%}

# Retrospective

This very first iteration was so powerful. We were really happy, as this gave us great insights but also offered 
opportunities to establish some tech-debt goals within the Team. The team could focus on specific _themes_ according to 
the upcoming user stories and thus was a great way to align everyone, from product to engineering into dealing with 
tech-debt.

# Some examples

Lets say there are new features involving integrating with third parties that will consume our fancy new API that was 
just built in a hurry for a PoC in the next Quarter. We had identified some tech debt related to speed on that part of 
the codebase, like not enough tests, or some code that needs refactor because it was just a PoC. We know that this will 
impact the time to market, so we can anticipate and just focus as technical goal for the sprints to "improve the time to 
market for new API features" before we start working on the stories. Or maybe we are expecting a peak in our services 
because some Company OKRs (go sales, :moneybag: go!), and we need to focus on improving our `O`perations stuff, like 
monitoring, scaling or making the jobs resilient and parallelizable.

# Technical Debt

## What is Technical Debt

How do we know that something is techdebt? Because we are afraid to work on it (for several reasons) or because it
hinders product development not being able to achieve the speed we want (for several reasons... again). Or maybe because 
it breaks too much or because it is not aligned with the company strategies (yes, for several reasons).

Sounds familiar? Basically is what the second point above glimpses: Team Speed Stuff, Operations Stuff and Architecture 
Stuff. In other words:

- Techdebt doesn't allow product to deliver features at the speed they want: **It slows development teams**
- Techdebt are also pieces of software that we cannot mantain any longer (obsolete technology, tools or lack of
  experts): **it is not aligned with company strategies**
- Techdebt is also present when some products break _too often or even don't work as expected: **products already 
  running in the company that have a high operational cost**

**What is the formal definition?**

_From [Wikipedia](https://en.wikipedia.org/wiki/Technical_debt "Wikipedia article about Technical Debt"):_
> The formal  definition states that technical debt reflects the implied cost of additional rework caused by choosing an
> easy (limited) solution now instead of using a better approach that would take longer. Technical debt can be compared 
> to monetary debt. If technical debt is not repaid, it can accumulate 'interest', making it harder to implement changes 
> later on. Unaddressed technical debt increases software entropy. Technical debt is not necessarily a bad thing, and 
> sometimes (e.g., as a proof-of-concept) technical debt is required to move projects forward.

_From: [Martin Fowler](https://www.martinfowler.com/bliki/TechnicalDebt.html "Martin Fowler definition of technical debt"):_
> Software systems are prone to the build up of cruft - deficiencies in internal quality that make it harder than it 
> would ideally be to modify and extend the system further. Technical Debt is a metaphor, coined by Ward Cunningham, 
> that frames how to think about dealing with this cruft, thinking of it like a financial debt. The extra effort that 
> it takes to add new features is the interest paid on the debt.

At this point we could use one of the wide known definitions of tech debt, but we decided to go with our own.

**Why would then we change it?**

Simply, because software engineering as evolved **a lot** since the first of those definitions were introduced back 
in 1992 by [Ward Cunningham](https://github.com/WardCunningham/remodeling "Github repository from Ward Cunningham about remodeling").

Now we use infrastructure as a code, microservices architecture, CI/CD, agile philosophy and evolved technology stacks, 
some of which were born just a couple of years ago and give a competitive advantage over old ones.

We have seen stacks raise and die since then and using those dead stacks was not considered tech-debt at that time. 
We consider that anything in engineering that induces a cost for the company to grow, deliver or build new features is 
technical debt, be it new or established. From architecture to code to culture and training.

> We do not consider technical debt only stuff made consciously, but also stuff made some time ago which needs
> reconsideration based on current software engineering standards, tools and technology, but also on updated company 
> strategy and needs.

## How is technical debt born

Technical debt is not only born in the code. This is one of the biggest errors thar Startups make when thinking about 
it but also happens on established companies. According our definition above it can be born different ways. 

For example, a stakeholder meeting establishing a plan for the company to duplicate clients or traffic will spawn
a bunch of tech-debt items to optimize performance, allow scalability or other evolutions that are needed to achieve 
that goal.

Maybe our company is not yet ready to fully automated CI/CD pipelines, and we have some manual QA testing, and some teams
keep detecting in their retrospectives that there is a problem there, needing additional environments or just evolving 
the pipelines and training the team to help them automate those tests.

Or a new technology spawning in our market that gives and advantage to competitors and forces the company to switch to
it, evolving architectures, or just because there is a lack of engineers working in our previous technology stack. 

I stumbled recently upon this blog entry [Intentional Qualities](https://medium.com/@elizarov/intentional-qualities-7e6a57bb87fc) 
from [Roman Elizarov](https://www.linkedin.com/in/relizarov) and we would like to highlight a couple of paragraphs there:

>See, the fact is that you cannot accidentally write a software that has a specific quality. 
>You cannot accidentally write fast code. Your code cannot be secure by an accident.
>Accidentally easy to learn? Never heard of it.

[...]

>Qualities are often lost by an accident, but are never accidentally acquired. 
>It is similar to the second law of thermodynamics. In order to maintain quality you have to be very conscious, 
>intentional about it. You have to constantly fight against losing it. 

I love that statement! You can start writing code that follows a target (secure, fast, easy to learn or maintain) but 
several iterations later, it only needs one small commit not focused, and the code is not longer secure, fast or
maintainable.

TODO:
```
MONICA> Plz gather an example of non-code related techdebt like
```

### The second iteration

As a recap of our exercise above after the not-so-brief retrospective, we had already identified some tags (A, O, S) and
the impact of some technical debt items. We got a starting point and the feeling of being in the right path. 

We started to look for existing standards about the tags we were using on our tech-debt items but we were also aiming to
keep this simple enough to make it broadly used in the company.

Our Enterprise Architects are used to deal with the Software Architecture _-ilities_ (check some of the videos about 
them from [Neal Ford](http://nealford.com/) or [Mark Richards](http://www.wmrichards.com/)) so we started straight with 
their recommendations. Something was going to be tech-debt and not just false positives if it was lacking any of the
important _-illities_ for the company or the team.

There are some frameworks and acronyms that try to classify software according to their _-illities_, like ACID for 
transactions, RASUI for operations, FURPS for requirements... We were inspired by them and we decided to group the list
of _-illities_ that were important for the company (and our enterprise architects) into one or more of the categories we
already had identified.

```
TODO: Put the names and impacts of each category

TODO: Put the examples for each category

TODO: Talk about the knowledge matrix and how it can be automated from JIRA/techdeb backlog properties

TODO: Talk about how this will help to standarize metrics and communication (my architecture tech-debt is 5 being mostly
related to standards)

TODO: Rabani talks about techdebt beint a _slow poison_ (evolve around this idea)

### Conclusion
TODO: Lore ipsum...
```
