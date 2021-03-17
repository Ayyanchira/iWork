//
//  TaskListViewController.swift
//  iWork
//
//  Created by Akshay Ayyanchira on 3/15/21.
//

import Cocoa

class TaskListViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {
    
//    var taskList = ["Task 1", "Task 2", "Task 3"]
//    var taskDescriptionList = ["Task 1 is great", "Task 2 is not so great", "Task 3 is the best of all"]
    var taskList:[Task] = [Task]()
    var taskManager = TaskManager()
    
    @IBOutlet weak var taskListTableView: NSTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        taskListTableView.delegate = self
        taskListTableView.dataSource = self
        taskList = TaskManager.getAllTasks() ?? [Task]()
        addNewTasks()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshTaskList), name: NSNotification.Name(rawValue: "load"), object: nil)
    }
    
    func addNewTasks() {
        taskList.append(TaskManager.addTask(name: "Release Android 3.3.0", description: "Release Android SDK on maven central"))
        taskList.append(TaskManager.addTask(name: "Have a architecture ready", description: "InApp Animation flow diagram"))
        taskList.append(TaskManager.addTask(name: "Migrate to Kube", description: "Write a slab doc for Kube migration"))
        taskList.append(TaskManager.addTask(name: "Make Coffee", description: nil))
        taskList.append(TaskManager.addTask(name: "Create JIRA APIs", description: "Use postman to create hit JIRA endpoints to see if it gives back required data"))
    }

    @objc func refreshTaskList(notification: NSNotification) {
        DispatchQueue.main.async {
            self.taskList = TaskManager.getAllTasks() ?? [Task]()
            self.taskListTableView.reloadData()
        }
    }
    
    //MARK: Quit button
    @IBOutlet weak var quitButton: NSButton!
    @IBAction func quitButtonPressed(_ sender: NSButton) {
        NSApplication.shared.terminate(self)
    }
    
    //MARK:  Add task button
    
    @IBAction func addTaskButtonPressed(_ sender: NSButtonCell) {
        
    }
    
    //MARK: Table view delegate methods
    func numberOfRows(in tableView: NSTableView) -> Int {
        return taskList.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let taskCell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "customTaskCell"), owner: self) as? TaskListCellView else { return nil }
        taskCell.taskTitleLabel.stringValue = taskList[row].name
        taskCell.decriptionLabel.stringValue = taskList[row].description
        return taskCell
    }
}

//MARK:- Extensions

extension TaskListViewController {
  static func initiateViewController() -> TaskListViewController {
    let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
    let identifier = NSStoryboard.SceneIdentifier("TaskListViewController")
    guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? TaskListViewController else {
      fatalError("Why cant i find TaskListViewController? - Check Main.storyboard")
    }
    return viewcontroller
  }
}
