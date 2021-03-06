---
template: post
title: Kotlin Elvis operator is not a ternary
date: 2018-11-11
tagline: What do you think this statement will out?
excerpt: >- 
    Last week, I was late at work and as soon as I entered the room, some coworkers shouted:
    “Hey, over here, we’ve found a bug in Kotlin!”
categories:
  - Software Engineering
tags:
  - kotlin
  - elvis operator
  - tips
  - java
  - ternary
header:
    teaser:        /assets/images/kotlin/matt-mckenna-LfjR6IOL7ts-unsplash-hdpi.jpg
    overlay_image: /assets/images/kotlin/louis-tsai-lqcvMiBABHw-unsplash-xxhdpi.jpg
    overlay_filter: 0.50
---
Last week, I was late at work because I had to take my motorbike to the garage.
As soon as I entered the room and even before I could change my shoes, some coworkers shouted:

> \- “Hey, over here, we’ve found a bug in Kotlin!”

Curious as I am always, I headed over their desk, and I was asked:

> \- “What do you think this statement will out?”

{% gist TarodBOFH/0b5f3920f4814666e9dc48881b0833f6%}
<figcaption>Is this a bug?</figcaption>

It’s a trap! I thought. I took a few moments and said something like "*at first sight, without any coffee yet... false, 
but I suspect that's wrong because “you found a bug in Kotlin”, so, what does this output?*".

That snippet, as you can see [here](https://play.kotlinlang.org/#eyJ2ZXJzaW9uIjoiMS4zLVJDIiwicGxhdGZvcm0iOiJqYXZhIiwiYXJncyI6IiIsIm5vbmVNYXJrZXJzIjp0cnVlLCJ0aGVtZSI6ImlkZWEiLCJmb2xkZWRCdXR0b24iOnRydWUsInJlYWRPbmx5IjpmYWxzZSwiY29kZSI6Ii8qKlxuICogWW91IGNhbiBlZGl0LCBydW4sIGFuZCBzaGFyZSB0aGlzIGNvZGUuIFxuICogcGxheS5rb3RsaW5sYW5nLm9yZyBcbiAqL1xuXG5mdW4gbWFpbigpIHtcbiAgICBwcmludGxuKG51bGwgIT0gbnVsbCA/OiBmYWxzZSlcbn0ifQ==), simply outputs `true`.

I looked again, and I got it. **The Elvis **`**?:**` **operator in Kotlin, is not a ternary!** That fooled me completely!

The Elvis operator just takes whatever is on his left and replaces with whatever lies on his right if the left side is 
null.
That means that our expression in the first example becomes simply `println(null != false)` which obviously, is `true`.

Why? Not because *“operand precedence”*; the *Elvis* operator refers to it's nearest variable.
It is not precedence! It is by design. 
Think it like `println(null != (null ?: false))` which translates exactly as the above result.
Heck, we could even be super-null-safe and write `println(null ?: false != null ?: false)` or any other variation.
It’s the design of the operator.

What’s the proper usage then, to avoid this weird confusion?
Simply, use Elvis either on simple return (either from functions or from blocks) and for variable assignation:

{% gist TarodBOFH/26339929378181883ffa7159e566d7c1 %}
<figcaption>This makes much more sense</figcaption>

One funny thing about the example above is that we cannot assign `null` to *notNullableGuy* because the compiler
complains:

```kotlin
// notNullableGuy = null // we can't do this because   
// Null can not be a value of a non-null type Boolean
```
This is a common mistake for java/javascript engineers who start to play with Kotlin. So follow these simple rules:

{% gist TarodBOFH/40dd67511140e249a60d6f40b9259d1a %}
<figcaption>You can play around with that example <a href="https://pl.kotl.in/HkmPmQUam" data-href="https://pl.kotl.in/HkmPmQUam" class="markup--anchor markup--figure-anchor" rel="noopener" target="_blank">here</a>.</figcaption>

These are some outputs from the snipped above:

```bash
assignment false  
fromBlock false  
computed null  
safe-output is false  
null  
null  
false  
true  
true  
false
```
* * *
```bash
assignment false  
fromBlock false  
computed null  
safe-output is false  
null  
false  
true  
true  
true  
false
```

To read more about the Elvis operator and Kotlin null-safety features, just deep read [Kotlin language reference about null-safety.](https://kotlinlang.org/docs/reference/null-safety.html)

_Originally published in_ [<i class="fab fa-fw fa-medium"></i>Medium](https://medium.com/@juan_ara/kotlin-elvis-operator-is-not-a-ternary-8f7af0eb15af)
