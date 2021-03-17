//
//  TaskProvider.swift
//  iWork
//
//  Created by Akshay Ayyanchira on 3/15/21.
//

import Foundation

class TaskManager {
    
    static var tasks:[String: Task] = [String:Task]()
    
    static func getAllTasks() -> [Task]? {
        return TaskManager.tasks.values.sorted { (task1, task2) -> Bool in
            return task1.createdAt < task2.createdAt
        }
    }
    
    static func addTask(name:String, description: String?) -> Task {
        let task = Task(name: name, description: description)
        TaskManager.tasks[task.id] = task
        print("Task \(task.id) added to array")
        return task
    }
    
    
    static func addTimeToTask(id:String, seconds:Double) {
        guard let task = TaskManager.tasks[id] else {
            print("Task not found")
            return
        }
        task.elapsedTime += seconds
        TaskManager.tasks[id] = task
    }
    
}
