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

import Foundation

public extension UIView {
	/**
	Find the common ancestor between this view and another view in a view hierarchy. A view can be considered its own ancestor,
	so `self` or `otherView` are valid returns if either is an ancestor of the other.
	- parameter otherView: The other view that may be hierarchically related to this view.
	- returns: The common ancestor of `self` and the `otherView` or nil if there is no common ancestor.
	*/
	func inclusiveCommonAncestor(with otherView: UIView) -> UIView? {
		var foundAncestor: UIView? = nil
		
		// Check if one of the provided views is itself the common ancestor before moving up the hierarchy looking for a different ancestor
		if self.isDescendant(of: otherView) {
			foundAncestor = otherView
		} else if otherView.isDescendant(of: self) {
			foundAncestor = self
		} else {
			foundAncestor = exclusiveCommonAncestor(with: otherView)
		}
		
		return foundAncestor
	}
	
	/**
	Find the common ancestor of the two views in a view hierarchy. A view is not considered to be its own ancestor.
	If `self` and `otherView` have a direct lineage, then the common ancestor is the ancestor that is one or more levels above both.
	For example, the common ancestor for a parent and child is the parent's parent (aka the child's grandparent).
	- parameter otherView: The other view that may be hierarchically related to this view.
	- returns: The common ancestor of both `self` and `otherView` or nil if there is no common ancestor.
	*/
	func exclusiveCommonAncestor(with otherView: UIView) -> UIView? {
		var foundAncestor: UIView? = nil
		var testAncestor: UIView? = self.superview
		
		while testAncestor != nil {
			// If otherView is ever the same as the testAncestor, that means it is a direct ancestor of self
			// so the common ancestor would be otherView's parent view.
			if otherView === testAncestor {
				return otherView.superview
			}
			
			if otherView.isDescendant(of: testAncestor!) {
				foundAncestor = testAncestor
				break
			}
			
			testAncestor = testAncestor!.superview
		}
		
		return foundAncestor
	}
}
