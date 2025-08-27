//
//  TaskStore.swift
//  Tick
//
//  Created by Анна Ветелева on 27.08.2025.
//

import Foundation

protocol TaskStoreProtocol {
    var tasks: [Task] { get }
    func load()
    func save()
}

class TaskStore: TaskStoreProtocol {
    
    private(set) var tasks: [Task] = []
    private let storage = UserDefaults.standard
    private let storageKey = "ann.vtlv.tasks.v1"
    
    init(useDevData: Bool = false) {
        useDevData ? loadDevData() : load()
    }
    
    func load() {
        guard let data = storage.data(forKey: storageKey) else {
            tasks = []
            return
        }
        let decoder = JSONDecoder()
        do {
            tasks = try decoder.decode([Task].self, from: data)
        } catch {
            print("❌ Failed to load tasks: \(error)")
            tasks = []
        }
    }
    
    func save() {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(tasks)
            storage.set(data, forKey: storageKey)
        } catch {
            print("❌ Failed to save tasks: \(error)")
        }
    }
    
    private func loadDevData() {
        tasks = [
            Task(title: "Buy milk for the cat", isCompleted: false, priority: .normal),
            Task(title: "Wash cat's dishes", isCompleted: true, priority: .important),
            Task(title: "Play with cat", isCompleted: true, priority: .normal),
            Task(title: "Find another cat", isCompleted: false, priority: .important)
        ]
    }
}
