//  Copyright © 2017 Irreverent Bits. All rights reserved.
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

extension UIView {
	// TODO: Abstract this to work with any tree structure given a structure specific function for finding descendants
	/**
	Find the common ancestor of two views in a view hierarchy. A view can be considered its own ancestor,
	so one of the provided views will be returned if it is an ancestor of the other view.
	- parameter firstView: The first of two possibly hierarchically related UIViews.
	- parameter secondView: The second of two possibly hierarchically related UIViews.
	- returns: The common ancestor of the `firstView` and the `secondView` or nil if there is no common ancestor.
	*/
	open func inclusiveCommonAncestor(firstView: UIView, secondView: UIView) -> UIView? {
		var foundAncestor: UIView? = nil
		
		// Check if one of the provided views is itself the common ancestor before moving up the hierarchy looking for a different ancestor
		if firstView.isDescendant(of: secondView) {
			foundAncestor = secondView
		} else if secondView.isDescendant(of: firstView) {
			foundAncestor = firstView
		} else {
			foundAncestor = exclusiveCommonAncestor(firstView: firstView, secondView: secondView)
		}
		
		return foundAncestor
	}
	
	// TODO: Abstract this to work with any tree structure given a structure specific function for finding descendants
	/**
	Find the common ancestor of the two views in a view hierarchy. A view cannot be considered its own ancestor.
	- parameter firstView: The first of two possibly hierarchically related UIViews.
	- parameter secondView: The second of two possibly hierarchically related UIViews.
	- returns: The common ancestor of both views or nil if there is no common ancestor.
	*/
	open func exclusiveCommonAncestor(firstView: UIView, secondView: UIView) -> UIView? {
		var foundAncestor: UIView? = nil
		
		var testAncestor: UIView? = firstView.superview
		
		while testAncestor != nil {
			if secondView.isDescendant(of: testAncestor!) {
				foundAncestor = testAncestor
				break
			}
			
			testAncestor = testAncestor!.superview
		}
		
		return foundAncestor
	}
}
