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

	}

	func applicationWillTerminate(aNotification: NSNotification) {

	}

	func application(sender: NSApplication, openFile filename: String) -> Bool {
		let wincontroller = NSDocumentController.sharedDocumentController()
		wincontroller.openDocumentWithContentsOfURL(NSURL(fileURLWithPath: filename), display: true) { _ in }

		return true
	}
}
