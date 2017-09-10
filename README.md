# IBSimpleLayout

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

IBSimpleLayout is an Auto Layout wrapper API that simplifies most boilerplate code for creating and updating constraints.

It was created partially as an exercise in designing an API using Swift features, partially as an example of a command
driven API, and partially out of a conviction that Auto Layout could be distilled into an even simpler API than those provided by most popular frameworks (in late 2016, early 2017), including Apple's.

## Requirements and Goals

In terms of the framework and API, the goals of IBSimpleLayout were to create a framework that:
- Leverages Swift

  As a result, it only supports Swift. Objective C compatibility was not a priority because I don't write any *new* code in Objective C.
    
- Supports iOS, not OS X.
  
  This allows for the simplest code and allows the API to use iOS constraint related types directly rather than introducing a middle layer of framework defined constants that stand in for iOS or OS X values depending on the build.
  
- Focuses on common auto layout code.
  
  If the framework allows 90% of Auto Layout code to be much simpler and the other 10% is not as simple as in other libraries, I'd consider that a win.
  
- Constraint creation should be declarative. 

  The framework will figure out which view to assign a constraint to, so no more calls to addConstraints.
  
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

IBSimpleLayout allows a constraint to be described using a `Pin` enum. A Pin can be "pushed" onto a UIView using either the `pushPin` or `pushPins` functions. When a `Pin` is pushed onto a UIView, it is converted to a constraint. Here is a simple example, with further explanation after the code block.

```
// Make a child view match the size and placement of its parent
view.pushPins([.leading(0.0), .trailing(0.0), .top(0.0), .bottom(0.0)])
```

The code above assumes that all constraints are between `view` and its parent. It also assumes that each attribute is matched to the same attribute on the parent (e.g. the `view` leading is matched to the parent's `leading` edge).

All pins must include the constant they should use.

Here is another simple example:

```
// view should be centered in its parent, be 16.0 pts smaller in width than its parent, 
// and should have a constant height of 50.0
view.pushPins([.centerX(0.0), .centerY(0.0), .width(-16.0), .heightConstant(50.0)])
```

## Deviating from the defaults

Any deviations from the default values the framework assumes can be made by calling a function on the `Pin` enum. It is much like having a parameter name and value in a function, but with the syntax of calling a different function for each parameter. Here is a contrived example:

``` 
// The order of the function calls doesn't matter
// Add a constraint that makes view's width greater than or equal to 20.0 pts wider than 
// 1.2 times its parent's height with a priority of 0.5.
view.pushPin(.width(20.0).multiplier(1.2).relation(.greatherThanOrEqual).toAttribute(.height).priority(0.5))
```

Changing the view the constraints should be relative to (instead of the parent) can be done by adding a `relativeTo` parameter on the main `pushPin*` functions.

```
// Position view relative to otherView instead of relative to its parent view
view.pushPins([.leading(0.0), .width(0.0), .height(0.0), Pin.top(16.0).toAttribute(.bottom)], relativeTo: otherView)
```

## Custom constraint types

As shown in the last example above, IBSimpleLayout defines two custom `Pin` types. The `above` and `below` `Pin` types can be used to place views above or below one another. These pins are really just short cuts for specifying pins that specify a `bottom` attribute matched to a `top` attribute. For example, the last code example above could have been written this way:

```
view.pushPins([.leading(0.0), .width(0.0), .height(0.0), .below(16.0)], relativeTo: otherView)
```

## Updating constraints

Apple's constraint system limits updates to constraints such that once created, only a constraint's constant can be updated. IBSimpleLayout can update the constants on existing constraints via the `updatePins` function. For example, the constraints created by the last code example above could be updated to indent view under otherView.

```
view.updatePins([.leading(16.0), .width(-16.0)], relativeTo: otherView)
```

As long as the same view is specified for the constraints (either the default parent or another view using the `relativeTo` parameter), the constraints will be found and their constants updated.

Note, `updatePins` will not create a constraint if no matching constraint is found.

## Referencing constraints

Given the `updatePins` function, it becomes less necessary to create properties to constraints since a constraint can be found and its constant updated without a property. But if a reference is still necessary, both `pushPins` and `pushPin` return the constraints they create. Naturally, if there are a lot of constraints being upated, it may be noticeably more performant to save them to properties. YMMV.

```
// The array of push pins result in an array of constraints that are in 
// the same order as the pins used to create them.
let sizeConstraints = view.pushPins([.width(0.0), .height(10.0)])

// A single constraint is returned for the constraint of the top of view to the top of its parent view.
let topConstraint = view.pushPin(.top(16.0))
```

## Predefining constraint sets

Since constraints are described via the `Pin` enum and aren't applied until they are passed into a `pushPin*` or `updatePins` function on UIView, a set of pins can be created once and applied to many different views. For example, it's common to constrain all edges of a view to the edges of its parent. A set of edge Pins could be defined and reused repeatedly as shown below.

```
let zeroMarginPins = [.leading(0.0), .trailing(0.0), .top(0.0), .bottom(0.0)]
let standardMarginPins = [.leading(16.0), .trailing(16.0), .top(16.0), .bottom(16.0)]

// Initially, we can setup views to fill their parent views
view1.pushPins(zeroMarginPins)
view2.pushPins(zeroMarginPins)

// Later, after a user action, we can change the views to have margins within their parent view
view1.updatePins(standardMarginPins)
view2.updatePins(standardMarginPins)
```


