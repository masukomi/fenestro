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

	init (name: String, path: NSURL) {
		list = [(name, path)]
		super.init(nibName: nil, bundle: nil)!
		self.setupView()
	}

	private func setupView() {
		let scroll = NSScrollView()

		let column = NSTableColumn(identifier: "Name")
		tableview.addTableColumn(column)
		tableview.setDataSource(self)
		tableview.setDelegate(self)

		scroll.addSubViewToTheBrim(tableview)
		self.view = scroll
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func addFile(name name: String, path: NSURL) {
		list.append((name, path))
		tableview.beginUpdates()
		tableview.insertRowsAtIndexes( NSIndexSet(index: list.count), withAnimation: .SlideUp)
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
}
