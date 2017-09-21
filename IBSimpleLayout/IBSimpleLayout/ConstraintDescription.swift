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
	var isActive: Bool = true
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
			constraint.relation == description.relation
	}
	
	static func == (description: ConstraintDescription, constraint: NSLayoutConstraint) -> Bool {
		return constraint == description
	}
}

