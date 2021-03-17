//
//  TaskListCelLView.swift
//  iWork
//
//  Created by Akshay Ayyanchira on 3/15/21.
//

import Cocoa

class TaskListCellView: NSTableCellView {
    
    
    @IBOutlet weak var timerLabel: NSTextField!
    @IBOutlet weak var taskTitleLabel: NSTextField!
    @IBOutlet weak var decriptionLabel: NSTextField!
    var timeCount = ""
    var taskId:String?
    var seconds = 0 //This variable will hold a starting value of seconds. It could be any amount above 0.
    var timer = Timer()
    var isTimerRunning = false //This will be used to make sure only one timer is created at a time.
    var resumeTapped = false
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        // Drawing code here.
    }
    
    @IBAction func startButtonPressed(_ sender: Any) {
        if isTimerRunning == false {
            runTimer()
        }
    }
    
    @IBAction func pauseButtonTapped(_ sender: Any) {
        if self.resumeTapped == false {
            timer.invalidate()
            self.resumeTapped = true
        } else {
            runTimer()
            self.resumeTapped = false
        }
    }
    
    @IBAction func resetButtonTapped(_ sender: Any) {
        timer.invalidate()
        seconds = 0    //Here we manually enter the restarting point for the seconds, but it would be wiser to make this a variable or constant.
        timeCount = "\(seconds)"
        NSLog("key",timeCount)
        isTimerRunning = false
    }
    
    
    
    //MARK:- Task Time Management
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(TaskListCellView.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        seconds += 1     //This will decrement(count down)the seconds.
        timeCount = timeString(time: TimeInterval(seconds))
        timerLabel.stringValue = timeCount
        if taskId != nil {
            TaskManager.setElapsedTimeForTask(id: taskId!, to: seconds)
        }
    }
    
    func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format: "%02i:%02i:%02i", hours, minutes, seconds)
    }
}
