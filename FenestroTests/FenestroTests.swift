//
//  FenestroTests.swift
//  FenestroTests
//
//  Created by Kåre Morstøl on 21.10.15.
//  Copyright © 2015 Corporate Runaways, LLC. All rights reserved.
//

import XCTest
@testable import Fenestro

class ListController_Tests: XCTestCase {

	func testFilesAreAddedCorrectly () {
		let list = ListController(name: "file 1", path: NSURL(fileURLWithPath: ""))
		list.addFile(name: "file 2", path: NSURL(fileURLWithPath: ""))

		let _ = list.view

		XCTAssertEqual(list.tableview.numberOfRows, 2)
	}
}
