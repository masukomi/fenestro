//
//  Fenestro_cli_Tests.swift
//  Fenestro-cli_Tests
//
//  Created by Kåre Morstøl on 26.10.15.
//  Copyright © 2015 Corporate Runaways, LLC. All rights reserved.
//

import XCTest

class ParseArguments_Tests: XCTestCase {

	func testNoArgs () {
		let arguments = [String]()

		AssertNoThrow {
			let (name, path, _) = try parseArguments(arguments)

			XCTAssertEqual(name, " .html")
			XCTAssertNil(path)
		}
	}

	func testNoNameButPath () {
		let arguments = ["-p", "file.html"]

		AssertNoThrow {
			let (name, path, _) = try parseArguments(arguments)

			XCTAssertEqual(name, "file.html")
			XCTAssertEqual(path, NSURL(fileURLWithPath: "file.html", isDirectory: false))
		}
	}

	func testNameButNoPath () {
		let arguments = ["--name", "name"]

		AssertNoThrow {
			let (name, path, _) = try parseArguments(arguments)

			XCTAssertEqual(name, "name")
			XCTAssertNil(path)
		}
	}

	func testNameAndPath () {
		let arguments = ["-n", "name", "-p", "file.html"]

		AssertNoThrow {
			let (name, path, _) = try parseArguments(arguments)

			XCTAssertEqual(name, "name")
			XCTAssertEqual(path, NSURL(fileURLWithPath: "file.html", isDirectory: false))
		}
	}

	func testUnknownArgument () {
		let arguments = ["gibberish"]

		do {
			try parseArguments(arguments)
			XCTFail("parseArguments should have thrown an error")
		} catch {}
	}
}

class GetVerifiedPath_Tests: XCTestCase {

	func testNonExistingFileThrowsError () {
		do {
			try verifyOrCreateFile("", NSURL(fileURLWithPath: "idontexist.file"), contents: ReadableStream(NSFileHandle.fileHandleWithNullDevice()))
			XCTFail("verifyOrCreateFile should have thrown an error")
		} catch {}
	}

	func testNoPathCreatesAFile () {
		AssertNoThrow {
			let path = try verifyOrCreateFile("test.file", nil, contents: ReadableStream(NSFileHandle.fileHandleWithNullDevice()))
			try makeThrowable(path.checkResourceIsReachableAndReturnError)
		}
	}

	func testPathCopiesFile () {
		AssertNoThrow {
			let oldpath = urlForTestResource( "1", type: "html")
			let path = try verifyOrCreateFile("test2.file", oldpath, contents: ReadableStream(NSFileHandle.fileHandleWithNullDevice()))

			XCTAssertEqual(path.lastPathComponent, "test2.file")
			let contentsfromoldpath = try String(contentsOfURL: oldpath)
			let contentsfromnewpath = try String(contentsOfURL: path)
			XCTAssertEqual(contentsfromoldpath, contentsfromnewpath)
		}
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

