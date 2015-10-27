//
//  Fenestro_cli_Tests.swift
//  Fenestro-cli_Tests
//
//  Created by Kåre Morstøl on 26.10.15.
//  Copyright © 2015 Corporate Runaways, LLC. All rights reserved.
//

import XCTest

class Fenestro_cli_Arguments: XCTestCase {
    
	func testNoArgs () {
		let arguments: [String] = ["fenestro"]

		AssertNoThrow {
			let (name, path) = try parseArguments(arguments)

			XCTAssertEqual(name, "")
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
			let (name, path) = try parseArguments(arguments)

			XCTAssertEqual(name, "name")
			XCTAssertEqual(path, NSURL(fileURLWithPath: "file.html", isDirectory: false))
		}
	}
}
