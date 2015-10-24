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

class DocumentController_Tests: XCTestCase {

	let doccontroller = DocumentController ()

	override func setUp () {
		/* NSDocumentController is a true singleton which we can't get rid of,
			so we have to reset it for every test. */
		doccontroller.documents.forEach {$0.close()}
		doccontroller.timeoflastopening = NSDate.distantPast()
	}

	override func tearDown () {
	}

	func testOpen1File () {
		let expectation = expectationWithDescription("Document created")

		doccontroller.openDocumentWithContentsOfURL(Document.defaultpath, display: true) { newdocument, _, error in
			if let _ = newdocument as? Document {
				expectation.fulfill()
			} else {
				XCTFail(error?.localizedDescription ?? "Document created was not of type 'Document'")
			}
		}

		waitForExpectationsWithTimeout(1.0, handler: nil)
		XCTAssertEqual(doccontroller.documents.count, 1)
	}

	func testOpen2FilesInOneDocument () {
		let expectation = expectationWithDescription("Document with 2 files created")

		doccontroller.openDocumentWithContentsOfURL(urlForTestResource("1", type: "html"), display: true) { _,_,_ in }
		doccontroller.openDocumentWithContentsOfURL(urlForTestResource("2", type: "html"), display: true) { newdocument, _, error in
			if let _ = newdocument as? Document {
				expectation.fulfill()
			} else {
				XCTFail(error?.localizedDescription ?? "Document created was not of type 'Document'")
			}
		}

		waitForExpectationsWithTimeout(1.0, handler: nil)
		XCTAssertEqual(doccontroller.documents.count, 1)
	}
}

extension XCTestCase {

	func urlForTestResource (filename: String, type: String) -> NSURL {
		guard let path = NSBundle(forClass: self.dynamicType).pathForResource(filename, ofType: type) else {
			preconditionFailure("resource \(filename).\(type) not found")
		}

		return NSURL(fileURLWithPath: path)
	}
}
