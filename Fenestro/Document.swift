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

    override class func canConcurrentlyReadDocuments(ofType typeName: String) -> Bool {
		return false
	}

    static let defaultpath = Bundle.main.url(forResource: "README", withExtension: "html")!

	@IBOutlet weak var webview: WebView!
	@IBOutlet weak var splitview: NSSplitView!
	var filelist: ListController?

	var name: String!
	var path: URL!

	override init() {
		super.init()
	}

	/** Called when creating an empty document. */
	convenience init(type typeName: String) throws {
		self.init()

		self.name = "README"
		self.path = Document.defaultpath
	}

    override func windowControllerDidLoadNib(_ windowController: NSWindowController) {
		super.windowControllerDidLoadNib(windowController)
		// Add any code here that needs to be executed once the windowController has loaded the document's window.

		webview.preferences.setValue(true, forKey: "developerExtrasEnabled")

		if let window = windowController.window {
			var windowframe = window.frame
            windowframe.size = NSSizeFromString(UserDefaults.standard.string(forKey: "WindowSize") ?? "600,800")
			window.setFrame(windowframe, display: true)

			// Put the first window in the top left corner of the screen, and let the rest cascade from there.
            window.cascadeTopLeft(from: NSPoint(x: 20, y: 20))
		}
        self.showFile(name: name, path: path)
	}

    override func shouldCloseWindowController(_ windowController: NSWindowController, 
                                              delegate: Any?,
                                              shouldClose shouldCloseSelector: Selector?,
                                              contextInfo: UnsafeMutableRawPointer?) {

	/* OLD
     override func shouldCloseWindowController(windowController: NSWindowController,
                                              delegate: AnyObject?,
                                              shouldCloseSelector: Selector,
                                              contextInfo: UnsafeMutablePointer<Void>
    ) {*/
        super.shouldCloseWindowController(windowController, delegate: delegate, shouldClose: shouldCloseSelector, contextInfo: contextInfo)

		if let window = windowController.window {
			let sizestring = NSStringFromSize(window.frame.size)
            UserDefaults.standard.set(sizestring, forKey: "WindowSize")
		}
	}

	override var windowNibName: String? {
		// Returns the nib file name of the document
		return "Document"
	}

    override func read(from url: URL, ofType typeName: String) throws {
		path = url
        name = url.lastPathComponent
	}

	/** Display text in file at `path` as html. */
	func showFile (name: String, path: URL) {
		do {
			//guard let pathstr = path.path else { throw ErrorString("Could not open file at '\(path)'.") }
            let pathstr = path.path
			webview.mainFrame.loadHTMLString(try String(contentsOfFile: pathstr), baseURL: path)
            self.displayName = name
			self.windowControllers.first?.window?.title = name
		} catch {
			let errorstring = "<html><body>\(error)</body></html>"
			webview.mainFrame.loadHTMLString(errorstring, baseURL: path)
		}
	}

    func addFile(name: String, path: URL) {
		if filelist == nil {
			let newfilelist = ListController(name: self.name, path: self.path)
			newfilelist.selectionHandler = showFile
            splitview.addSubview(newfilelist.view, positioned: NSWindow.OrderingMode.below, relativeTo: nil)

			filelist = newfilelist
		}
		filelist?.addFile(name: name, path: path)
	}

    override func printOperation(withSettings printSettings: [NSPrintInfo.AttributeKey : Any]) throws -> NSPrintOperation {
        return webview.mainFrame.frameView.printOperation(with: NSPrintInfo(dictionary: printSettings))
	}
}

typealias ErrorString = String

extension ErrorString: Error { }
