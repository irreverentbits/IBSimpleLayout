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
import UIKit

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
	var relation: NSLayoutRelation
	var secondView: UIView?
	var secondAttribute: NSLayoutAttribute
	var multiplier: CGFloat
	var constant: CGFloat
	var priority: UILayoutPriority
	var identifier: String?
	var isActive: Bool
	private(set) var owningView: OwningViewType

	/**
	Some constraints are never in relation to a second view (e.g. a width constant).
	When true, `forceNilSecondView` allows a second view specified for a set of constraints to be ignored for a specific constraint.
	*/
	private(set) var forceNilSecondView: Bool = false
    
    /**
    All properties of a `ConstraintDescription` can be set via the initializer function except for the
    `firstView` and the `secondView`. These are determined at the time the constraint description is used
    to construct an `NSLayoutConstraint` via a `pushPin` or `updatePin` function call on a `UIView`.
     
    All of the properties that can be set in the initializer have default values except for the `firstAttribute`
    because there is no reasonable and valid default value for the `firstAttribute`.
    */
    init(firstAttribute: NSLayoutAttribute,
         relatedBy: NSLayoutRelation = .equal,
         secondAttribute: NSLayoutAttribute = .notAnAttribute,
         multiplier: CGFloat = 1.0,
         constant: CGFloat = 0.0,
         priority: UILayoutPriority = .required,
         identifier: String? = nil,
         isActive: Bool = true,
         forceNilSecondView: Bool = false,
         owningView: OwningViewType = .parentOwned) {
        
        self.firstAttribute = firstAttribute
        self.relation = relatedBy
        self.secondAttribute = secondAttribute
        self.multiplier = multiplier
        self.constant = constant
        self.priority = priority
        self.identifier = identifier
        self.isActive = isActive
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

