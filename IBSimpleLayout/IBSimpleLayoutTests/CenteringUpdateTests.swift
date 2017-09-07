//
//  CenteringUpdateTests.swift
//  IBSimpleLayoutTests
//
//  Created by Lee Calloway on 8/23/17.
//  Copyright © 2017 Irreverent Bits. All rights reserved.
//

import XCTest

class CenteringUpdateTests: IBSimpleLayoutTests {
	func testPerfectToPositiveCenter() {
		// Code to test
		subView1.pushPins([.centerX(0.0), .centerY(0.0), .widthConstant(50.0), .heightConstant(50.0)])
		
		// Make the layout take effect
		forceLayout()
		
		// Test
		checkUnchangedParentView()
		XCTAssertEqual(subView1.frame, CGRect(x: 25.0, y: 25.0, width: 50.0, height: 50.0), "The subView has an incorrect frame.")
		
		checkCenteringFirstAttributes()
		checkCenteringSecondAttributes()
		
		// Code to test
		subView1.updatePins([.centerX(10.0), .centerY(20.0), .widthConstant(50.0), .heightConstant(50.0)])
		
		// Make the layout take effect
		forceLayout()
		
		// Test
		checkUnchangedParentView()
		XCTAssertEqual(subView1.frame, CGRect(x: 35.0, y: 45.0, width: 50.0, height: 50.0 ), "The subView has an incorrect frame.")
		
		checkCenteringFirstAttributes()
		checkCenteringSecondAttributes()
	}
	
	private func checkCenteringFirstAttributes() {
		let parentFirstAttributes = parentView.constraints.map({ $0.firstAttribute })
		let childFirstAttributes = subView1.constraints.map({ $0.firstAttribute })
		
		XCTAssertEqual(parentFirstAttributes.count, 2, "There should be 2 constraints on the parentView.")
		XCTAssertTrue(parentFirstAttributes.contains(.centerX), "There should be a centerX constraint on the parentView.")
		XCTAssertTrue(parentFirstAttributes.contains(.centerY), "There should be a centerY constraint on the parentView.")
		
		XCTAssertEqual(childFirstAttributes.count, 2, "There should be 2 constraints on the subView.")
		XCTAssertTrue(childFirstAttributes.contains(.width), "There should be a width constraint on the subView.")
		XCTAssertTrue(childFirstAttributes.contains(.height), "There should be a height constraint on the subView.")
	}
	
	private func checkCenteringSecondAttributes() {
		let parentSecondAttributes = parentView.constraints.map({ $0.secondAttribute })
		let childSecondAttributes = subView1.constraints.map({ $0.secondAttribute })
		
		XCTAssertEqual(parentSecondAttributes.count, 2, "There should be 2 constraints on the parentView.")
		XCTAssertTrue(parentSecondAttributes.contains(.centerX), "There should be a centerX constraint on the parentView.")
		XCTAssertTrue(parentSecondAttributes.contains(.centerY), "There should be a centerY constraint on the parentView.")
		
		XCTAssertEqual(childSecondAttributes.count, 2, "There should be 2 constraints on the subView.")
		childSecondAttributes.forEach {
			XCTAssertEqual($0, .notAnAttribute, "The second attribute for a width or height constant constraint should be `.notAnAttribute`.")
		}
	}
}
