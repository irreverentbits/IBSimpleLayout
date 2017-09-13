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
@testable import IBSimpleLayout

class IBSimpleLayoutTests: XCTestCase {
	let parentView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0))
	let subView1 = UIView()
	let subView2 = UIView()
	
    override func setUp() {
        super.setUp()
		
		parentView.addSubview(subView1)
		parentView.addSubview(subView2)
	}
    
    override func tearDown() {
        super.tearDown()
    }
	
	internal func forceLayout() {
		parentView.setNeedsLayout()
		parentView.layoutIfNeeded()
	}
	
	internal func checkUnchangedParentView() {
		XCTAssertEqual(parentView.frame, CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0), "The parentView frame should not have changed.")
	}
}
