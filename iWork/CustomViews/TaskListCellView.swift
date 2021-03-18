//
//  TaskListCelLView.swift
//  iWork
//
//  Created by Akshay Ayyanchira on 3/15/21.
//

import Cocoa

class TaskListCellView: NSTableCellView {
    
    
    @IBOutlet weak var startStopButton: NSButton!
    @IBOutlet weak var timerLabel: NSTextField!
    @IBOutlet weak var taskTitleLabel: NSTextField!
    @IBOutlet weak var decriptionLabel: NSTextField!
    
    @IBOutlet weak var seperatorView: NSView!
    
    var taskId:String?
    var seconds:Int {
        return TaskManager.getTask(id: taskId!)?.elapsedTime ?? 0
    } //This variable will hold a starting value of seconds. It could be any amount above 0.
    var timer = Timer()
    var isTimerRunning = false //This will be used to make sure only one timer is created at a time.
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        if let task = TaskManager.getTask(id: taskId!) {
            
            print("--------\ndraw for cell for task -\(task.name) called")
        } else {
            print("--------\nDraw for unknown called")
        }
        
        updateTaskStatus()
        updateUIElements()
        NotificationCenter.default.addObserver(self, selector: #selector(updateUIElements), name: NSNotification.Name(rawValue: "taskUpdate\(taskId!)"), object: nil)
        NotificationCenter.default.addObserver(forName: NSNotification.Name.init("TASK_DELETE"), object: nil, queue: nil) { (notification) in
            if let taskIdToDelete = notification.object {
                self.onDeleteNotified(id: taskIdToDelete as! String)
            }
        }
    }
    
    @IBAction func startStopButtonPressed(_ sender: Any) {
        toggleTimer()
        updateTaskStatus()
        updateUIElements()
    }
    
    func updateTaskStatus() {
        print("updating task -\(taskId!).")
        guard let task = TaskManager.getTask(id: taskId!) else {
            return
        }
        print("Before - status - \(task.status)")
        if task.status == .COMPLETE {
            timer.invalidate()
            updateUIElements()
            TaskManager.updateTask(task: task)
            return
        }
        if(!isTimerRunning) {
            print("is timer running? - \(isTimerRunning)")
            if (task.elapsedTime == 0) {
                print("is seconds zero? - \(seconds == 0)")
                //Not started yet
                task.status = .NEW
                print("thus task \(task.name) - is New")
            } else {
                print("seconds is - \(seconds)")
                //Paused
//                print("status is been set to paused")
                task.status = .PAUSED
                print("thus task \(task.name) - is Paused")
            }
        } else {
            print("Timer is running")
            //Running
            task.status = .IN_PROGRESS
            print("thus task \(task.name) - is is progress")
        }
        TaskManager.updateTask(task: task)
    }
    
    @objc func updateUIElements() {
        guard let task = TaskManager.getTask(id: taskId!) else {
            return
        }
        switch task.status {
        case .NEW:
            seperatorView.layer?.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            startStopButton.title = "Start"
        case .IN_PROGRESS:
            seperatorView.layer?.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            startStopButton.title = "Pause"
        case .PAUSED:
            seperatorView.layer?.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            startStopButton.title = "Resume"
        case.COMPLETE:
            seperatorView.layer?.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            startStopButton.title = ""
            startStopButton.isEnabled = false
        }
    }
    
    @objc func onDeleteNotified(id: String) {
        if TaskManager.getTask(id: id) != nil {
            isTimerRunning = false
            timer.invalidate()
            TaskManager.deleteTask(id: id)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
            NotificationCenter.default.removeObserver(self)
        }
    }
    
    //MARK:- Task Time Management
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(TaskListCellView.updateTimer)), userInfo: nil, repeats: true)
    }
    
    fileprivate func toggleTimer() {
        if isTimerRunning == false {
            if let task = TaskManager.getTask(id: taskId!) {
                print("timer running for task - \(task.name)")
            }
            isTimerRunning = true
            runTimer()
        } else {
            isTimerRunning = false
            timer.invalidate()
        }
    }
    
    @objc func updateTimer() {
        
        if (TaskManager.getTask(id: taskId!)?.status == TaskStatus.IN_PROGRESS) {
              //This will increment the seconds.
            
            
            //Commit to local
            if taskId != nil {
                if (TaskManager.getTask(id: taskId!) == nil) {
                    print("Task already deleted")
                }
                TaskManager.setElapsedTimeForTask(id: taskId!, to: seconds + 1)
            }
            timerLabel.stringValue = TimeUtil.timeString(time: TimeInterval(seconds))
        }
        
//        updateTaskStatus()
    }
    
    
}
