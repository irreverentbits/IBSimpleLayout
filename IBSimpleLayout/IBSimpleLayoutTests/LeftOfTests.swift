//
//  LeftOfTests.swift
//  IBSimpleLayoutTests
//
//  Created by Lee Calloway on 9/20/17.
//  Copyright © 2017 Irreverent Bits. All rights reserved.
//

import XCTest

class LeftOfTests: IBSimpleLayoutTests {
	func testPositiveLeftOfParentView() {
		// Code to test
		subView1.pushPins([.width(0.0), .height(0.0), .top(0.0)])
		subView1.pushPin(.leftOf(10.0))
		
		// Make the layout take effect
		forceLayout()
		
		// Test
		checkUnchangedParentView()
		XCTAssertEqual(subView1.frame, CGRect(x: -parentView.frame.width + 10.0, y: 0.0, width: parentView.frame.width, height: parentView.frame.height), "The subView has an incorrect frame.")
	}
	
	func testDirectlyLeftOfSiblingView() {
		// Code to test
		subView1.pushPins([.widthConstant(50.0), .heightConstant(50.0), .trailing(0.0), .top(0.0)])
		subView2.pushPins([.widthConstant(50.0), .heightConstant(50.0), .top(0.0)])
		subView2.pushPin(.leftOf(0.0), relativeTo: subView1)
		
		// Make the layout take effect
		forceLayout()
		
		// Test
		checkUnchangedParentView()
		XCTAssertEqual(subView1.frame, CGRect(x: 50.0, y: 0.0, width: 50.0, height: 50.0), "The first subView has an incorrect frame.")
		XCTAssertEqual(subView2.frame, CGRect(x: 0.0, y: 0.0, width: 50.0, height: 50.0), "The second subView has an incorrect frame.")
	}
	
	func testNegativeLeftOfParentView() {
		// Code to test
		subView1.pushPins([.width(0.0), .height(0.0), .top(0.0)])
		subView1.pushPin(.leftOf(-10.0))
		
		// Make the layout take effect
		forceLayout()
		
		// Test
		checkUnchangedParentView()
		XCTAssertEqual(subView1.frame, CGRect(x: -parentView.frame.width - 10.0, y: 0.0, width: parentView.frame.width, height: parentView.frame.height), "The subView has an incorrect frame.")
	}
}
