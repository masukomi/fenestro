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

	/** The current location of the command line application, or nil if it was not found. */
	var cliAppDirectory: NSURL? {
		let path = NSUserDefaults.standardUserDefaults().URLForKey("CliAppPath")
		return path.flatMap {
			$0.URLByAppendingPathComponent("fenestro").checkResourceIsReachableAndReturnError(nil) ? $0 : nil
		}
	}

	/** Install the bundled command line application to this directory. */
	func installCliApp (directory: NSURL) throws {
		let frompath = NSBundle.mainBundle().URLForResource("fenestro", withExtension: "")!
		let topath = directory.URLByAppendingPathComponent("fenestro")
		try NSFileManager.defaultManager().copyItemAtURL(frompath, toURL: topath)
		NSUserDefaults.standardUserDefaults().setURL(directory, forKey: "CliAppPath")
	}

	func showError (error: ErrorType) {
		NSAlert(error: error as NSError).runModal()
	}

	func applicationWillFinishLaunching(notification: NSNotification) {

		// Make our subclass the sharedDocumentController.
		let _ = DocumentController()

		// If commandline application cannot be found, install it.
		if self.cliAppDirectory == nil {
			let panel = NSOpenPanel()
			panel.canChooseDirectories = true
			panel.canChooseFiles = false
			panel.allowsMultipleSelection = false
			panel.prompt = "Select"
			panel.showsHiddenFiles = true
			panel.title = "Install commandline application"
			panel.message = "Select the location for the commandline application. It should be a directory listed in the PATH environment variable for easy access."
			panel.directoryURL = NSURL(fileURLWithPath: "/usr/local/bin")
			if panel.runModal() == NSFileHandlingPanelOKButton {
				do {
					try installCliApp(panel.URLs.first!)
				} catch {
					showError(error)
				}
			}
		}
	}
}

class DocumentController: NSDocumentController  {

	var timeoflastopening = NSDate.distantPast()
	var maxTimeWithoutNewWindow = 1.0;
	/*
	If they're just opening one file we don't need to be showing a sidebar.
	If they're throwing lots of files at us quickly, then sidebar.
	*/

	override func openDocumentWithContentsOfURL (var url: NSURL, display displayDocument: Bool,
		completionHandler: (NSDocument?, Bool, NSError?) -> Void) {

			if url.lastPathComponent == ".fenestroreadme" {
				url = Document.defaultpath
			}


			if url.lastPathComponent != " .html" &&
				NSDate().timeIntervalSinceDate(timeoflastopening) < maxTimeWithoutNewWindow,
				let document = self.documents.last as? Document {

					document.addFile(name: url.lastPathComponent ?? "", path: url)
					completionHandler(document, true, nil)
			} else {
				super.openDocumentWithContentsOfURL(url, display: displayDocument, completionHandler: completionHandler)
			}
			timeoflastopening = url.lastPathComponent == " .html" ? NSDate.distantPast() : NSDate()
	}

	/** Prevent recent documents from being displayed in the dock icon menu. */
	override func noteNewRecentDocument(document: NSDocument) {	}
}
