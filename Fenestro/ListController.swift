//
//  ListView.swift
//  Fenestro
//
//  Created by Kåre Morstøl on 22.10.15.
//  Copyright © 2015 Corporate Runaways, LLC. All rights reserved.
//

import Cocoa

class ListController: NSViewController {

	private var list: [(name: String, path: NSURL)]
	let tableview = NSTableView()
	var selectionHandler: ((NSURL) -> Void)?

	init (name: String, path: NSURL) {
		list = [(name, path)]
		super.init(nibName: nil, bundle: nil)!
		self.setupView()
	}

	private func setupView() {
		let scroll = NSScrollView(frame: NSRect(x: 0, y: 0, width: 200, height: 0))
		scroll.focusRingType = .None

		tableview.focusRingType = .None
		let column = NSTableColumn(identifier: "Name")
		tableview.addTableColumn(column)
		tableview.setDataSource(self)
		tableview.setDelegate(self)
		tableview.setContentHuggingPriority(NSLayoutPriorityDefaultLow, forOrientation: .Vertical)
		tableview.setContentHuggingPriority(NSLayoutPriorityDefaultLow, forOrientation: .Horizontal)

		scroll.addSubViewToTheBrim(tableview)
		self.view = scroll
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func addFile(name name: String, path: NSURL) {
		let index = list.insertionIndexOf((name, path)) { a, b in a.name < b.name }
		tableview.beginUpdates()
		list.insert((name, path), atIndex: index)
		tableview.insertRowsAtIndexes( NSIndexSet(index: index), withAnimation: .SlideLeft)
		tableview.endUpdates()
	}
}

extension ListController: NSTableViewDataSource, NSTableViewDelegate {
	func numberOfRowsInTableView(tableView: NSTableView) -> Int {
		return list.count
	}

	func tableView(tableView: NSTableView, objectValueForTableColumn tableColumn: NSTableColumn?, row: Int) -> AnyObject? {
		return list[row].name
	}

	func tableViewSelectionDidChange(notification: NSNotification) {
		let path = list[tableview.selectedRow].path
		selectionHandler?(path)
	}
}

extension Array {

	// http://stackoverflow.com/a/26679191/96587
	/**
	The index this element will get if inserted into the array, and the array is sorted by 'isOrderedBefore'.
	It returns either (any) index of the element if the element is already present in the array,
	or the index where it can be inserted while preserving the order.
	*/
	func insertionIndexOf(elem: Element, isOrderedBefore: (Element, Element) -> Bool) -> Int {
		var lo = 0
		var hi = self.count - 1
		while lo <= hi {
			let mid = (lo + hi)/2
			if isOrderedBefore(self[mid], elem) {
				lo = mid + 1
			} else if isOrderedBefore(elem, self[mid]) {
				hi = mid - 1
			} else {
				return mid // found at position mid
			}
		}
		return lo // not found, would be inserted at position lo
	}
}
