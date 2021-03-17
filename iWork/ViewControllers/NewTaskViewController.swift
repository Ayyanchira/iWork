//
//  NewTaskViewController.swift
//  iWork
//
//  Created by Akshay Ayyanchira on 3/16/21.
//

import Cocoa

class NewTaskViewController: NSViewController {
    
    @IBOutlet weak var taskTitleTextField: NSTextField!
    
    @IBOutlet var descriptionTextView: NSTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }

    @IBAction func addButtonPressed(_ sender: NSButton) {
        let taskTitle = taskTitleTextField.stringValue
        let taskDescription = descriptionTextView.textStorage?.string
        if(taskTitle.count >= 2) {
            TaskManager.addTask(name: taskTitle, description: taskDescription)
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
        dismiss(self)
    }
}
