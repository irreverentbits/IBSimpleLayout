//
//  ConstraintDescriptionTests.swift
//  IBSimpleLayoutTests
//
//  Created by Lee Calloway on 5/9/18.
//  Copyright © 2018 Irreverent Bits. All rights reserved.
//

import XCTest

class ConstraintDescriptionTests: IBSimpleLayoutTests {
    func testDefaultInitialization() {
        let constraintDescription = ConstraintDescription(firstAttribute: .leading)
        
        // Test that all properties have an initial value and it is the expected value
        XCTAssertEqual(constraintDescription.firstAttribute, .leading)
        XCTAssertEqual(constraintDescription.secondAttribute, .notAnAttribute)
        XCTAssertNil(constraintDescription.firstView)
        XCTAssertNil(constraintDescription.secondView)
        XCTAssertEqual(constraintDescription.constant, 0.0)
        XCTAssertEqual(constraintDescription.multiplier, 1.0)
        XCTAssertEqual(constraintDescription.isActive, true)
        XCTAssertNil(constraintDescription.identifier)
        XCTAssertEqual(constraintDescription.forceNilSecondView, false)
        XCTAssertEqual(constraintDescription.owningView, .parentOwned)
        XCTAssertEqual(constraintDescription.priority, .required)
        XCTAssertEqual(constraintDescription.relation, .equal)
    }
}
