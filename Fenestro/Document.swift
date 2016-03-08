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

	override func windowControllerDidLoadNib(windowController: NSWindowController) {
		super.windowControllerDidLoadNib(windowController)
		// Add any code here that needs to be executed once the windowController has loaded the document's window.

		//webview.UIDelegate = self
		webview.preferences.setValue(true, forKey: "developerExtrasEnabled")

		if let window = windowController.window {
			var windowframe = window.frame
			windowframe.size = NSSizeFromString(NSUserDefaults.standardUserDefaults().stringForKey("WindowSize") ?? "600,800")
			window.setFrame(windowframe, display: true)

			// Put the first window in the top left corner of the screen, and let the rest cascade from there.
			window.cascadeTopLeftFromPoint(NSPoint(x: 20, y: 20))

			let findcontroller = FindPanel()
			window.contentView?.addSubview(findcontroller.view)
		}
		self.showFile(path)


	}

	override func shouldCloseWindowController(windowController: NSWindowController, delegate: AnyObject?, shouldCloseSelector: Selector, contextInfo: UnsafeMutablePointer<Void>) {
		super.shouldCloseWindowController(windowController, delegate: delegate, shouldCloseSelector: shouldCloseSelector, contextInfo: contextInfo)

		if let window = windowController.window {
			let sizestring = NSStringFromSize(window.frame.size)
			NSUserDefaults.standardUserDefaults().setObject(sizestring, forKey: "WindowSize")
		}
	}

	override var windowNibName: String? {
		// Returns the nib file name of the document
		return "Document"
	}

	override func readFromURL(url: NSURL, ofType typeName: String) throws {
		path = url
		name = url.lastPathComponent ?? ""
	}

	/** Display text in file at `path` as html. */
	func showFile (path: NSURL) {
		do {
			guard let pathstr = path.path else { throw ErrorString("Could not open file at '\(path)'.") }
			webview.mainFrame.loadHTMLString(try String(contentsOfFile: pathstr), baseURL: path)
		} catch {
			let errorstring = "<html><body>\(error)</body></html>"
			webview.mainFrame.loadHTMLString(errorstring, baseURL: path)
		}
	}

	func addFile(name name: String, path: NSURL) {
		if filelist == nil {
			let newfilelist = ListController(name: self.name, path: self.path)
			newfilelist.selectionHandler = showFile
			splitview.addSubview(newfilelist.view, positioned: .Below, relativeTo: nil)

			filelist = newfilelist
		}
		filelist?.addFile(name: name, path: path)
	}
}

typealias ErrorString = String

extension ErrorString: ErrorType { }
