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
	var forceNilSecondView: Bool = false
	fileprivate var owningView: OwningViewType = .parentOwned
	
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
    
	func constraintDescription() -> ConstraintDescription {
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
		case let .custom(description):
			return description
		}
	}
}

public extension UIView {
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
		
		var constraints = [NSLayoutConstraint]()
		
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
			
			constraints.append(constraint)
		}
		
		return constraints
	}
	
	@discardableResult
	public func pushPin(_ pin: Pin, relativeTo otherView: UIView? = nil) -> NSLayoutConstraint? {
		return pushPins([pin], relativeTo: otherView).first
	}
}
