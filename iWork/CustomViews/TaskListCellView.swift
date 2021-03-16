//
//  TaskListCelLView.swift
//  iWork
//
//  Created by Akshay Ayyanchira on 3/15/21.
//

import Cocoa

class TaskListCellView: NSTableCellView {

    
    @IBOutlet weak var taskTitleLabel: NSTextField!
    @IBOutlet weak var decriptionLabel: NSTextField!
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        // Drawing code here.
    }
    
    @IBAction func detailsButtonPressed(_ sender: Any) {
        
    }
    
}
