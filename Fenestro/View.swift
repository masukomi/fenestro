//
//  View.swift
//  Fenestro
//
//  Created by Kåre Morstøl on 21.10.15.
//  Copyright © 2015 Corporate Runaways, LLC. All rights reserved.
//

import Cocoa

extension NSView {

	/** Add subview and let it fill this entire view */
	func addSubViewToTheBrim (subview: NSView) {
		subview.translatesAutoresizingMaskIntoConstraints = false
		addSubview(subview)
        self.addConstraints(visualformat: "V:|-0-[subview]-0-|", views: ["subview": subview])
        self.addConstraints(visualformat: "H:|-0-[subview]-0-|", views: ["subview": subview])
	}

	/** Add constraints in visual format language with no options and no metrics */
	func addConstraints (visualformat: String, views: [String:AnyObject]) -> [NSLayoutConstraint] {
        let constraints = NSLayoutConstraint.constraints(withVisualFormat: visualformat,
                                                         options: [],
                                                         metrics: nil,
                                                         views: views)
		self.addConstraints(constraints)
		return constraints
	}
}
