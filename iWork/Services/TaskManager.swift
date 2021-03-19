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
    
    static func loadFromDisk() {
        
//        https://www.appcoda.com/json-codable-swift/
        let documentsDirectoryPathString = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let documentsDirectoryPath = NSURL(string: documentsDirectoryPathString)!
        
        let jsonFilePath = documentsDirectoryPath.appendingPathComponent("Tasks.json")
        let fileManager = FileManager.default
        var isDirectory: ObjCBool = false
        
        // creating a .json file in the Documents folder
        if !fileManager.fileExists(atPath: (jsonFilePath?.absoluteString)!, isDirectory: &isDirectory) {
            print("No file found")
            return
        } else {
            print("File found")
        }
        
        do {
            let file = try FileHandle(forReadingFrom: jsonFilePath!)
            if let jsonData = NSData(contentsOf: jsonFilePath!.absoluteURL) {
                print("Got something")
            }
            
            
            if let data = try? file.readToEnd() {
                let decodedResponse = try? JSONDecoder().decode([Task].self, from: data.base64EncodedData())
                print("Hello")
            }
            print("JSON data was written to teh file successfully!")
        } catch let error as NSError {
            print("Couldn't write to file: \(error.localizedDescription)")
        }
    }
    
    static func writeToDisk() {
        let documentsDirectoryPathString = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let documentsDirectoryPath = NSURL(string: documentsDirectoryPathString)!

        let jsonFilePath = documentsDirectoryPath.appendingPathComponent("Tasks.json")
        let fileManager = FileManager.default
        var isDirectory: ObjCBool = false

        // creating a .json file in the Documents folder
        if !fileManager.fileExists(atPath: (jsonFilePath?.absoluteString)!, isDirectory: &isDirectory) {
            let created = fileManager.createFile(atPath: jsonFilePath!.absoluteString, contents: nil, attributes: nil)
            if created {
                print("File created ")
            } else {
                print("Couldn't create file for some reason")
            }
        } else {
            print("File already exists")
        }

        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted

        if let data = try? encoder.encode(TaskManager.tasks) {
            print(String(data: data, encoding: .utf8)!)
            // Write that JSON to the file created earlier
            //    let jsonFilePath = documentsDirectoryPath.appendingPathComponent("test.json")
            do {
                let file = try FileHandle(forWritingTo: jsonFilePath!)
                file.truncateFile(atOffset: 0)
                file.write(data as Data)
                file.closeFile()
                print("JSON data was written to teh file successfully!")
            } catch let error as NSError {
                print("Couldn't write to file: \(error.localizedDescription)")
            }
        }
        
    }
    
}
