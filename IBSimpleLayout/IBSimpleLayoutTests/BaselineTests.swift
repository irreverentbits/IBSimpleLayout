//
//  FirstBaselineTests.swift
//  IBSimpleLayoutTests
//
//  Created by Lee Calloway on 8/6/17.
//  Copyright © 2017 Irreverent Bits. All rights reserved.
//

import XCTest

class FirstBaselineTests: IBSimpleLayoutTests {
	let label1 = UILabel()
	let label2 = UILabel()
	let font = UIFont.systemFont(ofSize: 10.0)
	
    override func setUp() {
        super.setUp()
		
		label1.font = font
		label1.text = "Irreverent Bits"
		parentView.addSubview(label1)
		
		label2.font = font
		label2.text = "Irreverent Bits"
		parentView.addSubview(label2)
    }
	
	func testPositiveFirstBaseline() {
		// Code to test
		label1.pushPins([.leading(0.0), .trailing(0.0), .top(0.0), .heightConstant(20.0)])
		label2.pushPins([.leading(0.0), .trailing(0.0), .heightConstant(20.0)])
		label2.pushPin(.firstBaseline(10.0), relativeTo: label1)
		
		// Make the layout take effect
		forceLayout()
		
		// Test
		testUnchangedParentView()
		XCTAssertEqual(label1.frame, CGRect(x: 0.0, y: 0.0, width: 100.0, height: 20.0))
		XCTAssertEqual(label2.frame, CGRect(x: 0.0, y: 10.0, width: 100.0, height: 20.0))
	}
	
	func testNegativeFirstBaseline() {
		// Code to test
		label1.pushPins([.leading(0.0), .trailing(0.0), .top(0.0), .heightConstant(20.0)])
		label2.pushPins([.leading(0.0), .trailing(0.0), .heightConstant(20.0)])
		label2.pushPin(.firstBaseline(-10.0), relativeTo: label1)
		
		// Make the layout take effect
		forceLayout()
		
		// Test
		testUnchangedParentView()
		XCTAssertEqual(label1.frame, CGRect(x: 0.0, y: 0.0, width: 100.0, height: 20.0))
		XCTAssertEqual(label2.frame, CGRect(x: 0.0, y: -10.0, width: 100.0, height: 20.0))
	}
	
	func testEqualFirstBaseline() {
		// Code to test
		label1.pushPins([.leading(0.0), .trailing(0.0), .top(0.0), .heightConstant(20.0)])
		label2.pushPins([.leading(0.0), .trailing(0.0), .heightConstant(20.0)])
		label2.pushPin(.firstBaseline(0.0), relativeTo: label1)
		
		// Make the layout take effect
		forceLayout()
		
		// Test
		testUnchangedParentView()
		XCTAssertEqual(label1.frame, CGRect(x: 0.0, y: 0.0, width: 100.0, height: 20.0))
		XCTAssertEqual(label2.frame, CGRect(x: 0.0, y: 0.0, width: 100.0, height: 20.0))
	}
	
	func checkFirstAttributes() {
		
	}
}
