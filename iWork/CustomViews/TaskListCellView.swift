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
    var seconds = 0 //This variable will hold a starting value of seconds. It could be any amount above 0.
    var timer = Timer()
    var isTimerRunning = false //This will be used to make sure only one timer is created at a time.
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        updateUIElements()
        NotificationCenter.default.addObserver(self, selector: #selector(updateUIElements), name: NSNotification.Name(rawValue: "taskUpdate\(taskId!)"), object: nil)
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
    
    @IBAction func startStopButtonPressed(_ sender: Any) {
        toggleTimer()
        updateTaskStatus()
        updateUIElements()
    }
    
    func updateTaskStatus() {
        guard let task = TaskManager.getTask(id: taskId!) else {
            return
        }
        
        if task.status == .COMPLETE {
            timer.invalidate()
            updateUIElements()
            TaskManager.updateTask(task: task)
            return
        }
        
        if(!isTimerRunning) {
            if (seconds == 0) {
                //Not started yet
                task.status = .NEW
            } else {
                //Paused
                task.status = .PAUSED
            }
        } else {
            //Running
            task.status = .IN_PROGRESS
        }
        TaskManager.updateTask(task: task)
    }
    
    deinit {
        print("Invalidating the timer")
        timer.invalidate()
    }
    
//    @objc func deleteTask() {
//        isTimerRunning = false
//        timer.invalidate()
//        TaskManager.deleteTask(id: taskId!)
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
//        NotificationCenter.default.removeObserver(self)
//    }
    
    //MARK:- Task Time Management
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(TaskListCellView.updateTimer)), userInfo: nil, repeats: true)
    }
    
    fileprivate func toggleTimer() {
        if isTimerRunning == false {
            isTimerRunning = true
            runTimer()
        } else {
            isTimerRunning = false
            timer.invalidate()
        }
    }
    
    @objc func updateTimer() {
        
        seconds += 1     //This will increment the seconds.
        timerLabel.stringValue = timeString(time: TimeInterval(seconds))
        
        //Commit to local
        if taskId != nil {
            if (TaskManager.getTask(id: taskId!) == nil) {
                print("Task already deleted")
            }
            TaskManager.setElapsedTimeForTask(id: taskId!, to: seconds)
        }
//        updateTaskStatus()
    }
    
    func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format: "%02i:%02i:%02i", hours, minutes, seconds)
    }
}
