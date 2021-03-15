//
//  TaskListViewController.swift
//  iWork
//
//  Created by Akshay Ayyanchira on 3/15/21.
//

import Cocoa

class TaskListViewController: NSViewController {
    
    @objc dynamic var taskList = ["Task 1", "Task 2", "Task 3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    //MARK:- Quit button
    @IBOutlet weak var quitButton: NSButton!
    @IBAction func quitButtonPressed(_ sender: NSButton) {
        NSApplication.shared.terminate(self)
    }
    
    //MARK:-  Add task button
    
    @IBAction func addTaskButtonPressed(_ sender: NSButtonCell) {
        
    }
}

extension TaskListViewController {
  // MARK: Storyboard instantiation
  static func freshController() -> TaskListViewController {
    //1.
    let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
    //2.
    let identifier = NSStoryboard.SceneIdentifier("TaskListViewController")
    //3.
    guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? TaskListViewController else {
      fatalError("Why cant i find TaskListViewController? - Check Main.storyboard")
    }
    return viewcontroller
  }
}
