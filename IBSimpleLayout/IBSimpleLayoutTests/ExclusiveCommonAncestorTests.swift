//
//  ExclusiveCommonAncestorTests.swift
//  IBSimpleLayoutTests
//
//  Created by Lee Calloway on 8/23/17.
//  Copyright © 2017 Irreverent Bits. All rights reserved.
//

import XCTest

class ExclusiveCommonAncestorTests: IBSimpleLayoutTests {
	let ancestor = UIView()
	let parent1 = UIView()
	let parent2 = UIView()
	
	//        ancestor <--
	//        /     \
	// subView1     subView2
	func testSiblingsParent() {
		ancestor.addSubview(subView1)
		ancestor.addSubview(subView2)
		
		XCTAssertEqual(subView1.exclusiveCommonAncestor(with: subView2), ancestor, "Siblings parent was not found as ancestor")
		XCTAssertEqual(subView2.exclusiveCommonAncestor(with: subView1), ancestor, "Siblings parent was not found as ancestor")
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
		
		XCTAssertEqual(subView1.exclusiveCommonAncestor(with: subView2), ancestor, "Cousins grandparent not found as ancestor")
		XCTAssertEqual(subView2.exclusiveCommonAncestor(with: subView1), ancestor, "Cousins grandparent not found as ancestor")
	}
	
	// ancestor
	//    |
	// subView1
	func testSelfParent() {
		ancestor.addSubview(subView1)
		
		XCTAssertNil(subView1.exclusiveCommonAncestor(with: ancestor), "Parent cannot be its own ancestor")
		XCTAssertNil(ancestor.exclusiveCommonAncestor(with: subView1), "Parent cannot be its own ancestor")
	}
	
	// ancestor
	//    |
	// parent1
	//    |
	// subView1
	func testSelfAncestor() {
		ancestor.addSubview(parent1)
		parent1.addSubview(subView1)
		
		XCTAssertNil(subView1.exclusiveCommonAncestor(with: ancestor), "Grandparent cannot be its own ancestor")
		XCTAssertNil(ancestor.exclusiveCommonAncestor(with: subView1), "Grandparent cannot be its own ancestor")
		
		XCTAssertEqual(subView1.exclusiveCommonAncestor(with: parent1), ancestor, "Grandparent should be the ancestor of a parent and child")
		XCTAssertEqual(parent1.exclusiveCommonAncestor(with: subView1), ancestor, "Grandparent should be the ancestor of a parent and child")
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
		
		XCTAssertEqual(parent1.exclusiveCommonAncestor(with: subView2), ancestor, "Grandparent not found as ancestor to grandchild and aunt/uncle.")
		XCTAssertEqual(subView2.exclusiveCommonAncestor(with: parent1), ancestor, "Grandparent not found as ancestor to grandchild and aunt/uncle.")
	}
}
