//
//  PinConstraintCreationTests.swift
//  IBSimpleLayoutTests
//
//  Created by Lee Calloway on 5/9/18.
//  Copyright © 2018 Irreverent Bits. All rights reserved.
//

import XCTest

class PinConstraintCreationTests: XCTestCase {
    func testLeadingPinConstraint() {
        let constant: CGFloat = 10.0
        let constraint = Pin.leading(constant).constraintDescription()
        
        checkBasicSettings(for: constraint, firstAttribute: .leading, secondAttribute: .leading, constant: constant)
        XCTAssertFalse(constraint.forceNilSecondView)
    }
    
    func testTrailingPinConstraint() {
        let constant: CGFloat = 5.0
        let constraint = Pin.trailing(constant).constraintDescription()

        checkBasicSettings(for: constraint, firstAttribute: .trailing, secondAttribute: .trailing, constant: constant)
        XCTAssertFalse(constraint.forceNilSecondView)
    }
    
    func testTopPinConstraint() {
        let constant: CGFloat = 15.0
        let constraint = Pin.top(constant).constraintDescription()
        
        checkBasicSettings(for: constraint, firstAttribute: .top, secondAttribute: .top, constant: constant)
        XCTAssertFalse(constraint.forceNilSecondView)
    }
    
    func testBottomPinConstraint() {
        let constant: CGFloat = 20.0
        let constraint = Pin.bottom(constant).constraintDescription()
        
        checkBasicSettings(for: constraint, firstAttribute: .bottom, secondAttribute: .bottom, constant: constant)
        XCTAssertFalse(constraint.forceNilSecondView)
    }
    
    func testHeightPinConstraint() {
        let constant: CGFloat = 25.0
        let constraint = Pin.height(constant).constraintDescription()
        
        checkBasicSettings(for: constraint, firstAttribute: .height, secondAttribute: .height, constant: constant)
        XCTAssertFalse(constraint.forceNilSecondView)
    }
    
    func testHeightConstantPinConstraint() {
        let constant: CGFloat = 30.0
        let constraint = Pin.heightConstant(constant).constraintDescription()
        
        checkBasicSettings(for: constraint, firstAttribute: .height, secondAttribute: .notAnAttribute, constant: constant)
        XCTAssertTrue(constraint.forceNilSecondView)
    }
    
    func testNegativeHeightConstantPinConstraint() {
        let constraint = Pin.heightConstant(-5.0).constraintDescription()
        
        checkBasicSettings(for: constraint, firstAttribute: .height, secondAttribute: .notAnAttribute, constant: 0.0)
        XCTAssertTrue(constraint.forceNilSecondView)
    }
    
    func testWidthPinConstraint() {
        let constant: CGFloat = 35.0
        let constraint = Pin.width(constant).constraintDescription()
        
        checkBasicSettings(for: constraint, firstAttribute: .width, secondAttribute: .width, constant: constant)
        XCTAssertFalse(constraint.forceNilSecondView)
    }
    
    func testWidthConstantPinConstraint() {
        let constant: CGFloat = 30.0
        let constraint = Pin.widthConstant(constant).constraintDescription()
        
        checkBasicSettings(for: constraint, firstAttribute: .width, secondAttribute: .notAnAttribute, constant: constant)
        XCTAssertTrue(constraint.forceNilSecondView)
    }
    
    func testNegativeWidthConstantPinConstraint() {
        let constraint = Pin.widthConstant(-5.0).constraintDescription()
        
        checkBasicSettings(for: constraint, firstAttribute: .width, secondAttribute: .notAnAttribute, constant: 0.0)
        XCTAssertTrue(constraint.forceNilSecondView)
    }

    func testCenterXPinConstraint() {
        let constant: CGFloat = 35.0
        let constraint = Pin.centerX(constant).constraintDescription()
        
        checkBasicSettings(for: constraint, firstAttribute: .centerX, secondAttribute: .centerX, constant: constant)
        XCTAssertFalse(constraint.forceNilSecondView)
    }
    
    func testCenterYPinConstraint() {
        let constant: CGFloat = 35.0
        let constraint = Pin.centerY(constant).constraintDescription()
        
        checkBasicSettings(for: constraint, firstAttribute: .centerY, secondAttribute: .centerY, constant: constant)
        XCTAssertFalse(constraint.forceNilSecondView)
    }
    
    func testFirstBaselinePinConstraint() {
        let constant: CGFloat = 40.0
        let constraint = Pin.firstBaseline(constant).constraintDescription()
        
        checkBasicSettings(for: constraint, firstAttribute: .firstBaseline, secondAttribute: .firstBaseline, constant: constant)
        XCTAssertFalse(constraint.forceNilSecondView)
    }
    
    func testLastBaselinePinConstraint() {
        let constant: CGFloat = 45.0
        let constraint = Pin.lastBaseline(constant).constraintDescription()
        
        checkBasicSettings(for: constraint, firstAttribute: .lastBaseline, secondAttribute: .lastBaseline, constant: constant)
        XCTAssertFalse(constraint.forceNilSecondView)
    }
    
    func testLeftMarginPinConstraint() {
        let constant: CGFloat = 50.0
        let constraint = Pin.leftMargin(constant).constraintDescription()
        
        checkBasicSettings(for: constraint, firstAttribute: .left, secondAttribute: .leftMargin, constant: constant)
        XCTAssertFalse(constraint.forceNilSecondView)
    }
    
    func testRightMarginPinConstraint() {
        let constant: CGFloat = 55.0
        let constraint = Pin.rightMargin(constant).constraintDescription()
        
        checkBasicSettings(for: constraint, firstAttribute: .right, secondAttribute: .rightMargin, constant: constant)
        XCTAssertFalse(constraint.forceNilSecondView)
    }
    
    func testTopMarginPinConstraint() {
        let constant: CGFloat = 60.0
        let constraint = Pin.topMargin(constant).constraintDescription()
        
        checkBasicSettings(for: constraint, firstAttribute: .top, secondAttribute: .topMargin, constant: constant)
        XCTAssertFalse(constraint.forceNilSecondView)
    }
    
    func testBottomMarginPinConstraint() {
        let constant: CGFloat = 65.0
        let constraint = Pin.bottomMargin(constant).constraintDescription()
        
        checkBasicSettings(for: constraint, firstAttribute: .bottom, secondAttribute: .bottomMargin, constant: constant)
        XCTAssertFalse(constraint.forceNilSecondView)
    }
    
    func testLeadingMarginPinConstraint() {
        let constant: CGFloat = 70.0
        let constraint = Pin.leadingMargin(constant).constraintDescription()
        
        checkBasicSettings(for: constraint, firstAttribute: .leading, secondAttribute: .leadingMargin, constant: constant)
        XCTAssertFalse(constraint.forceNilSecondView)
    }
    
    func testTrailingMarginPinConstraint() {
        let constant: CGFloat = 75.0
        let constraint = Pin.trailingMargin(constant).constraintDescription()
        
        checkBasicSettings(for: constraint, firstAttribute: .trailing, secondAttribute: .trailingMargin, constant: constant)
        XCTAssertFalse(constraint.forceNilSecondView)
    }
    
    func testCenterXWithinMarginsPinConstraint() {
        let constant: CGFloat = 80.0
        let constraint = Pin.centerXWithinMargins(constant).constraintDescription()
        
        checkBasicSettings(for: constraint, firstAttribute: .centerX, secondAttribute: .centerXWithinMargins, constant: constant)
        XCTAssertFalse(constraint.forceNilSecondView)
    }
    
    func testCenterYWithinMarginsPinConstraint() {
        let constant: CGFloat = 85.0
        let constraint = Pin.centerYWithinMargins(constant).constraintDescription()
        
        checkBasicSettings(for: constraint, firstAttribute: .centerY, secondAttribute: .centerYWithinMargins, constant: constant)
        XCTAssertFalse(constraint.forceNilSecondView)
    }
    
    func testLeftPinConstraint() {
        let constant: CGFloat = 90.0
        let constraint = Pin.left(constant).constraintDescription()
        
        checkBasicSettings(for: constraint, firstAttribute: .left, secondAttribute: .left, constant: constant)
        XCTAssertFalse(constraint.forceNilSecondView)
    }
    
    func testRightPinConstraint() {
        let constant: CGFloat = 95.0
        let constraint = Pin.right(constant).constraintDescription()
        
        checkBasicSettings(for: constraint, firstAttribute: .right, secondAttribute: .right, constant: constant)
        XCTAssertFalse(constraint.forceNilSecondView)
    }
    
    func testBelowPinConstraint() {
        let constant: CGFloat = 100.0
        let constraint = Pin.below(constant).constraintDescription()
        
        checkBasicSettings(for: constraint, firstAttribute: .top, secondAttribute: .bottom, constant: constant)
        XCTAssertFalse(constraint.forceNilSecondView)
    }
    
    func testAbovePinConstraint() {
        let constant: CGFloat = 105.0
        let constraint = Pin.above(constant).constraintDescription()
        
        checkBasicSettings(for: constraint, firstAttribute: .bottom, secondAttribute: .top, constant: -constant)
        XCTAssertFalse(constraint.forceNilSecondView)
    }
    
    func testLeftOfPinConstraint() {
        let constant: CGFloat = 110.0
        let constraint = Pin.leftOf(constant).constraintDescription()
        
        checkBasicSettings(for: constraint, firstAttribute: .trailing, secondAttribute: .leading, constant: constant)
        XCTAssertFalse(constraint.forceNilSecondView)
    }
    
    func testRightOfPinConstraint() {
        let constant: CGFloat = 115.0
        let constraint = Pin.rightOf(constant).constraintDescription()
        
        checkBasicSettings(for: constraint, firstAttribute: .leading, secondAttribute: .trailing, constant: constant)
        XCTAssertFalse(constraint.forceNilSecondView)
    }
    
    // TODO: Test that calling a function on the pin for a property change causes creation of a custom pin with correct constraint description
    
    func checkBasicSettings(for constraint: ConstraintDescription, firstAttribute: NSLayoutAttribute, secondAttribute: NSLayoutAttribute, constant: CGFloat, isActive: Bool = true) {
        XCTAssertEqual(constraint.firstAttribute, firstAttribute)
        XCTAssertEqual(constraint.secondAttribute, secondAttribute)
        XCTAssertEqual(constraint.constant, constant)
        XCTAssertEqual(constraint.isActive, isActive)
    }
}
