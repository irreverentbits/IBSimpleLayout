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
}
