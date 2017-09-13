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

class InclusiveCommonAncestorTests: IBSimpleLayoutTests {
	let ancestor = UIView()
	let parent1 = UIView()
	let parent2 = UIView()
		
	//        ancestor <--
	//        /     \
	// subView1     subView2
	func testSiblingsParent() {
		ancestor.addSubview(subView1)
		ancestor.addSubview(subView2)

		XCTAssertEqual(subView1.inclusiveCommonAncestor(with: subView2), ancestor, "Siblings parent was not found as ancestor")
		XCTAssertEqual(subView2.inclusiveCommonAncestor(with: subView1), ancestor, "Siblings parent was not found as ancestor")
	}
	
	//          ancestor <--
	//          /      \
	//    parent1      parent2
	//        /          \
	// subView1          subView2
	func testAncestor() {
		ancestor.addSubview(parent1)
		ancestor.addSubview(parent2)
		parent1.addSubview(subView1)
		parent2.addSubview(subView2)
		
		XCTAssertEqual(subView1.inclusiveCommonAncestor(with: subView2), ancestor, "Cousins grandparent not found as ancestor")
		XCTAssertEqual(subView2.inclusiveCommonAncestor(with: subView1), ancestor, "Cousins grandparent not found as ancestor")
	}
	
	// ancestor <--
	//    |
	// subView1
	func testSelfParent() {
		ancestor.addSubview(subView1)
		
		XCTAssertEqual(subView1.inclusiveCommonAncestor(with: ancestor), ancestor, "Parent not found as self ancestor")
		XCTAssertEqual(ancestor.inclusiveCommonAncestor(with: subView1), ancestor, "Parent not found as self ancestor")
	}

	// ancestor <--
	//     |
	//  parent1
	//     |
	// 	subView1
	func testSelfAncestor() {
		ancestor.addSubview(parent1)
		parent1.addSubview(subView1)
		
		XCTAssertEqual(subView1.inclusiveCommonAncestor(with: ancestor), ancestor, "Grandparent not found as self ancestor")
		XCTAssertEqual(ancestor.inclusiveCommonAncestor(with: subView1), ancestor, "Grandparent not found as self ancestor")
	}
	
	//       ancestor <--
	//        /    \
	//  parent1    parent2
	//               \
	//               subView2
	func testUnbalancedAncestor() {
		ancestor.addSubview(parent1)
		ancestor.addSubview(parent2)
		parent2.addSubview(subView2)
		
		XCTAssertEqual(parent1.inclusiveCommonAncestor(with: subView2), ancestor, "Grandparent not found as ancestor to grandchild and aunt/uncle.")
		XCTAssertEqual(subView2.inclusiveCommonAncestor(with: parent1), ancestor, "Grandparent not found as ancestor to grandchild and aunt/uncle.")
	}
}
