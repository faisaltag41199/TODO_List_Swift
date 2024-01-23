//
//  Task.swift
//  taskapp_swift_workshop
//
//  Created by Faisal TagEldeen on 05/01/2024.
//

import Foundation

class Task : Codable{
    
    var taskId: Int?
    var title: String?
    var taskDescription: String?
    var priority: String?
    var status: String?
    var date: Date?
    
    init(taskId: Int? = nil, title: String? = nil, taskDescription: String? = nil, priority: String? = nil, status: String? = nil, date: Date? = nil) {
        self.taskId = taskId
        self.title = title
        self.taskDescription = taskDescription
        self.priority = priority
        self.status = status
        self.date = date
    }
    
}

