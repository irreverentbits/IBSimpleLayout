# IBSimpleLayout

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

IBSimpleLayout is an Auto Layout wrapper API that simplifies most boilerplate code for creating and updating constraints.

It was created partially as an exercise in designing an API using Swift features, partially as an example of a command
driven API, and partially out of a conviction that
Auto Layout could be distilled into an even simpler API than those provided by most popular frameworks (in late 2016, early 2017),
including Apple's.

## Goals

In terms of the framework and API, the goals of IBSimpleLayout were to create a framework that:
- would be written in Swift
  
  It is the present and future of iOS.
- would only explicitly support use from Swift
  
  Again, Swift is where it's at. I don't write any *new* code in Objective C.
- would only offer support for iOS auto layout
  
  I have serious doubts that there are many projects that cross UI code between iOS and OS X. There is no reason to complicate a framework to support both simultaneously.
- should focus on common auto layout issues (it doesn't need to solve all problems for everyone)
  
  If the framework allows 80% of Auto Layout code to be much simpler, and the other 20% had to fall back to even Apple's original NSLayoutConstraint methods, I'd consider that a win.
  
## Simple assumptions
  
The key to simplifying most constraint creation is to assume default values for most of the parameters used to create those constraints.
IBSimpleLayout makes the assumptions listed below most of the time (deviations are called out in the code samples provided further down in this readme).
All of the assumptions can be overridden if necessary.
  
- The first view in a constraint is the UIView calling on the framework.
- The second view in a constraint is the first view's parent view.
- The constraint multiplier is 1.0.
- The constraint relation is "equal".
- The constraint priority is "requried".
- The attribute affected by the constraint for both the first and second view is the same.
  
In my experience, the default values cover 90+% of the constraints I create in code. Just building these assumptions into a framework
simplifies code greatly.

## Simple samples


