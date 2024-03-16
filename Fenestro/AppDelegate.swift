//
//  AppDelegate.swift
//  Fenestro
//
//  Created by Kåre Morstøl on 21.10.15.
//  Copyright © 2015 Corporate Runaways, LLC. All rights reserved.
//

import Cocoa
import UniformTypeIdentifiers
//import Foundation // maybe?

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	/** The current location of the command line application, or nil if it was not found. */
	var cliAppDirectory: URL? {
        let path = UserDefaults.standard.url(forKey: "CliAppPath")
		/*return path.flatMap {
			//$0.URLByAppendingPathComponent("fenestro").checkResourceIsReachableAndReturnError(nil) ? $0 : nil
            $0.appendPathComponent("fenestro")
		}*/
        
        //TODO: check if resource is reachable
        return path?.appendingPathComponent("fenestro", conformingTo: UTType.item)
	}

	/** Install the bundled command line application to this directory. */
	func installCliApp (directory: URL) throws {
        let frompath = Bundle.main.url(forResource: "fenestro", withExtension: "")!
		//let topath = directory.URLByAppendingPathComponent("fenestro")
        let topath = directory.appendingPathComponent("fenestro")
        try FileManager.default.copyItem(at: frompath, to: topath)
        UserDefaults.standard.set(directory, forKey: "CliAppPath")
	}

    
	func showError (error: Error) {
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
			panel.directoryURL = URL(fileURLWithPath: "/usr/local/bin")
            if panel.runModal().rawValue == NSApplication.ModalResponse.OK.rawValue {
				do {
                    try installCliApp(directory: panel.urls.first!)
				} catch {
                    showError(error: error)
				}
			}
		}
	}
}

class DocumentController: NSDocumentController  {

    var timeoflastopening = Date.distantPast
	var maxTimeWithoutNewWindow = 2.0;
	/*
	If they're just opening one file we don't need to be showing a sidebar.
	If they're throwing lots of files at us quickly, then sidebar.
	*/

    override func openDocument(withContentsOf url: URL,
                               display displayDocument: Bool,
                               completionHandler: @escaping (NSDocument?, Bool, (any Error)?) 
                               -> Void ){
        
    // OLD
	//override func openDocumentWithContentsOfURL (url: NSURL,
        // display displayDocument: Bool,
	    // completionHandler: (NSDocument?, Bool, NSError?) -> Void) {

        var url = url
        if url.lastPathComponent == ".fenestroreadme" {
            url = Document.defaultpath
        }

        let lastOpenWasRecent = Date().timeIntervalSince(timeoflastopening) < maxTimeWithoutNewWindow

        if url.lastPathComponent != " .html" &&
            lastOpenWasRecent,
            let document = self.documents.last as? Document {

            document.addFile(name: url.lastPathComponent, path: url)
            completionHandler(document, true, nil)
        } else {
            super.openDocument(withContentsOf: url, display: displayDocument, completionHandler: completionHandler)
        }
        timeoflastopening = url.lastPathComponent == " .html" ? Date.distantPast : Date()

	}

	/** Prevent recent documents from being displayed in the dock icon menu. */
    override func noteNewRecentDocument(_ document: NSDocument) {	}
}
