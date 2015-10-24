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

	func applicationWillFinishLaunching(notification: NSNotification) {
		// make our subclass the sharedDocumentController
		let _ = DocumentController()
	}

	func applicationDidFinishLaunching(aNotification: NSNotification) {

	}

	func applicationWillTerminate(aNotification: NSNotification) {

	}
}

class DocumentController: NSDocumentController  {

	var timeoflastopening = NSDate.distantPast()

	override func openDocumentWithContentsOfURL (url: NSURL, display displayDocument: Bool,
		completionHandler: (NSDocument?, Bool, NSError?) -> Void) {

			if NSDate().timeIntervalSinceDate(timeoflastopening) < 0.5,	let document = self.documents.last as? Document {
				document.addFile(name: url.lastPathComponent ?? "", path: url)
			} else {
				super.openDocumentWithContentsOfURL(url, display: displayDocument, completionHandler: completionHandler)
			}
			timeoflastopening = NSDate()
	}
}
