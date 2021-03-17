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
        setSeperatorColor()
    }
    
    func setSeperatorColor() {
        if(!isTimerRunning) {
            if (seconds == 0) {
                //Not started yet
                seperatorView.layer?.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            } else {
                //Paused
                seperatorView.layer?.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            }
        } else {
            //Running
            seperatorView.layer?.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        }
    }
    
    @IBAction func startButtonPressed(_ sender: Any) {
        if isTimerRunning == false {
            isTimerRunning = true
            runTimer()
            startStopButton.title = "Pause"
        } else {
            isTimerRunning = false
            startStopButton.title = "Resume"
            timer.invalidate()
        }
        setSeperatorColor()
    }
    
    
    
    //MARK:- Task Time Management
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(TaskListCellView.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        seconds += 1     //This will increment the seconds.
        timerLabel.stringValue = timeString(time: TimeInterval(seconds))
        
        //Commit to local
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
