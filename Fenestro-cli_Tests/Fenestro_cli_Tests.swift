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
		let arguments: [String] = ["fenestro"]

		AssertNoThrow {
			let (name, path) = try parseArguments(arguments)

			XCTAssertEqual(name, " .html")
			XCTAssertNil(path)
		}
	}

	func testNoNameButPath () {
		let arguments: [String] = ["fenestro", "-p", "file.html"]

		AssertNoThrow {
			let (name, path) = try parseArguments(arguments)

			XCTAssertEqual(name, "file.html")
			XCTAssertEqual(path, NSURL(fileURLWithPath: "file.html", isDirectory: false))
		}
	}

	func testNameButNoPath () {
		let arguments: [String] = ["fenestro", "-n", "name"]

		AssertNoThrow {
			let (name, path) = try parseArguments(arguments)

			XCTAssertEqual(name, "name")
			XCTAssertNil(path)
		}
	}

	func testNameAndPath () {
		let arguments: [String] = ["fenestro", "-n", "name", "-p", "file.html"]

		AssertNoThrow {
			let (name, path) = try parseArguments(arguments)

			XCTAssertEqual(name, "name")
			XCTAssertEqual(path, NSURL(fileURLWithPath: "file.html", isDirectory: false))
		}
	}

	func testUnknownArgument () {
		let arguments: [String] = ["fenestro", "-u", "gibberish"]

		AssertThrows(MyError(description: "")) {
			try parseArguments(arguments)
		}
	}
}

class GetVerifiedPath_Tests: XCTestCase {

	func testNonExistingFileThrowsError () {
		do {
			try verifyOrCreateFile("", NSURL(fileURLWithPath: "idontexist.file"), contents: ReadableStream(NSFileHandle.fileHandleWithNullDevice()))
			XCTFail("getVerifiedPath should have thrown an error")
		} catch {}
	}

	func testNoPathCreatesAFile () {
		AssertNoThrow {
			let path = try verifyOrCreateFile("test.file", nil, contents: ReadableStream(NSFileHandle.fileHandleWithNullDevice()))
			try makeThrowable(path.checkResourceIsReachableAndReturnError)
		}
	}
}
