//
//  ConstraintDescription.swift
//  IBSimpleLayout
//
//  Created by Lee Calloway on 9/7/17.
//  Copyright © 2017 Irreverent Bits. All rights reserved.
//

import Foundation

/**
The type of the view that a constraint should be owned by.
*/
enum OwningViewType {
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
	private(set) var firstAttribute: NSLayoutAttribute = .notAnAttribute
	var relation: NSLayoutRelation = .equal
	var secondView: UIView? = nil
	var secondAttribute: NSLayoutAttribute = .notAnAttribute
	var multiplier: CGFloat = 1.0
	var constant: CGFloat = 0.0
	var priority: UILayoutPriority = UILayoutPriority.required
	var identifier: String?
	private(set) var owningView: OwningViewType = .parentOwned
	
	/**
	Some constraints are never in relation to a second view (e.g. a width constant).
	When true, `forceNilSecondView` allows a second view specified for a set of constraints to be ignored for a specific constraint.
	*/
	private(set) var forceNilSecondView: Bool = false
	
	init() {}
	
	init(firstAttribute: NSLayoutAttribute, secondAttribute: NSLayoutAttribute, constant: CGFloat) {
		self.firstAttribute = firstAttribute
		self.secondAttribute = secondAttribute
		self.constant = constant
	}
	
	init(firstAttribute: NSLayoutAttribute, secondAttribute: NSLayoutAttribute, constant: CGFloat, forceNilSecondView: Bool, owningView: OwningViewType) {
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
