//
//  Task.swift
//  Tick
//
//  Created by Анна Ветелева on 27.08.2025.
//

import Foundation

enum TaskPriority: String, Codable {
    case normal
    case important
}

struct Task: Codable {
    var title: String
    var isCompleted: Bool
    var priority: TaskPriority
}
