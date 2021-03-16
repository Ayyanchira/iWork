//
//  TaskProvider.swift
//  iWork
//
//  Created by Akshay Ayyanchira on 3/15/21.
//

import Foundation

class TaskManager {
    
    var tasks:[String: Task] = [String:Task]()
    
    func getAllTasks() -> [Task]? {
        return tasks.values.shuffled()
    }
    
    func addTask(name:String, description: String?) -> Task {
        let task = Task(name: name, description: description)
        tasks[task.id] = task
        print("Task \(task.id) added to array")
        return task
    }
    
    
    func addTimeToTask(id:String, seconds:Double) {
        guard let task = tasks[id] else {
            print("Task not found")
            return
        }
        task.elapsedTime += seconds
        tasks[id] = task
    }
    
}
