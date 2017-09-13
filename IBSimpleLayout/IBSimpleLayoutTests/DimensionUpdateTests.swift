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

class DimensionUpdateTests: IBSimpleLayoutTests {
	func testEqualToUnequalRelativeDimensions() {
		// Code to test
		subView1.pushPins([.width(0.0), .height(0.0), .leading(0.0), .top(0.0)])
		
		// Make the layout take effect
		forceLayout()
		
		// Test
		checkUnchangedParentView()
		XCTAssertEqual(subView1.frame, CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0), "The subView has an incorrect frame.")
		
		var firstAttributes = parentView.constraints.map({ $0.firstAttribute })
		
		XCTAssertEqual(firstAttributes.count, 4, "There should be 4 constraints on the parent view.")
		XCTAssertTrue(firstAttributes.contains(.width), "There should be a width constraint on the parentView.")
		XCTAssertTrue(firstAttributes.contains(.height), "There should be a height constraint on the parentView.")
		XCTAssertTrue(firstAttributes.contains(.leading), "There should be a leading constraint on the parentView.")
		XCTAssertTrue(firstAttributes.contains(.top), "There should be a top constraint on the parentView.")
		
		// Code to test
		subView1.updatePins([.width(-50.0), .height(50.0), .leading(0.0), .top(0.0)])
		
		// Make the layout take effect
		forceLayout()
		
		// Test
		checkUnchangedParentView()
		XCTAssertEqual(subView1.frame, CGRect(x: 0.0, y: 0.0, width: 50.0, height: 150.0), "The subView has an incorrect frame.")
		
		firstAttributes = parentView.constraints.map({ $0.firstAttribute })
		
		XCTAssertEqual(firstAttributes.count, 4, "There should be 4 constraints on the parent view.")
		XCTAssertTrue(firstAttributes.contains(.width), "There should be a width constraint on the parentView.")
		XCTAssertTrue(firstAttributes.contains(.height), "There should be a height constraint on the parentView.")
		XCTAssertTrue(firstAttributes.contains(.leading), "There should be a leading constraint on the parentView.")
		XCTAssertTrue(firstAttributes.contains(.top), "There should be a top constraint on the parentView.")
	}
}
