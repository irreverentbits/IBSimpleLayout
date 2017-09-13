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

class MarginUpdateTests: IBSimpleLayoutTests {
	func testZeroToPositiveMargins() {
		// Code to test
		subView1.pushPins([.leadingMargin(0.0), .trailingMargin(0.0), .topMargin(0.0), .bottomMargin(0.0)])
		
		// Make the layout take effect
		forceLayout()
		
		// Test - Note, standard view margins is 8.0 points
		checkUnchangedParentView()
		XCTAssertEqual(subView1.frame, CGRect(x: 8.0, y: 8.0, width: 84.0, height: 84.0), "The subView has an incorrect frame.")
		
		checkMarginFirstAttributes()
		checkMarginSecondAttributes()
		
		// Code to test
		subView1.updatePins([.leadingMargin(10.0), .trailingMargin(15.0), .topMargin(5.0), .bottomMargin(20.0)])
		
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
