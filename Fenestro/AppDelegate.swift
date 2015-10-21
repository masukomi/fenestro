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
		// Insert code here to initialize your application
		let wincontroller = NSDocumentController.sharedDocumentController()
		if wincontroller.documents.isEmpty {
			do {
				try NSDocumentController.sharedDocumentController().openUntitledDocumentAndDisplay(true)
			} catch {
				print(error)
			}
		}
	}

	func applicationWillTerminate(aNotification: NSNotification) {
		// Insert code here to tear down your application
	}

	/*
	func applicationShouldOpenUntitledFile(sender: NSApplication) -> Bool {
	return true
	}
	*/
}

