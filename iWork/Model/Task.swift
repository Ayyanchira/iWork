//
//  Task.swift
//  iWork
//
//  Created by Akshay Ayyanchira on 3/15/21.
//

import Foundation

class Task: Codable {
    var id: String
    var name: String
    var taskDescription: String
    var elapsedTime: Int
    var createdAt: Double
//    var externalDocLinks: [(url:String, description:String)]?
    var status: TaskStatus
    
    init(name: String) {
        id = UUID().uuidString
        self.name = name
        taskDescription = ""
        elapsedTime = 0
//        externalDocLinks = nil
        status = TaskStatus.NEW
        createdAt = Date().timeIntervalSince1970
    }
    
    init(name: String, description: String?) {
        id = UUID().uuidString
        self.name = name
        self.taskDescription = description ?? ""
        elapsedTime = 0
//        externalDocLinks = nil
        status = TaskStatus.NEW
        createdAt = Date().timeIntervalSince1970
    }
    
    
}

extension Task: CustomStringConvertible {
    var description:String {
        return "id: \(id), name\(name), elapsedTime: \(elapsedTime)"
    }
}


enum TaskStatus: String,Codable {
    case NEW
    case IN_PROGRESS
    case PAUSED
    case COMPLETE
}

class Tasks:Codable {
    var tasks: [Task]?
}
