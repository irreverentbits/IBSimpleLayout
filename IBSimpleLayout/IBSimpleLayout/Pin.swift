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
	/// By default, describes a constraint that makes a view's leading edge equal to its parent's leading edge plus the provided constant.
	case leading(CGFloat)
	/// By default, describes a constraint that makes a view's trailing edge equal to its parent's trailing edge plus the provided constant.
	case trailing(CGFloat)
	/// By default, describes a constraint that makes a view's top edge equal to its parent's top edge plus the provided constant.
	case top(CGFloat)
	/// By default, describes a constraint that makes a view's bottom edge equal to its parent's bottom edge plus the provided constant.
	case bottom(CGFloat)
	/// By default, describes a constraint that makes a view's height equal to its parent's height plus the provided constant.
	case height(CGFloat)
	/// By default, describes a constraint that makes a view's height equal to the provided constant.
	case heightConstant(CGFloat)
	/// By default, describes a constraint that makes a view's width equal to its parent's width plus the provided constant.
	case width(CGFloat)
	/// By default, describes a constraint that makes a view's width equal to the provided constant.
	case widthConstant(CGFloat)
	/// By default, describes a constraint that makes a view's center X equal to its parent's center X plus the provided constant.
	case centerX(CGFloat)
	/// By default, describes a constraint that makes a view's center Y equal to its parent's center Y plus the provided constant.
	case centerY(CGFloat)
	/// By default, describes a constraint that makes a view's last baseline equal to its parent's last baseline plus the provided constant.
	case lastBaseline(CGFloat)
	/// By default, describes a constraint that makes a view's first baseline equal to its parent's first baseline plus the provided constant.
	case firstBaseline(CGFloat)
	/// By default, describes a constraint that makes a view's left edge equal to its parent's left margin plus the provided constant.
	case leftMargin(CGFloat)
	/// By default, describes a constraint that makes a view's right edge equal to its parent's right margin plus the provided constant.
	case rightMargin(CGFloat)
	/// By default, describes a constraint that makes a view's top edge equal to its parent's top margin plus the provided constant.
	case topMargin(CGFloat)
	/// By default, describes a constraint that makes a view's bottom edge equal to its parent's bottom margin plus the provided constant.
	case bottomMargin(CGFloat)
	/// By default, describes a constraint that makes a view's leading edge equal to its parent's leading margin plus the provided constant.
	case leadingMargin(CGFloat)
	/// By default, describes a constraint that makes a view's trailing edge equal to its parent's trailing margin plus the provided constant.
	case trailingMargin(CGFloat)
	/// By default, describes a constraint that makes a view's center X equal to its parent's center X within the parent's margins plus the provided constant.
	case centerXWithinMargins(CGFloat)
	/// By default, describes a constraint that makes a view's center Y equal to its parent's center Y within the parent's margins plus the provided constant.
	case centerYWithinMargins(CGFloat)
	/// By default, describes a constraint that makes a view's left edge equal to its parent's left edge plus the provided constant.
	case left(CGFloat)
	/// By default, describes a constraint that makes a view's right edge equal to its parent's right edge plus the provided constant.
	case right(CGFloat)
	/// By default, describes a constraint that makes a view's top edge equal to its parent's bottom edge plus the provided constant.
	case below(CGFloat)
	/// By default, describes a constraint that makes a view's bottom edge equal to its parent's top edge plus the provided constant.
	case above(CGFloat)
	/// By default, describes a constraint that makes a view's trailing edge equal to its parent's leading edge plus the provided constant.
	case leftOf(CGFloat)
	/// By default, describes a constraint that makes a view's leading edge equal to its parent's trailing edge plus the provided constant.
	case rightOf(CGFloat)
	/// A constraint description container that can be used when no other Pin type captures the constraint description with its default values.
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
	
	public func isActive(_ value: Bool) -> Pin {
		var description = constraintDescription()
		description.isActive = value
		
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
			
		case let .firstBaseline(constant):
			return ConstraintDescription(firstAttribute: .firstBaseline, secondAttribute: .firstBaseline, constant: constant)
		
		case let .lastBaseline(constant):
			return ConstraintDescription(firstAttribute: .lastBaseline, secondAttribute: .lastBaseline, constant: constant)
		
		case let .leftMargin(constant):
			return ConstraintDescription(firstAttribute: .left, secondAttribute: .leftMargin, constant: constant)
			
		case let .rightMargin(constant):
			return ConstraintDescription(firstAttribute: .right, secondAttribute: .rightMargin, constant: constant)
			
		case let .topMargin(constant):
			return ConstraintDescription(firstAttribute: .top, secondAttribute: .topMargin, constant: constant)
			
		case let .bottomMargin(constant):
			return ConstraintDescription(firstAttribute: .bottom, secondAttribute: .bottomMargin, constant: constant)
			
		case let .leadingMargin(constant):
			return ConstraintDescription(firstAttribute: .leading, secondAttribute: .leadingMargin, constant: constant)
			
		case let .trailingMargin(constant):
			return ConstraintDescription(firstAttribute: .trailing, secondAttribute: .trailingMargin, constant: constant)
			
		case let .centerXWithinMargins(constant):
			return ConstraintDescription(firstAttribute: .centerX, secondAttribute: .centerXWithinMargins, constant: constant)
			
		case let .centerYWithinMargins(constant):
			return ConstraintDescription(firstAttribute: .centerY, secondAttribute: .centerYWithinMargins, constant: constant)
			
		case let .left(constant):
			return ConstraintDescription(firstAttribute: .left, secondAttribute: .left, constant: constant)
			
		case let .right(constant):
			return ConstraintDescription(firstAttribute: .right, secondAttribute: .right, constant: constant)
		
		case let .below(constant):
			return ConstraintDescription(firstAttribute: .top, secondAttribute: .bottom, constant: constant)
			
		case let .above(constant):
			return ConstraintDescription(firstAttribute: .bottom, secondAttribute: .top, constant: -constant)

		case let .leftOf(constant):
			return ConstraintDescription(firstAttribute: .trailing, secondAttribute: .leading, constant: constant)
			
		case let .rightOf(constant):
			return ConstraintDescription(firstAttribute: .leading, secondAttribute: .trailing, constant: constant)
			
		case let .custom(description):
			return description
		}
	}
}
