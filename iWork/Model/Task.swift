//
//  Task.swift
//  iWork
//
//  Created by Akshay Ayyanchira on 3/15/21.
//

import Foundation

class Task {
    var id: String
    var name: String
    var description: String
    var elapsedTime: Int
    var createdAt: Double
    var externalDocLinks: [(url:String, description:String)]?
    var status: TaskStatus
    
    init(name: String) {
        id = UUID().uuidString
        self.name = name
        description = ""
        elapsedTime = 0
        externalDocLinks = nil
        status = TaskStatus.NEW
        createdAt = Date().timeIntervalSince1970
    }
    
    init(name: String, description: String?) {
        id = UUID().uuidString
        self.name = name
        self.description = description ?? ""
        elapsedTime = 0
        externalDocLinks = nil
        status = TaskStatus.NEW
        createdAt = Date().timeIntervalSince1970
    }
}


enum TaskStatus {
    case NEW
    case IN_PROGRESS
    case PAUSED
    case COMPLETE
}
