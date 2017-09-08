//
//  UIView+Pins.swift
//  IBSimpleLayout
//
//  Created by Lee Calloway on 9/7/17.
//  Copyright © 2017 Irreverent Bits. All rights reserved.
//

import Foundation

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
