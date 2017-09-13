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

import XCTest

class DimensionTests: IBSimpleLayoutTests {
	func testEqualRelativeDimensions() {
		// Code to test
		subView1.pushPins([.width(0.0), .height(0.0), .leading(0.0), .top(0.0)])
		
		// Make the layout take effect
		forceLayout()
		
		// Test
		checkUnchangedParentView()
		XCTAssertEqual(subView1.frame, CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0), "The subView has an incorrect frame.")
		
		let firstAttributes = parentView.constraints.map({ $0.firstAttribute })
		
		XCTAssertEqual(firstAttributes.count, 4, "There should be 4 constraints on the parent view.")
		XCTAssertTrue(firstAttributes.contains(.width), "There should be a width constraint on the parentView.")
		XCTAssertTrue(firstAttributes.contains(.height), "There should be a height constraint on the parentView.")
		XCTAssertTrue(firstAttributes.contains(.leading), "There should be a leading constraint on the parentView.")
		XCTAssertTrue(firstAttributes.contains(.top), "There should be a top constraint on the parentView.")
	}
	
	func testUnequalRelativeDimensions() {
		// Code to test
		subView1.pushPins([.width(-50.0), .height(50.0), .leading(0.0), .top(0.0)])
		
		// Make the layout take effect
		forceLayout()
		
		// Test
		checkUnchangedParentView()
		XCTAssertEqual(subView1.frame, CGRect(x: 0.0, y: 0.0, width: 50.0, height: 150.0), "The subView has an incorrect frame.")
		
		let firstAttributes = parentView.constraints.map({ $0.firstAttribute })
		
		XCTAssertEqual(firstAttributes.count, 4, "There should be 4 constraints on the parent view.")
		XCTAssertTrue(firstAttributes.contains(.width), "There should be a width constraint on the parentView.")
		XCTAssertTrue(firstAttributes.contains(.height), "There should be a height constraint on the parentView.")
		XCTAssertTrue(firstAttributes.contains(.leading), "There should be a leading constraint on the parentView.")
		XCTAssertTrue(firstAttributes.contains(.top), "There should be a top constraint on the parentView.")
	}
	
	func testPositiveConstantDimensions() {
		// Code to test
		subView1.pushPins([.widthConstant(50.0), .heightConstant(75.0), .leading(10.0), .top(10.0)])
		
		// Make the layout take effect
		forceLayout()
		
		// Test
		checkUnchangedParentView()
		XCTAssertEqual(subView1.frame, CGRect(x: 10.0, y: 10.0, width: 50.0, height: 75.0), "The subView has an incorrect frame.")
		
		let parentFirstAttributes = parentView.constraints.map({ $0.firstAttribute })
		let childFirstAttributes = subView1.constraints.map({ $0.firstAttribute })
		
		XCTAssertTrue(parentFirstAttributes.count == 2, "There should be 2 constraints on the parent view.")
		XCTAssertTrue(parentFirstAttributes.contains(.leading), "There should be a leading constraint on the parentView.")
		XCTAssertTrue(parentFirstAttributes.contains(.top), "There should be a top constraint on the parentView.")
		
		XCTAssertTrue(childFirstAttributes.count == 2, "There should be 2 constraints on the subView.")
		XCTAssertTrue(childFirstAttributes.contains(.width), "There should be a width constraint on the subView.")
		XCTAssertTrue(childFirstAttributes.contains(.height), "There should be a height constraint on the subView.")
	}
	
	func testNegativeConstantDimensions() {
		// Code to test
		subView1.pushPins([.widthConstant(-10.0), .heightConstant(-20.0), .leading(10.0), .top(10.0)])
		
		// Make the layout take effect
		forceLayout()
		
		// Test
		checkUnchangedParentView()
		XCTAssertEqual(subView1.frame, CGRect(x: 10.0, y: 10.0, width: 0.0, height: 0.0), "Negative dimension constants should be replaced with values of zero.")
		
		let parentFirstAttributes = parentView.constraints.map({ $0.firstAttribute })
		let childFirstAttributes = subView1.constraints.map({ $0.firstAttribute })
		
		XCTAssertTrue(parentFirstAttributes.count == 2, "There should be 2 constraints on the parent view.")
		XCTAssertTrue(parentFirstAttributes.contains(.leading), "There should be a leading constraint on the parentView.")
		XCTAssertTrue(parentFirstAttributes.contains(.top), "There should be a top constraint on the parentView.")
		
		XCTAssertTrue(childFirstAttributes.count == 2, "There should be 2 constraints on the subView.")
		XCTAssertTrue(childFirstAttributes.contains(.width), "There should be a width constraint on the subView.")
		XCTAssertTrue(childFirstAttributes.contains(.height), "There should be a height constraint on the subView.")
	}
}
