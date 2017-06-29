//  Copyright © 2017 Irreverent Bits. All rights reserved.
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
A constraint is owned by either a parent of the view that the constraint affects,
or it is owned by the view itself (e.g. a width constant).
*/
fileprivate enum OwningViewType {
	case parentOwned
	case selfOwned
}

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
	// left
	// right
	// leftMargin
	// rigthMargin
	// topMargin
	// bottomMargin
	// leadingMargin
	// trailingMargin
	// centerXWithinMargins
	// centerYWithinMargins
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
			return ConstraintDescription(firstAttribute: .height, secondAttribute: .notAnAttribute, constant: constant, forceNilSecondView: true, owningView: .selfOwned)
		
		case let .width(constant):
			return ConstraintDescription(firstAttribute: .width, secondAttribute: .width, constant: constant)
		
		case let .widthConstant(constant):
			return ConstraintDescription(firstAttribute: .width, secondAttribute: .notAnAttribute, constant: constant, forceNilSecondView: true, owningView: .selfOwned)
		
		case let .centerX(constant):
			return ConstraintDescription(firstAttribute: .centerX, secondAttribute: .centerX, constant: constant)
		
		case let .centerY(constant):
			return ConstraintDescription(firstAttribute: .centerY, secondAttribute: .centerY, constant: constant)
		
		case let .below(constant):
			return ConstraintDescription(firstAttribute: .top, secondAttribute: .bottom, constant: constant)
		
		case let .above(constant):
			return ConstraintDescription(firstAttribute: .bottom, secondAttribute: .top, constant: constant)
		
		case let .firstBaseline(constant):
			return ConstraintDescription(firstAttribute: .firstBaseline, secondAttribute: .firstBaseline, constant: constant)
		
		case let .lastBaseline(constant):
			return ConstraintDescription(firstAttribute: .lastBaseline, secondAttribute: .lastBaseline, constant: constant)
		
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
		
		guard let parentView: UIView = inclusiveCommonAncestor(firstView: self, secondView: secondView) else {
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
		
		guard let parentView: UIView = inclusiveCommonAncestor(firstView: self, secondView: secondView) else {
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

private extension UIView {
	/**
	Find the common ancestor of two views in a view hierarchy. A view can be considered its own ancestor,
	so one of the provided views will be returned if it is an ancestor of the other view.
	- parameter firstView: The first of two possibly hierarchically related UIViews.
	- parameter secondView: The second of two possibly hierarchically related UIViews.
	- returns: The common ancestor of the `firstView` and the `secondView` or nil if there is no common ancestor.
	*/
	func inclusiveCommonAncestor(firstView: UIView, secondView: UIView) -> UIView? {
		var foundAncestor: UIView? = nil
		
		// Check if one of the provided views is itself the common ancestor before moving up the hierarchy looking for a different ancestor
		if firstView.isDescendant(of: secondView) {
			foundAncestor = secondView
		} else if secondView.isDescendant(of: firstView) {
			foundAncestor = firstView
		} else {
			foundAncestor = exclusiveCommonAncestor(firstView: firstView, secondView: secondView)
		}
		
		return foundAncestor
	}
	
	/**
	Find the common ancestor of the two views in a view hierarchy. A view cannot be considered its own ancestor.
	- parameter firstView: The first of two possibly hierarchically related UIViews.
	- parameter secondView: The second of two possibly hierarchically related UIViews.
	- returns: The common ancestor of both views or nil if there is no common ancestor.
	*/
	func exclusiveCommonAncestor(firstView: UIView, secondView: UIView) -> UIView? {
		var foundAncestor: UIView? = nil
		
		var testAncestor: UIView? = firstView.superview
		
		while testAncestor != nil {
			if secondView.isDescendant(of: testAncestor!) {
				foundAncestor = testAncestor
				break
			}
			
			testAncestor = testAncestor!.superview
		}
		
		return foundAncestor
	}
}
