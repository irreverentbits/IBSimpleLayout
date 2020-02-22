# IBSimpleLayout

IBSimpleLayout is an Auto Layout wrapper API that simplifies most boilerplate code for creating and updating constraints.

It was created partially as an exercise in designing an API using Swift features and partially out of a conviction that Auto Layout could be distilled into an even simpler API than those provided by most popular frameworks (in late 2016, early 2017), including Apple's.

## Requirements and Goals

In terms of the framework and API, the goals of IBSimpleLayout are to create a framework that:
- Leverages Swift

  As a result, it only supports Swift. Objective C compatibility is not a priority because *new* code rarely needs to be written in Objective C.
    
- Supports iOS, not OS X.
  
  This allows for simpler code and allows the API to use iOS constraint related types directly rather than introducing a middle layer of framework defined constants that stand in for iOS or OS X values depending on the build.
  
- Focuses on common auto layout code.
  
  If the framework allows 90% of Auto Layout code to be much simpler and the other 10% is not as simple as in other libraries, that would overall be a win for IBSimpleLayout.
  
## Simple assumptions
  
The key to simplifying most constraint creation is to assume default values for most of the parameters used to create those constraints.
IBSimpleLayout makes the assumptions listed below most of the time (deviations are called out in the code samples provided further down in this readme).
All of the assumptions can be overridden if necessary.
  
- The first view in a constraint is the UIView calling on the framework.
- The second view in a constraint is the first view's parent view.
- The constraint multiplier is 1.0.
- The constraint relation is "equal".
- The constraint priority is "required" (float value of 1.0).
- The attribute affected by the constraint for both the first and second view is the same.
  
The default values should apply to most constraints created in code. Just building these assumptions into a framework simplifies code greatly.

## Simple samples

IBSimpleLayout allows a constraint to be described using a `Pin` enum. A Pin can be "pushed" onto a UIView using either the `pushPin` or `pushPins` functions. When a `Pin` is pushed onto a UIView, it is converted to a constraint. Here is a simple example, with further explanation after the code block.

```swift
// Make a child view's edges match the edge's of its parent
view.pushPins([.leading(0.0), .trailing(0.0), .top(0.0), .bottom(0.0)])
```

The code above assumes that all constraints are between `view` and its parent view. It also assumes that each attribute is matched to the same attribute on the parent (e.g. the `view` `leading` is matched to the parent's `leading` edge).

**Note, pins must always include the constant they should use, even if it is zero.**

Here is another simple example:

```swift
// view should be centered in its parent, be 16.0 pts smaller in width than its parent, 
// and should have a constant height of 50.0
view.pushPins([.centerX(0.0), .centerY(0.0), .width(-16.0), .heightConstant(50.0)])
```

## Deviating from the defaults

Any deviations from the default values the framework assumes can be made by calling a function on the `Pin` enum. It is much like having a parameter name and value in a function, but with the syntax of calling a different function for each parameter.

**Note, when functions are applied to a Pin, the `Pin` type identifier must be called out explicitly.** In order for the compiler to understand the function call, it must know the type the function is being called on. But once the function call is added, it cannot infer that the type calling the function is the same as the type expected by the pushPin function.

🐔 🥚

Here is a contrived example of applying functions to a Pin and showing the explicit callout to the Pin enum:

```swift
// The order of the function calls doesn't matter
// Add a constraint that makes view's width greater than or equal to 20.0 pts wider than 
// 1.2 times its parent's height with a priority of 0.5.
view.pushPin(Pin.width(20.0).relation(.greatherThanOrEqual).multiplier(1.2).toAttribute(.height).priority(0.5))
```

Changing the view the constraints should be relative to (instead of the parent) can be done by adding a `relativeTo` parameter on the main `pushPin*` functions.

```swift
// Position view relative to otherView instead of relative to its parent view
view.pushPins([.leading(0.0), .width(0.0), .height(0.0)], relativeTo: otherView)
view.pushPin(Pin.top(16.0).toAttribute(.bottom), relativeTo: otherView)
```

## Custom constraint types

IBSimpleLayout defines four custom `Pin` types: `above`, `below`, `leftOf`, and `rightOf`.

The `above` and `below` pin types can be used to place views above or below one another. These pins are really just short cuts for specifying pins that specify a `bottom` attribute matched to a `top` attribute. For example, the last code example above could have been written this way:

```swift
view.pushPins([.leading(0.0), .width(0.0), .height(0.0), .below(16.0)], relativeTo: otherView)
```

The `leftOf` and `rightOf` pin types can be used to place a view to the left of or to the right of another view. These pins are short cuts for specifying that one view's trailing attribute is matched to a second view's leading attribute (leftOf) or vice versa (rightOf).

The margin constraint types have slightly different behavior from most other pins. Their default values are based on what I have found to be typical usage. So, instead of associating a view's attribute with the same exact attribute on the parent view (by default), a view's *non margin* edge is associated with another view's *margin* edge. So the margin `Pin` enums all associate a non margin edge of the first view with a margin edge of the second view. For example:

```swift
// Set the view's leading and trailing edges equal to the parent view's leading and trailing margins.
// Set the view's top edge to 12.0 points below the the parent's top margin.
// Set the view's bottom edge to 12 points above the parent's bottom margin.
view.pushPins([.leadingMargin(0.0), .trailingMargin(0.0), .topMargin(12.0), .bottomMargin(-12.0)])
```

## Updating constraints

Apple's constraint system limits updates to constraints such that once created, only a constraint's constant can be updated. IBSimpleLayout can update the constants on existing constraints via the `updatePins` function. For example, the constraints created by the last code example above could be updated to increase the leading and trailing margins of `view` within its parent view.

```swift
view.updatePins([.leadingMargin(16.0), .trailingMargin(-16.0)])
```

As long as the same view is specified for the constraints (either the default parent or another view using the `relativeTo` parameter), the constraints will be found and their constants updated.

**Note, `updatePins` will not create a constraint if no matching constraint is found.**

If an update needs to be made to a pin that deviates from the default values (i.e. that was modified with additional function calls on the Pin), some of the same function calls must be made again for the correct constraint to be found. Specifically, constraint equality is tested based on these properties:

- first view
- first attribute
- second view
- second attribute
- relation

Here is an example of creating a non-default constraint and then updating it:

```swift
// Set the width to 20.0 greater than or equal to the height of the otherView
view.pushPin(Pin.width(20.0).relation(.greatherThanOrEqual).toAttribute(.height), relativeTo: otherView)

// Change the width to greater than or equal to the height of the otherView
view.updatePins([Pin.width(0.0).relation(.greaterThanOrEqual).toAttribute(.height)], relativeTo: otherView)
```

In this case, it's probably better to just declare a constraint property, store the constraint (more info in the next section) created when the pin is pushed, and update it the old fashioned way:

```swift
// Declare the property...
var constraint: NSLayoutConstraint

// Assign to the property during some setup phase...
constraint = view.pushPin(Pin.width(20.0).relation(.greaterThanOrEqual).toAttribute(.height), relativeTo: otherView)

// Sometime later, update the constraint...
constraint.constant = 0.0
```

## Referencing constraints

Given the `updatePins` function, it becomes less necessary to create properties to constraints since a constraint can be found and its constant updated without a property. But if a reference is still necessary, both `pushPins` and `pushPin` return the constraints they create.

```swift
// The array of push pins result in an array of constraints that are in 
// the same order as the pins used to create them.
let sizeConstraints: [NSLayoutConstraint] = view.pushPins([.width(0.0), .height(10.0)])

// A single constraint is returned for the constraint of the top of view to the top of its parent view.
let topConstraint: NSLayoutConstraint = view.pushPin(.top(16.0))
```

## Predefining constraint sets

Since constraints are described via the `Pin` enum and aren't applied until they are passed into a `pushPin*` or `updatePins` function on UIView, a set of pins can be created once and applied to many different views. For example, it's common to constrain all edges of a view to the edges of its parent. A set of edge Pins can be defined and reused repeatedly as shown below.

```swift
let zeroMarginPins = [.leading(0.0), .trailing(0.0), .top(0.0), .bottom(0.0)]
let standardMarginPins = [.leading(16.0), .trailing(-16.0), .top(16.0), .bottom(-16.0)]

// Initially, we can setup views to fill their parent views
view1.pushPins(zeroMarginPins)
view2.pushPins(zeroMarginPins)

// Later, perhaps after a user action, we can change the views to have margins within their parent view
view1.updatePins(standardMarginPins)
view2.updatePins(standardMarginPins)
```
