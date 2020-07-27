---
template: post
title: "Using Gradle Kotlin DSL with junit 5"
date: "2019-08-07"
categories:
    - Software Engineering
tags: 
    - tdd 
    - kotlin
    - gradle
    - gradle5
    - junit
    - junit5 
    - kts
    - lastminute.com
excerpt: >-    
  Gradle 5 has been out for a while now and with that we finally got the ability to write our Gradle scripts in Kotlin.
  How can I migrate my JUnit-enabled Gradle scripts to Kotlin Gradle DSL?
header:
    teaser: /assets/images/lastminute/LM_Full_Pink.jpg
    overlay_image: /assets/images/kotlin/matt-mckenna-LfjR6IOL7ts-unsplash-xxhdpi.jpg
    overlay_filter: rgba(236, 0, 140, 0.90)    
classes: wide
---

# JUnit 5 and Gradle

Gradle 5+ [has been out for a while now](https://gradle.org/releases/) and with that we finally got the ability to write 
our Gradle scripts in Kotlin.
Almost every example out there about JUnit and Gradle is still using the old 
dependencies or Groovy Gradle syntax, so let's try to migrate a Groovy build using JUnit Platform to Kotlin DSL, 
specifically, based on examples about how to extend Gradle's test output to add summaries at the end of the build.
{: .drop-letter}

## What we will achieve

We are starting from a plain Groovy Gradle script that configures a test task to log our JUnit test status (like 
examples [here](https://medium.com/@jonashavers/how-to-use-junit-5-with-gradle-fb7c5c3286cc) or
[here](https://stackoverflow.com/a/36130467) )

In addition, we will enable spotless and checkstyle in our Kotlin project as well as configuring IntelliJ IDEA Gradle
plugin to download javadoc and sources of our dependencies.

## Starting point

So let's see how an old Groovy `build.gradle` is like when we want to use JUnit 5:

```groovy
test {
    testLogging {
        exceptionFormat = 'full'
        events 'FAILED', 'SKIPPED', 'PASSED'
        showStandardStreams = true
        afterSuite { desc, result ->
            if (!desc.parent) {
                println "\nTest result: ${result.resultType}"
                println "Test summary: ${result.testCount} tests, " +
                        "${result.successfulTestCount} succeeded, " +
                        "${result.failedTestCount} failed, " +
                        "${result.skippedTestCount} skipped"
            }
        }        
    }

    useJUnitPlatform {}
}

cleanTest {}

configure(cleanTest) { group = 'verification' }
```

This is the very basic example we are going to find in stackoverflow or other forums.

We have a closure to display some test statistics, like the number of passed, failed and skipped tests.
We also instruct Gradle to use Junit Platform (Junit5) with the `useJUnitPlatform {}` instruction and we also  add the 
`cleanTest` task to the verification group (any `clean<Task>` in Gradle will delete the results by `<Task>`).

This last bit adds the task to our IDE Gradle tasklist in the desired group.

## Migrating to Gradle Kotlin DSL

As with every software engineering project, our task to migrate can be broken in smaller chunks and we are going to
start with the MVP, which is being able to build and test our project. Since we are testing, we will add also our test
framework dependencies: `mockk` and `assertj`:

```kotlin
repositories {
    mavenCentral()
}

plugins {
    kotlin("jvm") version "1.3.40"
}


dependencies {
    implementation(kotlin("stdlib-jdk8"))

    testImplementation("io.mockk:mockk:1.9.3")
    testImplementation("org.assertj:assertj-core:3.11.1")
    testImplementation("org.junit.jupiter:junit-jupiter-api:5.4.2")
    testImplementation("org.junit.jupiter:junit-jupiter-params:5.4.2")

    testRuntimeOnly("org.junit.jupiter:junit-jupiter-engine:5.4.2")
}

test {
    useJunitPlatform()
}
```

But when we reimport the project... k-boom! 

```
  Line 21: test {
  
^ Expression 'test' cannot be invoked as a function. The function 'invoke()' is not found
...
```

Why is this not working? Well, accessors for tasks are not published outside the `tasks` container (or accessor) on
Gradle's Kotlin DSL.

In order to solve this, we can use `tasks` and then filter by using one of the available methods:

### Selecting a hardcoded taskname inside tasks block

```kotlin
tasks {
    "test"(Test::class) {
        useJUnitPlatform()
    }
}
```

Notice how the class of the tasks is specified by `Test::class`, thus allowing us to invoke `useJUnitPlatform()` method 
of the Gradle Test class. However we do not like hardcoded strings... like `"test"`. Fortunately, we can simply modify 
the behavior of a list of tasks easily:

### Filtering through the existing tasks

```kotlin
tasks.withType<Test> {

    useJUnitPlatform()
}
```

Much more readable! It will also apply to any `Test` task defined on our build.

### By task accessor inside the task block (requires)
```kotlin
tasks {
    test {
        useJUnitPlatform()
    }
}
```

Even better! we do not need to know the type of the class since this is a type-safe accessor and comes with full IDE 
integration like code completion and inspections.

There are many other ways to access the builtin (or plugin added) tasks.
Just check [Gradle documentation](https://docs.gradle.org/current/userguide/kotlin_dsl.html#type-safe-accessors)

### Logging JUnit output

Since the accessors are now type-safe, and we are working with `Test` tasks, we believe can invoke some of our previous 
functionality almost by copying and pasting from our original implementation. 

Unfortunately, the following snippet breaks our build:

```kotlin
tasks {

    test {
        useJUnitPlatform()
    
        testLogging {
            exceptionFormat = 'full'
            events 'FAILED', 'SKIPPED', 'PASSED'
            showStandardStreams = true
            afterSuite { desc, result ->
                if (!desc.parent) {
                    println "\nTest result: ${result.resultType}"
                    println "Test summary: ${result.testCount} tests, " +
                    "${result.successfulTestCount} succeeded, " +
                            "${result.failedTestCount} failed, " +
                            "${result.skippedTestCount} skipped"
                }
            }
        }
    }
}
```

`Unexpected tokens (use ';' to separate expressions on the same line)`. This refers to the events list we are filtering.

Since we are not using Groovy anymore, we need to convert them from hardcoded strings to the proper objects, and also
use the right assignment with `=`

The same applies to the `exceptionFormat` so let's also fix that. Don't forget to import the new classes!

```kotlin
import org.gradle.api.tasks.testing.logging.TestExceptionFormat
import org.gradle.api.tasks.testing.logging.TestLogEvent

repositories {
    mavenCentral()
}

plugins {
    kotlin("jvm") version "1.3.40"
}

/*...*/

tasks {

    test {
    
        useJUnitPlatform()
    
        testLogging {
            exceptionFormat = TestExceptionFormat.FULL
            events = mutableSetOf(TestLogEvent.FAILED, TestLogEvent.PASSED, TestLogEvent.SKIPPED)
            showStandardStreams = true
            afterSuite { desc, result ->
                if (!desc.parent) {
                    println "\nTest result: ${result.resultType}"
                    println "Test summary: ${result.testCount} tests, " +
                    "${result.successfulTestCount} succeeded, " +
                            "${result.failedTestCount} failed, " +
                            "${result.skippedTestCount} skipped"
                }
            }
        }
    }
}
```

Ok, we fixed the imports but we are still facing the most difficult part so far.

Kotlin does not have `Closure` and our after suite block returns a pair of `Nothing`:
```
Type mismatch: inferred type is (Nothing, Nothing) -> TypeVariable(_L) but Closure<(raw) Any!>! was expected
```

At this point we might consider importing Groovy's `Closure` but our objective was using Kotlin DSL and removing the 
Groovy dependency so there must be an alternative. 

Digging on the internet [cough, cough, over here](https://github.com/gradle/kotlin-dsl/issues/836) we see that we can 
just add a `TestListener` and override the `afterSuite` method (which in fact is what the closure was doing):

```kotlin
/*...*/

tasks {

    test {
    
        useJUnitPlatform()
        
        addTestListener(object : TestListener {
            override fun beforeSuite(suite: TestDescriptor) {}
            override fun beforeTest(testDescriptor: TestDescriptor) {}
            override fun afterTest(testDescriptor: TestDescriptor, result: TestResult) {}
    
            override fun afterSuite(suite: TestDescriptor, result: TestResult) {
                if (suite.parent == null) { // root suite
                    logger.info("----")
                    logger.info("Test result: ${result.resultType}")
                    logger.info("Test summary: ${result.testCount} tests, " +
                        "${result.successfulTestCount} succeeded, " +
                        "${result.failedTestCount} failed, " +
                        "${result.skippedTestCount} skipped")
    
                }
            }
        })
    }
}
```

It is a pity that we don't have an adapter with default empty implementations and we need to implement empty methods but
this also opens the doors to some evolution in our build setup.

First we introduced the logger object, that the Kotlin DSL for Gradle exposes so we can log events.
We have `debug`, `info` and all the familiar `LOG_LEVELS` but there is also an interesting log level called `LIFECYCLE`.

Since we (arguably) think that test results do not belong to `info` level but `lifecycle` instead, we will redefine 
the level we are logging test events.

We need to remember to properly configure the new lifecycle level we are using:

```kotlin
/*...*/

tasks {

    test {
    
        useJUnitPlatform()
    
        testLogging {
            lifecycle {
                events = mutableSetOf(TestLogEvent.FAILED, TestLogEvent.PASSED, TestLogEvent.SKIPPED)
                exceptionFormat = TestExceptionFormat.FULL
                showExceptions = true
                showCauses = true
                showStackTraces = true
                showStandardStreams = true
            }
            info.events = lifecycle.events
            info.exceptionFormat = lifecycle.exceptionFormat
        }
    
        // See https://github.com/gradle/kotlin-dsl/issues/836
        addTestListener(object : TestListener {
            override fun beforeSuite(suite: TestDescriptor) {}
            override fun beforeTest(testDescriptor: TestDescriptor) {}
            override fun afterTest(testDescriptor: TestDescriptor, result: TestResult) {}
    
            override fun afterSuite(suite: TestDescriptor, result: TestResult) {
                if (suite.parent == null) { // root suite
                    logger.lifecycle("----")
                    logger.lifecycle("Test result: ${result.resultType}")
                    logger.lifecycle("Test summary: ${result.testCount} tests, " +
                        "${result.successfulTestCount} succeeded, " +
                        "${result.failedTestCount} failed, " +
                        "${result.skippedTestCount} skipped")
                }
            }
        })
    }
}
```

Second, we can add some new logging details by overriding other functions. Let's do a more detailed summary of failed 
and skipped tests:

```kotlin
/*...*/

tasks {

    test {
        
        /*...*/
                
        val failedTests = mutableListOf<TestDescriptor>()
        val skippedTests = mutableListOf<TestDescriptor>()
    
        // See https://github.com/gradle/kotlin-dsl/issues/836
        addTestListener(object : TestListener {
            override fun beforeSuite(suite: TestDescriptor) {}
            override fun beforeTest(testDescriptor: TestDescriptor) {}
            override fun afterTest(testDescriptor: TestDescriptor, result: TestResult) {
                when(result.resultType) {
                    TestResult.ResultType.FAILURE -> failedTests.add(testDescriptor)
                    TestResult.ResultType.SKIPPED -> skippedTests.add(testDescriptor)
                }
            }
    
            override fun afterSuite(suite: TestDescriptor, result: TestResult) {
                if (suite.parent == null) { // root suite
                    logger.lifecycle("----")
                    logger.lifecycle("Test result: ${result.resultType}")
                    logger.lifecycle("Test summary: ${result.testCount} tests, " +
                        "${result.successfulTestCount} succeeded, " +
                        "${result.failedTestCount} failed, " +
                        "${result.skippedTestCount} skipped")
                    if (failedTests.isNotEmpty()) {
                        logger.lifecycle("\tFailed Tests:")
                        failedTests.forEach {
                            parent?.let { parent ->
                                logger.lifecycle("\t\t${parent.name} - ${it.name}")
                            } ?: logger.lifecycle("\t\t${it.name}")
                        }
                    }
    
                    if (skippedTests.isNotEmpty()) {
                        logger.lifecycle("\tSkipped Tests:")
                        skippedTests.forEach {
                            parent?.let { parent ->
                                logger.lifecycle("\t\t${parent.name} - ${it.name}")
                            } ?: logger.lifecycle("\t\t${it.name}")
                        }
                    }
                }
            }
        })
    }
}
```

First we declare to mutableLists, one for failed and the other one for skipped tests. Then we check what kind of 
`TestResult` we are getting and add the `TestDescriptor` to the right list. One good thing from Kotlin scripting is that
we can omit the `else ->` in the enum branching.

However, being able to use Kotlin, we can improve somehow the script with all the fancy Kotlin features.

For example, we can use extension functions to make the code more readable.

Also, since we are going to add some linter capabilities, we might want to adhere to best practices and use proper 
`when` branching and include the `ELSE` fallback.

How does our example `build.gradle.kts` look after all the optimizations?

1. We added some checkstyle, spotless and linter configurations as well as IntelliJ IDEA plugin.
1. We setup some configuration options for the plugins above.
1. We refactored how we log to use a functional approach and Kotlin features.
1. Since we love testing with `ParameterizedTests`, we added that bit for JUnit too.
1. Finally, we used the same approach than on the `Test` task customization to customize the Kotlin compile options.
1. As a bonus, we are passing spotless / checkstyle to all the `Gradle.kts` files in the `KotlinGradle` task in the 
spotless configuration.

The end result is:

```kotlin
import org.gradle.api.tasks.testing.logging.TestExceptionFormat
import org.gradle.api.tasks.testing.logging.TestLogEvent

repositories {
    mavenCentral()
}

plugins {
    kotlin("jvm") version "1.3.40"
    id("com.diffplug.gradle.spotless") version "3.23.1"
    id("org.jmailen.kotlinter") version "1.26.0"
    checkstyle
    idea
}

idea {
    module {
        isDownloadJavadoc = true
        isDownloadSources = true
    }
}

tasks.checkstyleMain { group = "verification" }
tasks.checkstyleTest { group = "verification" }

spotless {
    kotlin {
        ktlint()
    }
    kotlinGradle {
        target(fileTree(projectDir).apply {
            include("*.gradle.kts")
        } + fileTree("src").apply {
            include("**/*.gradle.kts")
        })
        ktlint()
    }
}

dependencies {
    implementation(kotlin("stdlib-jdk8"))

    testImplementation("io.mockk:mockk:1.9.3")
    testImplementation("org.assertj:assertj-core:3.11.1")
    testImplementation("org.junit.jupiter:junit-jupiter-api:5.4.2")
    testImplementation("org.junit.jupiter:junit-jupiter-params:5.4.2")

    testRuntimeOnly("org.junit.jupiter:junit-jupiter-engine:5.4.2")
}

tasks.compileKotlin {
    kotlinOptions {
        jvmTarget = "1.8"
        javaParameters = true
    }
}

tasks.test {
    useJUnitPlatform()

    testLogging {
        lifecycle {
            events = mutableSetOf(TestLogEvent.FAILED, TestLogEvent.PASSED, TestLogEvent.SKIPPED)
            exceptionFormat = TestExceptionFormat.FULL
            showExceptions = true
            showCauses = true
            showStackTraces = true
            showStandardStreams = true
        }
        info.events = lifecycle.events
        info.exceptionFormat = lifecycle.exceptionFormat
    }

    val failedTests = mutableListOf<TestDescriptor>()
    val skippedTests = mutableListOf<TestDescriptor>()

    // See https://github.com/gradle/kotlin-dsl/issues/836
    addTestListener(object : TestListener {
        override fun beforeSuite(suite: TestDescriptor) {}
        override fun beforeTest(testDescriptor: TestDescriptor) {}
        override fun afterTest(testDescriptor: TestDescriptor, result: TestResult) {
            when (result.resultType) {
                TestResult.ResultType.FAILURE -> failedTests.add(testDescriptor)
                TestResult.ResultType.SKIPPED -> skippedTests.add(testDescriptor)
                else -> Unit
            }
        }

        override fun afterSuite(suite: TestDescriptor, result: TestResult) {
            if (suite.parent == null) { // root suite
                logger.lifecycle("----")
                logger.lifecycle("Test result: ${result.resultType}")
                logger.lifecycle(
                        "Test summary: ${result.testCount} tests, " +
                        "${result.successfulTestCount} succeeded, " +
                        "${result.failedTestCount} failed, " +
                        "${result.skippedTestCount} skipped")
                failedTests.takeIf { it.isNotEmpty() }?.prefixedSummary("\tFailed Tests")
                skippedTests.takeIf { it.isNotEmpty() }?.prefixedSummary("\tSkipped Tests:")
            }
        }

        private infix fun List<TestDescriptor>.prefixedSummary(subject: String) {
                logger.lifecycle(subject)
                forEach { test -> logger.lifecycle("\t\t${test.displayName()}") }
        }

        private fun TestDescriptor.displayName() = parent?.let { "${it.name} - $name" } ?: "$name"
    })
}

// cleanTest task doesn't have an accessor on tasks (when this blog post was written)
tasks.named("cleanTest") { group = "verification" }
```

## Gradle `test` sample output
Running `./gradlew clean build` on a sample project, we can see that our Gradle project is working, hopefully we won't
get any checkstyle or spotless violations and all test will be green.

What is the output if some tests are disabled or failing?

See this little cropped example:

```
...

> Task :test

Error!
org.opentest4j.AssertionFailedError: Error!
	at org.junit.jupiter.api.AssertionUtils.fail(AssertionUtils.java:43)
	at org.junit.jupiter.api.Assertions.fail(Assertions.java:129)
	at org.junit.jupiter.api.AssertionsKt.fail(Assertions.kt:24)
	at org.junit.jupiter.api.AssertionsKt.fail$default(Assertions.kt:23)
	at org.lastminute.blog.examples.gradlekts.UnitTest.always failing test()(UnitTest.kt:24)
    ...
    

org.lastminute.blog.examples.gradlekts.UnitTest > always failing test() FAILED
    org.opentest4j.AssertionFailedError: Error!
        at org.junit.jupiter.api.AssertionUtils.fail(AssertionUtils.java:43)
        at org.junit.jupiter.api.Assertions.fail(Assertions.java:129)
        at org.junit.jupiter.api.AssertionsKt.fail(Assertions.kt:24)
        at org.junit.jupiter.api.AssertionsKt.fail$default(Assertions.kt:23)
        at org.lastminute.blog.examples.gradlekts.UnitTest.always failing test()(UnitTest.kt:24)
org.lastminute.blog.examples.gradlekts.UnitTest > disabled test() SKIPPED
org.lastminute.blog.examples.gradlekts.UnitTest > always passing test() PASSED
----
Test result: FAILURE
Test summary: 3 tests, 1 succeeded, 1 failed, 1 skipped
	Failed Tests
		org.lastminute.blog.examples.gradlekts.UnitTest - always failing test()
	Skipped Tests:
		org.lastminute.blog.examples.gradlekts.UnitTest - disabled test()
1 test completed, 1 failed, 1 skipped
> Task :test FAILED
FAILURE: Build failed with an exception.
* What went wrong:
Execution failed for task ':test'.
...
```

# Conclusion

Gradle's Kotlin DSL comes with a change of mindset when writing your build script.
Kotlin is a type safe language which means that we need to be more strict now on our scripts, specially when migrating
Groovy ones.

It is really great to be able to use Kotlin in our build scripts, since we can easily extend or implement new Tasks with
few lines of code.
Some engineers fear build scripts, specially if they are not comfortable with the language used, and
having the opportunity to use the very same language you use everyday on your build scripts lowers the entry barrier for
them.

Even JUnit 5 has a nice 
[console launcher](https://junit.org/junit5/docs/current/user-guide/#running-tests-console-launcher) for building 
reports (on CI or manually), we engineers like to see a summary of what went wrong and we were missing that option with
the new JUnit Engine on Gradle. Fortunately, with this entry we have improved our initial scripts and been able not only
to summarize how the Test task was but also display which tests failed (or were skipped)

_Originally published in [<img src="/assets/images/lastminute/LM_Full_Pink-small.jpg" alt="lastminute.com logo"/>Technology Blog](https://technology.lastminute.com/junit5-kotlin-and-gradle-dsl)_  
