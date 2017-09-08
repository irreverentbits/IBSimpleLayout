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
		description.priority = UILayoutPriority(rawValue: value)
		
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
