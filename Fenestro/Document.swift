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
		self.showFile(path)
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
			filelist = ListController(name: self.name, path: self.path)
			filelist!.selectionHandler = showFile
			splitview.addSubview(filelist!.view, positioned: .Below, relativeTo: nil)
			filelist?.view.setFrameSize(NSSize(width: 200, height: Int.max))
		}
		filelist?.addFile(name: name, path: path)
	}
}
