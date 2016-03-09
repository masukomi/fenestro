//
//  FindPanel.swift
//  Fenestro
//
//  Created by Kåre Morstøl on 08.03.2016.
//  Copyright © 2016 Corporate Runaways. All rights reserved.
//

import Cocoa

class FindPanel: NSViewController {
	@IBOutlet weak var searchField: NSTextField!

	var searchHandler: ((String) -> Void)?

/*
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
*/


	override func controlTextDidChange(obj: NSNotification) {
		searchHandler?(searchField.stringValue)
		//view.window?.makeFirstResponder(searchField)
	}

	override func controlTextDidEndEditing(obj: NSNotification) {
	}
	
}
