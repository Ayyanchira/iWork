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
//    var taskManager = TaskManager()
    
    @IBOutlet weak var taskListTableView: NSTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        //Load from disk
        taskListTableView.delegate = self
        taskListTableView.dataSource = self
        taskList = TaskManager.getAllTasks() ?? [Task]()
        addNewTasks()
        
        //Adding observer for add new task
        NotificationCenter.default.addObserver(self, selector: #selector(onNotifyLoad), name: NSNotification.Name(rawValue: "load"), object: nil)
    }
    
    func addNewTasks() {
        taskList.append(TaskManager.addTask(name: "Release Android 3.3.0", description: "Release Android SDK on maven central"))
        taskList.append(TaskManager.addTask(name: "Have a architecture ready", description: "InApp Animation flow diagram"))
        taskList.append(TaskManager.addTask(name: "Migrate to Kube", description: "Write a slab doc for Kube migration"))
        taskList.append(TaskManager.addTask(name: "Make Coffee", description: nil))
        taskList.append(TaskManager.addTask(name: "Create JIRA APIs", description: "Use postman to create hit JIRA endpoints to see if it gives back required data"))
    }

    fileprivate func refreshTaskList() {
        DispatchQueue.main.async {
            self.taskList = TaskManager.getAllTasks() ?? [Task]()
            self.taskListTableView.reloadData()
        }
    }
    
    @objc func onNotifyLoad(notification: NSNotification) {
        if notification.name.rawValue == "load" {
            refreshTaskList()
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
//        print("refreshing the table. Getting count \(taskList.count)")
        return taskList.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let taskCell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "customTaskCell"), owner: self) as? TaskListCellView else { return nil }
        taskCell.taskTitleLabel.stringValue = taskList[row].name
        taskCell.decriptionLabel.stringValue = taskList[row].taskDescription
        taskCell.timerLabel.stringValue = TimeUtil.timeString(time: TimeInterval(taskList[row].elapsedTime))
        taskCell.taskId = taskList[row].id
        return taskCell
    }
    
    func tableView(_ tableView: NSTableView, rowActionsForRow row: Int, edge: NSTableView.RowActionEdge) -> [NSTableViewRowAction] {
        let markAsCompleteAction = NSTableViewRowAction(style: .regular, title: "Complete") { (rowAction, id) in
            
            print("mark as completed tapped")
            print("rowAction is \(rowAction) id is\(id)")
            if let task = TaskManager.getTask(id: self.taskList[row].id){
                TaskManager.markAsComplete(id: task.id)
            }
        }
        markAsCompleteAction.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        
        let deleteAction = NSTableViewRowAction(style: .destructive, title: "Delete") { (rowAction, id) in
            print("Delete tapped")
//            tableView.removeRows(at: [row], withAnimation: .effectFade)
//            TaskManager.deleteTask(id: self.taskList[row].id)
//            self.refreshTaskList()print
            print("posting notification to delete task with rawValue taskDelete\(self.taskList[row].id)")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "TASK_DELETE"), object: self.taskList[row].id)
        }
        
        return [markAsCompleteAction, deleteAction]
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        print("cell tapped")
        print("selected row is \(taskListTableView.selectedRow)")
        performSegue(withIdentifier: "showDetails", sender: taskListTableView)
        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: NSStoryboardSegue.Identifier, sender: Any?) -> Bool {
        if identifier == "NewTask" {
            return true
        }
        if identifier == "showDetails" {
            if taskListTableView.selectedRow < 0 || taskListTableView.selectedRow > taskList.count - 1 {
                return false
            } else {
                return true
            }
        }
        return false
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if taskListTableView.selectedRow < 0 || taskListTableView.selectedRow > taskList.count - 1 {
            return
        }
        let selectedTask = taskList[taskListTableView.selectedRow]
        let vc = segue.destinationController as? EditTaskViewController
        vc?.taskId = selectedTask.id
    }
    
    override func viewDidDisappear() {
        //save to disk
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
