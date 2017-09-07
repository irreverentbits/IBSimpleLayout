//
//  AboveBelowTests.swift
//  IBSimpleLayoutTests
//
//  Created by Lee Calloway on 8/1/17.
//  Copyright © 2017 Irreverent Bits. All rights reserved.
//

import XCTest

class AboveBelowTests: IBSimpleLayoutTests {
	func testPositiveBelowParentView() {
		let kHeight: CGFloat = 20.0
		
		// Code to test
		subView1.pushPins([.leading(0.0), .trailing(0.0), .heightConstant(kHeight)])
		subView1.pushPin(.below(10.0))
		
		// Make the layout take effect
		forceLayout()
		
		// Test
		checkUnchangedParentView()
		XCTAssertEqual(subView1.frame, CGRect(x: 0.0, y: 110.0, width: parentView.frame.width, height: kHeight), "The subView has an incorrect frame.")
	}
	
	func testDirectlyBelowSiblingView() {
		let kHeight: CGFloat = 20.0
		
		// Code to test
		subView1.pushPins([.leading(0.0), .trailing(0.0), .top(0.0), .heightConstant(kHeight)])
		subView2.pushPins([.leading(0.0), .trailing(0.0), .heightConstant(kHeight)])
		subView2.pushPin(.below(0.0), relativeTo: subView1)
		
		// Make the layout take effect
		forceLayout()
		
		// Test
		checkUnchangedParentView()
		XCTAssertEqual(subView1.frame, CGRect(x: 0.0, y: 0.0, width: parentView.frame.width, height: kHeight), "The first subView has an incorrect frame.")
		XCTAssertEqual(subView2.frame, CGRect(x: 0.0, y: kHeight, width: parentView.frame.width, height: kHeight), "The second subView has an incorrect frame.")
	}
	
	func testNegativeBelowParentView() {
		let kHeight: CGFloat = 20.0
		
		// Code to test
		subView1.pushPins([.leading(0.0), .trailing(0.0), .heightConstant(kHeight)])
		subView1.pushPin(.below(-10.0))
		
		// Make the layout take effect
		forceLayout()
		
		// Test
		checkUnchangedParentView()
		XCTAssertEqual(subView1.frame, CGRect(x: 0.0, y: 90.0, width: parentView.frame.width, height: kHeight), "The subView has an incorrect frame.")
	}
	
	func testPositiveAboveParentView() {
		let kHeight: CGFloat = 20.0
		
		// Code to test
		subView1.pushPins([.leading(0.0), .trailing(0.0), .heightConstant(kHeight)])
		subView1.pushPin(.above(10.0))
		
		// Make the layout take effect
		forceLayout()
		
		// Test
		checkUnchangedParentView()
		XCTAssertEqual(subView1.frame, CGRect(x: 0.0, y: -30.0, width: parentView.frame.width, height: kHeight), "The subView has an incorrect frame.")
	}
	
	func testDirectlyAboveSiblingView() {
		let kHeight: CGFloat = 20.0
		
		// Code to test
		subView1.pushPins([.leading(0.0), .trailing(0.0), .bottom(0.0), .heightConstant(kHeight)])
		subView2.pushPins([.leading(0.0), .trailing(0.0), .heightConstant(kHeight)])
		subView2.pushPin(.above(0.0), relativeTo: subView1)
		
		// Make the layout take effect
		forceLayout()
		
		// Test
		checkUnchangedParentView()
		XCTAssertEqual(subView1.frame, CGRect(x: 0.0, y: parentView.frame.height - kHeight, width: parentView.frame.width, height: kHeight), "The first subView has an incorrect frame.")
		XCTAssertEqual(subView2.frame, CGRect(x: 0.0, y: subView1.frame.minY - kHeight, width: parentView.frame.width, height: kHeight), "The second subView has an incorrect frame.")
	}
	
	func testNegativeAboveParentView() {
		let kHeight: CGFloat = 20.0
		
		// Code to test
		subView1.pushPins([.leading(0.0), .trailing(0.0), .heightConstant(20.0)])
		subView1.pushPin(.above(-10.0))
		
		// Make the layout take effect
		forceLayout()
		
		// Test
		checkUnchangedParentView()
		XCTAssertEqual(subView1.frame, CGRect(x: 0.0, y: -10.0, width: parentView.frame.width, height: kHeight), "The subView has an incorrect frame.")
	}
}
