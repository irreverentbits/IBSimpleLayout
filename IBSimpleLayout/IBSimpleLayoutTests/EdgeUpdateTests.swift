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

class EdgeUpdateTests: IBSimpleLayoutTests {
	func testZeroToPositiveEdges() {
		// Code to test
		subView1.pushPins([.leading(0.0), .trailing(0.0), .top(0.0), .bottom(0.0)])
		
		// Make the layout take effect
		forceLayout()
		
		// Test
		XCTAssertEqual(subView1.frame, CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0), "The subView has an incorrect frame.")
		XCTAssertEqual(parentView.frame, subView1.frame, "The subView frame should match the parentView frame.")
		
		checkEdgeFirstAttributes()
		checkEdgeSecondAttributes()

		// Code to test
		subView1.updatePins([.leading(10.0), .trailing(15.0), .top(20.0), .bottom(25.0)])
		
		// Make the layout take effect
		forceLayout()
		
		// Test
		XCTAssertEqual(subView1.frame, CGRect(x: 10.0, y: 20.0, width: 105.0, height: 105.0), "The subView has an incorrect frame.")
		checkUnchangedParentView()
		
		checkEdgeFirstAttributes()
		checkEdgeSecondAttributes()
	}

	private func checkEdgeFirstAttributes() {
		let firstAttributes = parentView.constraints.map({ $0.firstAttribute })
		
		XCTAssertEqual(firstAttributes.count, 4, "There should be 4 constraints on the parent view.")
		XCTAssertTrue(firstAttributes.contains(.leading), "There should be a leading constraint on the parentView.")
		XCTAssertTrue(firstAttributes.contains(.trailing), "There should be a trailing constraint on the parentView.")
		XCTAssertTrue(firstAttributes.contains(.top), "There should be a top constraint on the parentView.")
		XCTAssertTrue(firstAttributes.contains(.bottom), "There should be a bottom constraint on the parentView.")
	}
	
	private func checkEdgeSecondAttributes() {
		let secondAttributes = parentView.constraints.map({ $0.secondAttribute })
		
		XCTAssertEqual(secondAttributes.count, 4, "There should be 4 constraints on the parent view.")
		XCTAssertTrue(secondAttributes.contains(.leading), "There should be a leading constraint on the parentView.")
		XCTAssertTrue(secondAttributes.contains(.trailing), "There should be a trailing constraint on the parentView.")
		XCTAssertTrue(secondAttributes.contains(.top), "There should be a top constraint on the parentView.")
		XCTAssertTrue(secondAttributes.contains(.bottom), "There should be a bottom constraint on the parentView.")
	}
}
