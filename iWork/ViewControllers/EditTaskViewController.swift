//
//  EditTaskViewController.swift
//  iWork
//
//  Created by Akshay Ayyanchira on 3/16/21.
//

import Cocoa

class EditTaskViewController: NSViewController {

    //MARK: Variable and Outlets
    @IBOutlet weak var taskTitleTextField: NSTextField!
    @IBOutlet var taskDescriptionTextField: NSTextView!
    @IBOutlet weak var saveButton: NSButton!
    @IBOutlet weak var markAsCompleteButton: NSButton!
    @IBOutlet weak var deleteButton: NSButton!
    
    var taskId: String?
    var task: Task?
    //MARK: Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        
        guard let task = TaskManager.getTask(id: taskId!) else {
            dismiss(nil)
            return
        }
        self.task = task
        taskTitleTextField.stringValue = task.name
        taskDescriptionTextField.string = task.taskDescription
    }
    
    //MARK: Logic
    
    
    
    //MARK: IBActions
    @IBAction func deleteButtonPressed(_ sender: NSButton) {
        
    }
    
    @IBAction func markAsCompleteButtonPressed(_ sender: NSButton) {
        
    }
    
    @IBAction func saveButtonPressed(_ sender: NSButton) {
        task?.name = taskTitleTextField.stringValue
        task?.taskDescription = taskDescriptionTextField.string
        TaskManager.updateTask(task: task!)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
        dismiss(self)
    }
}
