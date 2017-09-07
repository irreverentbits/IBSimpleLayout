// Copyright © 2017 Irreverent Bits. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.


import Foundation

/**
The type of the view that a constraint should be owned by.
*/
fileprivate enum OwningViewType {
	/// The associated constraint should be owned by a parent of the view that the constraint affects.
	case parentOwned
	/// The associated constraint should be owned directly by the view that the constraint affects (e.g. a width constraint)
	case selfOwned
}

/**
An intermediate description of an autolayout constraint that can be fully edited before it is used to construct an `NSLayoutConstraint`.
*/
public struct ConstraintDescription {
	var firstView: UIView? = nil
	var firstAttribute: NSLayoutAttribute = .notAnAttribute
	var relation: NSLayoutRelation = .equal
	var secondView: UIView? = nil
	var secondAttribute: NSLayoutAttribute = .notAnAttribute
	var multiplier: CGFloat = 1.0
	var constant: CGFloat = 0.0
	var priority: UILayoutPriority = UILayoutPriorityRequired
	var identifier: String?
	fileprivate var owningView: OwningViewType = .parentOwned
	
	/** 
	Some constraints are never in relation to a second view (e.g. a width constant).
	When true, `forceNilSecondView` allows a second view specified for a set of constraints to be ignored for a specific constraint.
	*/
	var forceNilSecondView: Bool = false
	
	init() {}
	
	init(firstAttribute: NSLayoutAttribute, secondAttribute: NSLayoutAttribute, constant: CGFloat) {
		self.firstAttribute = firstAttribute
		self.secondAttribute = secondAttribute
		self.constant = constant
	}
	
	fileprivate init(firstAttribute: NSLayoutAttribute, secondAttribute: NSLayoutAttribute, constant: CGFloat, forceNilSecondView: Bool, owningView: OwningViewType) {
		self.init(firstAttribute: firstAttribute, secondAttribute: secondAttribute, constant: constant)
		self.forceNilSecondView = forceNilSecondView
		self.owningView = owningView
	}
	
	static func == (constraint: NSLayoutConstraint, description: ConstraintDescription) -> Bool {
		return constraint.firstItem === description.firstView &&
			constraint.secondItem === description.secondView &&
			constraint.firstAttribute == description.firstAttribute &&
			constraint.secondAttribute == description.secondAttribute &&
			constraint.relation == description.relation &&
			constraint.multiplier == description.multiplier
	}
	
	static func == (description: ConstraintDescription, constraint: NSLayoutConstraint) -> Bool {
		return constraint == description
	}
}

/**
A representation of an Auto Layout constraint.

A pin can be applied as needed to a view using extension functions on `UIView`.
*/
public enum Pin {
	case leading(CGFloat)
	case trailing(CGFloat)
	case top(CGFloat)
	case bottom(CGFloat)
	case height(CGFloat)
	case heightConstant(CGFloat)
	case width(CGFloat)
	case widthConstant(CGFloat)
	case centerX(CGFloat)
	case centerY(CGFloat)
	case below(CGFloat)
	case above(CGFloat)
	case lastBaseline(CGFloat)
	case firstBaseline(CGFloat)
	case leftMargin(CGFloat)
	case rightMargin(CGFloat)
	case topMargin(CGFloat)
	case bottomMargin(CGFloat)
	// leadingMargin
	// trailingMargin
	case centerXWithinMargins(CGFloat)
	case centerYWithinMargins(CGFloat)
	// left
	// right
	case custom(ConstraintDescription)
	
	public func priority(_ value: Float) -> Pin {
		var description = constraintDescription()
		description.priority = value
		
		return .custom(description)
	}
	
	public func multiplier(_ value: CGFloat) -> Pin {
		var description = constraintDescription()
		description.multiplier = value
		
		return .custom(description)
	}
	
	public func constant(_ value: CGFloat) -> Pin {
		var description = constraintDescription()
		description.constant = value
		
		return .custom(description)
	}
	
	public func toAttribute(_ value: NSLayoutAttribute) -> Pin {
		var description = constraintDescription()
		description.secondAttribute = value
		
		return .custom(description)
	}
	
	public func relation(_ value: NSLayoutRelation) -> Pin {
		var description = constraintDescription()
		description.relation = value
		
		return .custom(description)
	}
	
    public func identifier(_ value: String) -> Pin {
        var description = constraintDescription()
        description.identifier = value
        
        return .custom(description)
    }
	
	/**
	Returns a `ConstraintDescription` corresponding to the current enum value and its associated value.
	*/
	internal func constraintDescription() -> ConstraintDescription {
		switch self {
		case let .leading(constant):
			return ConstraintDescription(firstAttribute: .leading, secondAttribute: .leading, constant: constant)
			
		case let .trailing(constant):
			return ConstraintDescription(firstAttribute: .trailing, secondAttribute: .trailing, constant: constant)
		
		case let .top(constant):
			return ConstraintDescription(firstAttribute: .top, secondAttribute: .top, constant: constant)
		
		case let .bottom(constant):
			return ConstraintDescription(firstAttribute: .bottom, secondAttribute: .bottom, constant: constant)
		
		case let .height(constant):
			return ConstraintDescription(firstAttribute: .height, secondAttribute: .height, constant: constant)
		
		case let .heightConstant(constant):
			if constant < 0.0 {
				debugPrint("WARNING: Attempt to apply a negative height constant as a constraint. The value will be set to zero.")
			}
			
			return ConstraintDescription(firstAttribute: .height, secondAttribute: .notAnAttribute, constant: max(0.0, constant), forceNilSecondView: true, owningView: .selfOwned)
		
		case let .width(constant):
			return ConstraintDescription(firstAttribute: .width, secondAttribute: .width, constant: constant)
		
		case let .widthConstant(constant):
			if constant < 0.0 {
				debugPrint("WARNING: Attempt to apply a negative width constant as a constraint. The value will be set to zero.")
			}
			
			return ConstraintDescription(firstAttribute: .width, secondAttribute: .notAnAttribute, constant: max(0.0, constant), forceNilSecondView: true, owningView: .selfOwned)
		
		case let .centerX(constant):
			return ConstraintDescription(firstAttribute: .centerX, secondAttribute: .centerX, constant: constant)
		
		case let .centerY(constant):
			return ConstraintDescription(firstAttribute: .centerY, secondAttribute: .centerY, constant: constant)
		
		case let .below(constant):
			return ConstraintDescription(firstAttribute: .top, secondAttribute: .bottom, constant: constant)
		
		case let .above(constant):
			return ConstraintDescription(firstAttribute: .bottom, secondAttribute: .top, constant: -constant)
		
		case let .firstBaseline(constant):
			return ConstraintDescription(firstAttribute: .firstBaseline, secondAttribute: .firstBaseline, constant: constant)
		
		case let .lastBaseline(constant):
			return ConstraintDescription(firstAttribute: .lastBaseline, secondAttribute: .lastBaseline, constant: constant)
		
		case let .leftMargin(constant):
			return ConstraintDescription(firstAttribute: .leading, secondAttribute: .leadingMargin, constant: constant)
			
		case let .rightMargin(constant):
			return ConstraintDescription(firstAttribute: .trailing, secondAttribute: .trailingMargin, constant: constant)
			
		case let .topMargin(constant):
			return ConstraintDescription(firstAttribute: .top, secondAttribute: .topMargin, constant: constant)
			
		case let .bottomMargin(constant):
			return ConstraintDescription(firstAttribute: .bottom, secondAttribute: .bottomMargin, constant: constant)
			
		case let .centerXWithinMargins(constant):
			return ConstraintDescription(firstAttribute: .centerX, secondAttribute: .centerXWithinMargins, constant: constant)
			
		case let .centerYWithinMargins(constant):
			return ConstraintDescription(firstAttribute: .centerY, secondAttribute: .centerYWithinMargins, constant: constant)
			
		case let .custom(description):
			return description
		}
	}
}

public extension UIView {
	/**
	Updates existing constraints that correspond to the pins provided to the function.
	If a matching pin doesn't exist, there is no change or addition to existing pins.
	- parameter pins: The array of pins that should be updated.
	- parameter otherView: The `UIView` that the constraints are relative to.
	*/
	public func updatePins(_ pins: [Pin], relativeTo otherView: UIView? = nil) {
		guard let secondView = otherView ?? superview else {
			debugPrint("FAILURE: `updatePins` was called on a UIView without a valid otherView to pin to or without yet having a superview to pin to")
			return
		}
		
		guard let parentView: UIView = self.inclusiveCommonAncestor(with: secondView) else {
			debugPrint("FAILURE: `updatePins` was called for two views that do not have a common ancestor")
			return
		}
		
		pins.forEach { (pin) in
			var description = pin.constraintDescription()
			description.firstView = self
			description.secondView = (description.forceNilSecondView ? nil : secondView)

			// Find the existing constraint and update its constant
			var foundConstraint: Bool = false
			let owningView: UIView = (description.owningView == .parentOwned ? parentView : self)
			
			owningView.constraints.forEach({ (constraint) in
				if constraint == description {
					constraint.constant = description.constant
					foundConstraint = true
				}
			})
			
			if !foundConstraint {
				debugPrint("WARNING: Matching pin could not be found to update in call to 'updatePins'.")
			}
		}
	}
	
	/**
	Adds constraints specified by the pins provided to the function.
	- parameter pins: The array of pins that should be added.
	- parameter otherView: The `UIView` that the pins should reference (for those pins that require a second view to be specified).
	*/
	@discardableResult
	public func pushPins(_ pins: [Pin], relativeTo otherView: UIView? = nil) -> [NSLayoutConstraint] {
		guard let secondView = otherView ?? superview else {
			debugPrint("FAILURE: `pushPins` was called on a UIView without a valid otherView to pin to or without yet having a superview to pin to")
			return []
		}
		
		guard let parentView: UIView = self.inclusiveCommonAncestor(with: secondView) else {
			debugPrint("FAILURE: `pushPins` was called for two views that do not have a common ancestor")
			return []
		}
		
		var pinConstraints = [NSLayoutConstraint]()
		
		translatesAutoresizingMaskIntoConstraints = false
		
		pins.forEach { (pin) in
			var description = pin.constraintDescription()
			
			description.firstView = self
			
			description.secondView = (description.forceNilSecondView ? nil : secondView)
			
			let constraint = NSLayoutConstraint(item: description.firstView as Any,
			                                    attribute: description.firstAttribute,
			                                    relatedBy: description.relation,
			                                    toItem: description.secondView,
			                                    attribute: description.secondAttribute,
			                                    multiplier: description.multiplier,
			                                    constant: description.constant)
			
			constraint.priority = description.priority
			
			constraint.identifier = description.identifier
			
			let owningView = (description.owningView == .parentOwned ? parentView : self)
			owningView.addConstraint(constraint)
			
			pinConstraints.append(constraint)
		}
		
		return pinConstraints
	}
	
	/**
	Adds a single constraint to a view and returns that constraint so that it can be referenced easily later.
	- parameter pin: The single pin that should be added.
	- parameter otherView: The `UIView` that the pin should reference (for those pins that require a second view to be specified).
	- returns: The created constraint or nil if the constraint could not be created.
	*/
	@discardableResult
	public func pushPin(_ pin: Pin, relativeTo otherView: UIView? = nil) -> NSLayoutConstraint? {
		return pushPins([pin], relativeTo: otherView).first
	}
}

public extension UIView {
	/**
	Find the common ancestor between this view and another view in a view hierarchy. A view can be considered its own ancestor,
	so `self` or `otherView` are valid returns if either is an ancestor of the other.
	- parameter otherView: The other view that may be hierarchically related to this view.
	- returns: The common ancestor of `self` and the `otherView` or nil if there is no common ancestor.
	*/
	func inclusiveCommonAncestor(with otherView: UIView) -> UIView? {
		var foundAncestor: UIView? = nil
		
		// Check if one of the provided views is itself the common ancestor before moving up the hierarchy looking for a different ancestor
		if self.isDescendant(of: otherView) {
			foundAncestor = otherView
		} else if otherView.isDescendant(of: self) {
			foundAncestor = self
		} else {
			foundAncestor = exclusiveCommonAncestor(with: otherView)
		}
		
		return foundAncestor
	}
	
	/**
	Find the common ancestor of the two views in a view hierarchy. A view is not considered to be its own ancestor.
	If `self` and `otherView` have a direct lineage, then the common ancestor is the ancestor that is one or more levels above both.
	For example, the common ancestor for a parent and child is the parent's parent (aka the child's grandparent).
	- parameter otherView: The other view that may be hierarchically related to this view.
	- returns: The common ancestor of both `self` and `otherView` or nil if there is no common ancestor.
	*/
	func exclusiveCommonAncestor(with otherView: UIView) -> UIView? {
		var foundAncestor: UIView? = nil
		var testAncestor: UIView? = self.superview
		
		while testAncestor != nil {
			// If otherView is ever the same as the testAncestor, that means it is a direct ancestor of self
			// so the common ancestor would be
			if otherView === testAncestor {
				return otherView.superview ?? nil
			}
			
			if otherView.isDescendant(of: testAncestor!) {
				foundAncestor = testAncestor
				break
			}
			
			testAncestor = testAncestor!.superview
		}
		
		return foundAncestor
	}
}
