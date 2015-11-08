//
//  Document.swift
//  Fenestro
//
//  Created by Kåre Morstøl on 21.10.15.
//  Copyright © 2015 Corporate Runaways, LLC. All rights reserved.
//

import Cocoa
import WebKit

class Document: NSDocument {

	override class func canConcurrentlyReadDocumentsOfType(typeName: String) -> Bool {
		return false
	}

	static let defaultpath = NSBundle.mainBundle().URLForResource("README", withExtension: "html")!

	@IBOutlet weak var webview: WebView!
	@IBOutlet weak var splitview: NSSplitView!
	var filelist: ListController?

	var name: String!
	var path: NSURL!

	override init() {
		super.init()
	}

	/** Called when creating an empty document. */
	convenience init(type typeName: String) throws {
		self.init()

		self.name = "README"
		self.path = Document.defaultpath
	}

	override func windowControllerDidLoadNib(aController: NSWindowController) {
		super.windowControllerDidLoadNib(aController)
		// Add any code here that needs to be executed once the windowController has loaded the document's window.

		var windowframe = self.splitview.window!.frame
		windowframe.size = NSSizeFromString(NSUserDefaults.standardUserDefaults().stringForKey("WindowSize") ?? "600,800")
		self.splitview.window!.setFrame(windowframe, display: true)

		self.showFile(path)

		// Put the first window in the top left corner of the screen, and let the rest cascade from there.
		self.splitview.window!.cascadeTopLeftFromPoint(NSPoint(x: 20, y: 20))
	}

	override func shouldCloseWindowController(windowController: NSWindowController, delegate: AnyObject?, shouldCloseSelector: Selector, contextInfo: UnsafeMutablePointer<Void>) {
		super.shouldCloseWindowController(windowController, delegate: delegate, shouldCloseSelector: shouldCloseSelector, contextInfo: contextInfo)

		let sizestring = NSStringFromSize(self.splitview.window!.frame.size)
		NSUserDefaults.standardUserDefaults().setObject(sizestring, forKey: "WindowSize")
	}

	override var windowNibName: String? {
		// Returns the nib file name of the document
		return "Document"
	}

	override func readFromURL(url: NSURL, ofType typeName: String) throws {
		path = url
		name = url.lastPathComponent ?? ""
	}

	func showFile (path: NSURL) {
		webview.mainFrame.loadRequest(NSURLRequest(URL: path))
	}

	func addFile(name name: String, path: NSURL) {
		if filelist == nil {
			let newfilelist = ListController(name: self.name, path: self.path)
			newfilelist.selectionHandler = showFile
			splitview.addSubview(newfilelist.view, positioned: .Below, relativeTo: nil)

			// Make sure the file list is visible. But don't do this on El Capitan, it has the exact opposite effect there.
			if Int32(rint(NSAppKitVersionNumber)) <= NSAppKitVersionNumber10_10_Max {
    			newfilelist.view.setFrameSize(NSSize(width: 200, height: Int.max))
			}

			filelist = newfilelist
		}
		filelist?.addFile(name: name, path: path)
	}
}
