//
//  AppDelegate.swift
//  Fenestro
//
//  Created by Kåre Morstøl on 21.10.15.
//  Copyright © 2015 Corporate Runaways, LLC. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	func applicationDidFinishLaunching(aNotification: NSNotification) {
		let wincontroller = NSDocumentController.sharedDocumentController()
		if wincontroller.documents.isEmpty {
			// guaranteed to never throw – see Document.init(type typeName: String)
			try! wincontroller.openUntitledDocumentAndDisplay(true)
		}
	}

	func applicationWillTerminate(aNotification: NSNotification) {

	}

	/*
	func applicationShouldOpenUntitledFile(sender: NSApplication) -> Bool {
	return true
	}
	*/
}

