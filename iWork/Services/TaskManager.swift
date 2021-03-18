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
//        print("Task \(task.id) added to array")
        return task
    }
    
    static func updateTaskName(name: String, description: String?, for id: String) {
        guard let task = TaskManager.tasks[id] else {
            print("Task not found")
            return
        }
        if name.count > 2 {
            task.name = name
            task.taskDescription = description ?? ""
            TaskManager.tasks[id] = task
        }
    }
    
    static func setElapsedTimeForTask(id:String, to seconds:Int) {
        guard let task = TaskManager.tasks[id] else {
            print("Task not found")
            return
        }
        print("Updating task \(id) - \(task.name)")
        task.elapsedTime = seconds
        TaskManager.tasks[id] = task
    }
    
    static func getTask(id:String) -> Task? {
        guard let task = TaskManager.tasks[id] else {
            print("Task not found")
            return nil
        }
        return task
    }
    
    static func markAsComplete(id: String) {
        guard let task = TaskManager.tasks[id] else {
            print("Task not found")
            return
        }
        task.status = .COMPLETE
        TaskManager.tasks[id] = task
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "taskUpdate\(id)"), object: nil)
    }
    
    static func updateTask(task: Task) {
        tasks[task.id] = task
    }
    
    static func deleteTask(id: String) {
        print("Deleting task id \(id)")
        tasks.removeValue(forKey: id)
    }
    
}
