---
template: post
title: JUnit 5 unit testing with Kotlin
date: 2018-09-28
excerpt: >-
  At Returnly, we are using, among others, JUnit Jupiter to test our back-end services. There is some lack of
  documentation and examples, so I will setup some parameterized test examples.
header:
    teaser: /assets/images/returnly/00f5e6da-a550-4406-a766-41eb05d725c3-1581012589090.png
    overlay_image: /assets/images/kotlin/matt-mckenna-LfjR6IOL7ts-unsplash-xxhdpi.jpg
    overlay_filter: 0.50
classes: wide
categories:
  - Software Engineering
tags:
  - kotlin
  - tips
  - java
  - junit jupiter
  - junit
  - tdd
  - testing
  
gallery1:
  - image_path: ""
  - image_path: /assets/images/posts/JUnit-5-unit-testing-with-Kotlin/1_p2nPxZvpyV8sI6Ynh6V6EA.png
    alt: "Image showing the result of running parameterized tests on junit jupiter inside IntelliJ"
    title: "JUnit 5 IntelliJ output"
  - image_path: ""  
toc: true
---

> Update 2019: Like this entry?
> Try [Using Gradle Kotlin DSL with junit 5]({% post_url 2019-08-07-using-gradle-kotlin-dsl-with-junit5 %})

# Introduction

At [Returnly](https://returnly.com/) we are using [JUnit Jupiter](https://junit.org/junit5/docs/current/user-guide/) to 
test our back-end services.
We also use [mockk](https://mockk.io/) and [assertj](http://joel-costigliola.github.io/assertj/) which are great
libraries that help **a lot** to build readable code.

This article will try to cover the basics of using parameterized tests, especially by trying to keep test data separated
from the test classes.

We have started to move into [parameterized tests](https://junit.org/junit5/docs/current/user-guide/#writing-tests-parameterized-tests)
by creating various set of data objects.
Sometimes just CSV sources are fine, and our product managers love them (since they can define datasets without knowing
how to code), but we, engineers, tend to prefer working with DSL or Domain Objects.

A `@ParameterizedTest` is a test which takes some kind of values as arguments and tests them.
We found them useful to test edge error cases and unhappy paths, for example:

{% gist c74cd71c782ac744e4e2730930121323 %}

# Gradle Setup

With the new gradle 4.6+ native JUnit Platform integration, it is straightforward to run the tests within gradle:

{% gist ca13ba9a84369af2aca41ea0ccf8a910 %}

I like to add the `cleanTest` task there, so I can run it within my IDE and force to re-run the tests.
This task just deletes test output.

Other people prefer to make the tests never `UP-TO-DATE` with `test.outputs.upToDateWhen {false}` or `gradle test --rerun-tasks`. 

I prefer the built in `cleantTest` task.

On a console or standard output, the now [deprecated plugin for JUnit](https://junit.org/junit5/docs/current/user-guide/#running-tests-build-gradle) 
displayed the test results in a tree, but with gradle’s native implementation we get only a `BUILD SUCCESSFUL in {$time}s`.

To see the summary we have added the `afterSuite` [TestListener](https://docs.gradle.org/current/javadoc/org/gradle/api/tasks/testing/TestListener.html) 
to the `test` closure as an example above.

The output has a nice summary:

```
Testing started at 16:56 ...  
16:56:17: Executing task 'test'...
> Task :compileKotlin NO-SOURCE  
> Task :compileJava NO-SOURCE  
> Task :processResources NO-SOURCE  
> Task :classes UP-TO-DATE  
> Task :compileTestKotlin UP-TO-DATE  
> Task :compileTestJava NO-SOURCE  
> Task :processTestResources NO-SOURCE  
> Task :testClasses UP-TO-DATE  
> Task :test  
org.tarodbofh.medium.junit5.parametrized.ValueSourceTest > amount must be positive(int)[1] PASSED  
org.tarodbofh.medium.junit5.parametrized.ValueSourceTest > amount must be positive(int)[2] PASSED  
Test result: SUCCESS  
Test summary: 2 tests, 2 succeeded, 0 failed, 0 skipped
```

Following this approach, one could build the same tree listener by having a look to JUnit’s implementation [here](https://github.com/junit-team/junit5/blob/master/junit-platform-console/src/main/java/org/junit/platform/console/tasks/TreePrintingListener.java).

The dependencies to add to test are (from [maven central](https://search.maven.org/)):

```groovy
dependencies {  
    testCompile "org.assertj:assertj-core:3.11.1"  
    testCompile "org.junit.jupiter:junit-jupiter-api:5.2.0"  
    testCompile "org.junit.jupiter:junit-jupiter-params:5.2.0"  
    testRuntime "org.junit.jupiter:junit-jupiter-engine:5.2.0"  
}
```

{% include gallery id="gallery1" caption="Parameterized tests display nice in IDEs" class="text-left" %}{: .text-left}

# Passing arguments to parameterized tests in kotlin

Following [these hints](https://blog.philipphauer.de/best-practices-unit-testing-kotlin/), We have been using a 
`@Nested` inner class to implement the error cases or unhappy paths.
Sometimes, `ValueSource` seems *ugly*, and it is not possible to add some *flavor* to it:

{% gist cff5af3b70767b2f0dd625e55f9c5252 %}

Values passed to an annotation need to be a constant value, which forbids us to use ranges or other constructs there, 
for example:

{% gist 5452336c6914e63c9af51351e2568aae %}

Throws a compile-time error like this:

```
Error:(16, 25) Kotlin: An annotation argument must be a compile-time constant
```

To solve that, we can use the `@MethodSource` annotation, but that forces us to:

-   Have a method without arguments
-   Use `@TestInstance(TestInstance.Lifecycle.PER_CLASS)` annotation **and** having the method part of the test class
or producing a static method ([source](https://junit.org/junit5/docs/current/api/org/junit/jupiter/params/provider/MethodSource.html))

This leads to some strange code or other weird constructs, specially because we want to avoid using static methods in
Kotlin with the JVMStatic annotation, like:
 
```kotlin 
fun get1To10() = (1..10).toList().toIntArray()
```

As we mentioned earlier, we are using some DSL or pre-configured domain objects with know values
(i.e. `val valid_amounts = (1..10)` ).
Some people would have thought to bypass the compile-time constant error above by having something like:

```kotlin
const val VALID_AMOUNTS = valid_amounts.toList().toIntArray() //compile error
``` 

Unfortunately, in Kotlin, only primitives and Strings can be constant values, so often this is not an option.

Even though we always try to keep our tests simple, if we add the domain objects to the test class it can make it
grow, and we don’t think that mixing test data with the test methods is a good idea.

We are using [Kotlin Extensions](https://kotlinlang.org/docs/reference/extensions.html) to define our test domain
objects and thus keeping our test data from our test implementation as clean as possible.

This means that we have a separate file with the test data (much like the old CSV files that product uses) but in 
an _engineerly_ way.

One thing we can do, though is to use the [ArgumentsSource](https://junit.org/junit5/docs/current/api/org/junit/jupiter/params/provider/ArgumentsSource.html)
annotation and have a *Factory* class which implements [ArgumentsProvider](https://junit.org/junit5/docs/current/api/org/junit/jupiter/params/provider/ArgumentsProvider.html)
and its *arguments* method.

Although it sounds overkill, it is easy to implement thanks to reified inline functions and delegation:

{% gist c3a9e825a3c18e5038051e251ba97a53 %}

Then, our test method becomes:

{% gist 4c69a8eeb89e9de13c67c7cd8ea9a5cc %}

The complete source now has two files, and it is easy to extend or maintain. 
We got a nice functionality to reuse our ArgumentsProvider if we move it to one of our standard libraries.

# TLDR>

This is how the code looks after all the changes:

{% gist 91799cdb5eff8abfeebb73f31b75eaa8 %}

This is easy to extend, and we can replace the ArgumentsSource with CSVSource files once the product team have 
completed their test data.

_Originally published in_ [<i class="fab fa-fw fa-medium"></i>Medium](https://medium.com/@juan_ara/unit-testing-kotlin-with-junit-5-21bdf0d1a7c2)
