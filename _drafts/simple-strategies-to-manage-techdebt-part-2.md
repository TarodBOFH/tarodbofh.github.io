---
template: post
title: "Strategies to manage Technical Debt - Part 2"
excerpt: >- 
    Sometimes teams struggle to identify which technical debt items are worth investing into or how to align them to 
    company goals. In this 2nd part we will explore a techdebt matrix to help the teams align with company goals.
toc: false
toc_sticky: true
categories:
  - Software Engineering
tags: 
    - software architecture
    - enterprise architecture
    - technical debt
header:
    teaser: /assets/images/posts/simple-strategies-to-manage-techdebt/kat-yukawa-K0E6E0a0R3A-unsplash-hdpi.jpg
    overlay_image: /assets/images/posts/simple-strategies-to-manage-techdebt/kat-yukawa-K0E6E0a0R3A-unsplash-xxhdpi.jpg
    overlay_filter: 0.50
classes: wide
feature-row:
  - image_path: /assets/images/posts/simple-strategies-to-manage-techdebt/alice-pasqual-Olki5QpHxts-unsplash-hdpi.jpg
    excerpt: >-
        Why teams struggle with technical debt. Technical debt definition adapted to modern
        times. Introduction to a simple framework to classify and see technical debt impact in a team.
    url: "/software engineering/simple-strategies-to-manage-techdebt-part-1/"
    btn_label: "Part 1"
    btn_class: "btn--primary"
  - image_path: "/assets/images/posts/simple-strategies-to-manage-techdebt/kat-yukawa-K0E6E0a0R3A-unsplash-hdpi.jpg"
    excerpt: >-
        Evolve the simple framework by using industry standard definitions, like the sofware architecture _illities_.
        Explain by example and group them on predefined categories.
    url: "/software engineering/simple-strategies-to-manage-techdebt-part-2/#recap"
    btn_label: "Keep Reading!"
    btn_class: "btn--primary"
  - image_path: "/assets/images/posts/simple-strategies-to-manage-techdebt/sydney-rae-geM5lzDj4Iw-unsplash-hdpi.jpg"
    excerpt: >-
        Standardize metrics, language and communication to allow company wide alignment and high level planning.
        Examples of how this framework can be used across different teams.
    url: "/software engineering/simple-strategies-to-manage-techdebt-part-3/"
    btn_label: "Part 3"
    btn_class: "btn--primary"
gallery1:
  - url: /assets/images/posts/simple-strategies-to-manage-techdebt/tech-debt-1.jpg
    image_path: /assets/images/posts/simple-strategies-to-manage-techdebt/tech-debt-1.jpg
    alt: >- 
        Image with boxes about identified tech debt items with the titles 
        Monoliths, Obsolete Stuff, Not Scaling, Unstable, Monitoring, 
        Not using platform tools, Testing, Documentation, and Code Smells
    title: "his were the pain points detected with the team on the first iteration"
  - url: "/assets/images/posts/simple-strategies-to-manage-techdebt/tech-debt-2.jpg"
    image_path: "/assets/images/posts/simple-strategies-to-manage-techdebt/tech-debt-2.jpg"
    title: "Grouping the different pain points into categories"
    alt: "Previous image updated with categories (Architecture, Operations and Speed)"
  - url: "/assets/images/posts/simple-strategies-to-manage-techdebt/tech-debt-3.jpg"
    image_path: "/assets/images/posts/simple-strategies-to-manage-techdebt/tech-debt-3.jpg"
    title: "We could see the impact from each category easily and this drove us towards the matrix in the next part of this series."
    alt: "Previous image deriving the impact from each category: Company Strategy, Bugs/Production problems and Time to Market"
---
> Three series article about how to manage technical debt in a simple and fun way. 

{% include feature_row id="feature-row" %}

# Recap

> On the previous entry of the series, [Strategies to manage Technical Debt - Part 1](/software engineering/simple-strategies-to-manage-techdebt-part-1/) 
> Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna 
> aliqua. 
> Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
> Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
> Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum

{% include gallery id="gallery1"
    caption="Recap of previous article in the series. (Click for a larger view)"
%}

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna 
aliqua. 
Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum

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

On the [last entry of this series](/software engineering/simple-strategies-to-manage-techdebt-part-3/), we will see how
using this framework we could standarize metrics, enabling the company to define new goals or helping it to better reach
them, improving reaction times to changes, and helping teams by reinforcing them with specialists on their struggling
technical debt items.
