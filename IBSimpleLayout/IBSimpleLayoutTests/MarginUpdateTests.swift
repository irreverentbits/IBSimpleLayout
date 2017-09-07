//
//  MarginUpdateTests.swift
//  IBSimpleLayoutTests
//
//  Created by Lee Calloway on 8/23/17.
//  Copyright © 2017 Irreverent Bits. All rights reserved.
//

import XCTest

class MarginUpdateTests: IBSimpleLayoutTests {
	func testZeroToPositiveMargins() {
		// Code to test
		subView1.pushPins([.leftMargin(0.0), .rightMargin(0.0), .topMargin(0.0), .bottomMargin(0.0)])
		
		// Make the layout take effect
		forceLayout()
		
		// Test - Note, standard view margins is 8.0 points
		checkUnchangedParentView()
		XCTAssertEqual(subView1.frame, CGRect(x: 8.0, y: 8.0, width: 84.0, height: 84.0), "The subView has an incorrect frame.")
		
		checkMarginFirstAttributes()
		checkMarginSecondAttributes()
		
		// Code to test
		subView1.updatePins([.leftMargin(10.0), .rightMargin(15.0), .topMargin(5.0), .bottomMargin(20.0)])
		
		// Make the layout take effect
		forceLayout()
		
		// Test - Note, standard view margins is 8.0 points
		checkUnchangedParentView()
		XCTAssertEqual(subView1.frame, CGRect(x: 18.0, y: 13.0, width: 89.0, height: 99.0), "The subView has an incorrect frame.")
		
		checkMarginFirstAttributes()
		checkMarginSecondAttributes()
	}
	
	private func checkMarginFirstAttributes() {
		let firstAttributes = parentView.constraints.map({ $0.firstAttribute })
		
		XCTAssertTrue(firstAttributes.count == 4, "There should be 4 constraints on the parent view.")
		XCTAssertTrue(firstAttributes.contains(.leading), "There should be a leading constraint on the parentView.")
		XCTAssertTrue(firstAttributes.contains(.trailing), "There should be a trailing constraint on the parentView.")
		XCTAssertTrue(firstAttributes.contains(.top), "There should be a top constraint on the parentView.")
		XCTAssertTrue(firstAttributes.contains(.bottom), "There should be a bottom constraint on the parentView.")
	}
	
	private func checkMarginSecondAttributes() {
		let secondAttributes = parentView.constraints.map({ $0.secondAttribute })
		
		XCTAssertTrue(secondAttributes.count == 4, "There should be 4 constraints on the parent view.")
		XCTAssertTrue(secondAttributes.contains(.leadingMargin), "There should be a constraint to a leadingMargin on the parentView.")
		XCTAssertTrue(secondAttributes.contains(.trailingMargin), "There should be a constraint to a trailingMargin on the parentView.")
		XCTAssertTrue(secondAttributes.contains(.topMargin), "There should be a constraint to a topMargin on the parentView.")
		XCTAssertTrue(secondAttributes.contains(.bottomMargin), "There should be a constraint to a bottomMargin on the parentView.")
	}
}
