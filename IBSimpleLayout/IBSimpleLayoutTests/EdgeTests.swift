//
//  LeadingTests.swift
//  IBSimpleLayoutTests
//
//  Created by Lee Calloway on 7/28/17.
//  Copyright © 2017 Irreverent Bits. All rights reserved.
//

import XCTest

class EdgeTests: IBSimpleLayoutTests {
	func testZeroMargins() {
		// Code to test
		subView1.pushPins([.leading(0.0), .trailing(0.0), .top(0.0), .bottom(0.0)])
		
		// Make the layout take effect
		forceLayout()
		
		// Test
		XCTAssertEqual(subView1.frame, CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0), "The subView has an incorrect frame.")
		XCTAssertEqual(parentView.frame, subView1.frame, "The subView frame should match the parentView frame.")
		
		checkFirstAttributes()
		checkSecondAttributes()
	}
	
	func testPositiveMargins() {
		// Code to test
		subView1.pushPins([.leading(10.0), .trailing(15.0), .top(20.0), .bottom(25.0)])
		
		// Make the layout take effect
		forceLayout()
		
		// Test
		XCTAssertEqual(subView1.frame, CGRect(x: 10.0, y: 20.0, width: 105.0, height: 105.0), "The subView has an incorrect frame.")
		testUnchangedParentView()
		
		checkFirstAttributes()
		checkSecondAttributes()
	}
	
	func testNegativeMargins() {
		// Code to test
		subView1.pushPins([.leading(-5.0), .trailing(-10.0), .top(-15.0), .bottom(-20.0)])
		
		// Make the layout take effect
		forceLayout()
		
		// Test
		XCTAssertEqual(subView1.frame, CGRect(x: -5.0, y: -15.0, width: 95.0, height: 95.0), "The subView has an incorrect frame.")
		testUnchangedParentView()
		
		checkFirstAttributes()
		checkSecondAttributes()
	}
		
	private func checkFirstAttributes() {
		let firstAttributes = parentView.constraints.map({ $0.firstAttribute })
		
		XCTAssertEqual(firstAttributes.count, 4, "There should be 4 constraints on the parent view.")
		XCTAssertTrue(firstAttributes.contains(.leading), "There should be a leading constraint on the parentView.")
		XCTAssertTrue(firstAttributes.contains(.trailing), "There should be a trailing constraint on the parentView.")
		XCTAssertTrue(firstAttributes.contains(.top), "There should be a top constraint on the parentView.")
		XCTAssertTrue(firstAttributes.contains(.bottom), "There should be a bottom constraint on the parentView.")
	}
	
	private func checkSecondAttributes() {
		let secondAttributes = parentView.constraints.map({ $0.secondAttribute })
		
		XCTAssertEqual(secondAttributes.count, 4, "There should be 4 constraints on the parent view.")
		XCTAssertTrue(secondAttributes.contains(.leading), "There should be a leading constraint on the parentView.")
		XCTAssertTrue(secondAttributes.contains(.trailing), "There should be a trailing constraint on the parentView.")
		XCTAssertTrue(secondAttributes.contains(.top), "There should be a top constraint on the parentView.")
		XCTAssertTrue(secondAttributes.contains(.bottom), "There should be a bottom constraint on the parentView.")
	}
}
