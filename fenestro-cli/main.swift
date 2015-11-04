//
//  main.swift
//  fenestro-cli
//
//  Created by Kåre Morstøl on 26.10.15.
//  Copyright © 2015 Corporate Runaways, LLC. All rights reserved.
//

import Foundation


func parseArguments (arguments: [String]? = nil) throws -> (name: String, path: NSURL?, showversion: Bool) {
	let parser = ArgumentParser()
	let filePathOption = parser.add(StringArgument(short: "p", long: "path",
		helptext: "Load HTML to be rendered from the specified file. Use stdin if this option is not used."))
	let versionOption = parser.add(BoolArgument(short: "v", long: "version",
		helptext: "Print version and load an HTML page that displays the current version of the app."))
	let nameOption = parser.add(StringArgument(short: "n", long: "name",
		helptext: "The name that should be displayed in the sidebar."))

	if let arguments = arguments {
		try parser.parse(arguments, strict: true)
	} else {
		try parser.parse(strict: true)
	}

	guard !versionOption.value else { return ("",nil,true) }
	let path = filePathOption.value.map(NSURL.init)
	let name = nameOption.value ?? path?.lastPathComponent ?? " .html"
	return (name, path, false)
}

func verifyOrCreateFile(name: String, _ maybepath: NSURL?, contents: ReadableStream) throws -> NSURL {
	if let path = maybepath {
		let newpath = NSURL(fileURLWithPath: main.tempdirectory + name)
		try Files.copyItemAtURL(path, toURL: newpath)
		return newpath
	} else {
		guard !contents.isTerminal() else {
			let newpath = main.tempdirectory + ".fenestroreadme"
			Files.createFileAtPath(newpath, contents: nil, attributes: nil)
			return NSURL(fileURLWithPath: newpath)
		}
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

func printVersionsAndOpenPage () throws {
	let numbers = getVersionNumbers()
	let numbersstring = numbers.version + " (" + numbers.build + ")"
	print(numbersstring)

	let versionpath = main.tempdirectory + "fenestro-version.html"
	let versionfile = try open(forWriting: versionpath)
	versionfile.writeln("<html><body>Fenestro version " + numbersstring + "</body></html>")
	versionfile.close()
	try runAndPrint("open", "-b", "com.corporaterunaways.Fenestro", versionpath)
}

extension ReadableStream {
	func isTerminal () -> Bool {
		return run(bash: "test -t \(filehandle.fileDescriptor) && echo true") == "true"
	}
}


do {
	let (name, maybepath, showversion) = try parseArguments()

	guard !showversion else {
		try printVersionsAndOpenPage()
		exit(0)
	}

	let path = try verifyOrCreateFile(name, maybepath, contents: main.stdin)

	try runAndPrint("open", "-b", "com.corporaterunaways.Fenestro", path.path!)
} catch {
	main.stderror.writeln(error)
	exit(EX_USAGE)
}
