//
//  main.swift
//  fenestro-cli
//
//  Created by Kåre Morstøl on 26.10.15.
//  Copyright © 2015 Corporate Runaways, LLC. All rights reserved.
//

import Foundation

struct MyError: ErrorType, CustomStringConvertible {
	let description: String
}

func parseArguments (args: [String] = Process.arguments) throws -> (name: String?, path: NSURL?, showversion: Bool) {
	let cli = CommandLine(arguments: args)

	let filePathOption = StringOption(shortFlag: "p", longFlag: "file_path", required: false,
		helpMessage: "Load HTML to be rendered from the specified file. Use stdin if this option is not used.")
	let versionOption = BoolOption(shortFlag: "v", longFlag: "version",
		helpMessage: "Print version and load an HTML page that displays the current version of the app.")
	let nameOption = StringOption(shortFlag: "n", longFlag: "name", required: false,
		helpMessage: "The name that should be displayed in the sidebar.")
	cli.addOptions(filePathOption, versionOption, nameOption)

	do {
		try cli.parse(true)
	} catch {
		var errormessage = ""
		cli.printUsage(error, to: &errormessage)
		throw MyError(description: errormessage)
	}

	guard !versionOption.value else { return (nil,nil,true) }
	let path = filePathOption.value.map(NSURL.init)
	let name = nameOption.value ?? path?.lastPathComponent ?? " .html"
	return (name, path, false)
}

func verifyOrCreateFile(name: String, _ maybepath: NSURL?, contents: ReadableStream) throws -> NSURL {
	if let path = maybepath {
		try makeThrowable(path.checkResourceIsReachableAndReturnError)
		return path
	} else {
		let newpath = main.tempdirectory + name
		var cache = try open(forWriting: newpath)
		contents.writeTo(&cache)
		return NSURL(fileURLWithPath: newpath)
	}
}

func getVersionNumbers () -> (version: String, build: String) {
	let info = NSBundle.mainBundle().infoDictionary!
	return (info["CFBundleShortVersionString"] as! String, info["CFBundleVersion"] as! String)
}

do {
	let (name, maybepath, showversion) = try parseArguments()

	guard !showversion else {
		let numbers = getVersionNumbers()
		print(numbers.version, "(" + numbers.build + ")")
		exit(0)
	}

	let path = try verifyOrCreateFile(name!, maybepath, contents: main.stdin)

	try runAndPrint("open", "-b", "com.corporaterunaways.Fenestro", path.path!)
} catch {
	exit(error)
}
