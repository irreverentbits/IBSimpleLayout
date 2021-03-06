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
		checkUnchangedParentView()
		XCTAssertEqual(label1.frame, CGRect(x: 0.0, y: 0.0, width: 100.0, height: 20.0))
		XCTAssertEqual(label2.frame, CGRect(x: 0.0, y: 10.0, width: 100.0, height: 20.0))
		
		checkLabel1Attributes()
		checkLabel2Attributes()
	}
	
	func testNegativeFirstBaseline() {
		// Code to test
		label1.pushPins([.leading(0.0), .trailing(0.0), .top(0.0), .heightConstant(20.0)])
		label2.pushPins([.leading(0.0), .trailing(0.0), .heightConstant(20.0)])
		label2.pushPin(.firstBaseline(-10.0), relativeTo: label1)
		
		// Make the layout take effect
		forceLayout()
		
		// Test
		checkUnchangedParentView()
		XCTAssertEqual(label1.frame, CGRect(x: 0.0, y: 0.0, width: 100.0, height: 20.0))
		XCTAssertEqual(label2.frame, CGRect(x: 0.0, y: -10.0, width: 100.0, height: 20.0))
		
		checkLabel1Attributes()
		checkLabel2Attributes()
	}
	
	func testEqualFirstBaseline() {
		// Code to test
		label1.pushPins([.leading(0.0), .trailing(0.0), .top(0.0), .heightConstant(20.0)])
		label2.pushPins([.leading(0.0), .trailing(0.0), .heightConstant(20.0)])
		label2.pushPin(.firstBaseline(0.0), relativeTo: label1)
		
		// Make the layout take effect
		forceLayout()
		
		// Test
		checkUnchangedParentView()
		XCTAssertEqual(label1.frame, CGRect(x: 0.0, y: 0.0, width: 100.0, height: 20.0))
		XCTAssertEqual(label2.frame, CGRect(x: 0.0, y: 0.0, width: 100.0, height: 20.0))
		
		checkLabel1Attributes()
		checkLabel2Attributes()
	}
	
	func checkLabel1Attributes() {
		let parentFirstAttributes = parentView.constraints.filter({ $0.firstItem === label1 }).map({ $0.firstAttribute })
		XCTAssertEqual(parentFirstAttributes.count, 3, "")
		XCTAssertTrue(parentFirstAttributes.contains(.leading), "")
		XCTAssertTrue(parentFirstAttributes.contains(.trailing), "")
		XCTAssertTrue(parentFirstAttributes.contains(.top), "")
		
		// There will be additional constraints on the label for its intrinsic content size
		// So we need to be more specific about verifying that the constraint we added is present
		let labelHeightConstraints = label1.constraints.filter({ $0.constant == 20.0 })
		XCTAssertEqual(labelHeightConstraints.count, 1, "")
		XCTAssertEqual(labelHeightConstraints.first?.firstAttribute, .height, "")
	}
	
	func checkLabel2Attributes() {
		let parentFirstAttributes = parentView.constraints.filter({ $0.firstItem === label2 }).map({ $0.firstAttribute })
		XCTAssertEqual(parentFirstAttributes.count, 3, "")
		XCTAssertTrue(parentFirstAttributes.contains(.leading), "")
		XCTAssertTrue(parentFirstAttributes.contains(.trailing), "")
		XCTAssertTrue(parentFirstAttributes.contains(.firstBaseline), "")
		
		// There will be additional constraints on the label for its intrinsic content size
		// So we need to be more specific about verifying that the constraint we added is present
		let labelHeightConstraints = label2.constraints.filter({ $0.constant == 20.0 })
		XCTAssertEqual(labelHeightConstraints.count, 1, "")
		XCTAssertEqual(labelHeightConstraints.first?.firstAttribute, .height, "")
	}
}
