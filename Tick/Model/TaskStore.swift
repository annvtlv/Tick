//
//  TaskStore.swift
//  Tick
//
//  Created by Анна Ветелева on 27.08.2025.
//

import Foundation

protocol TaskStoreProtocol {
    
    var onChange: (([Task]) -> Void)? { get set }
    
    func load()
    func save()
    
    func addTask(_ task: Task)
    func getTasks() -> [Task]
    func updateTask(_ task: Task)
    func removeTask(withId id: UUID)
}

class TaskStore: TaskStoreProtocol {
    
    private var tasks: [Task] = [] {
        didSet {
            onChange?(tasks)
        }
    }
    private let storage = UserDefaults.standard
    private let storageKey = "ann.vtlv.tasks.v1"
    var onChange: (([Task]) -> Void)?
    
    init(useDevData: Bool = false) {
        useDevData ? loadDevData() : load()
    }
    
    // MARK: - Persistence Service
    
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
    
    // MARK: - CRUD
    
    func addTask(_ task: Task) {
        tasks.append(task)
        save()
    }
    
    func getTasks() -> [Task] {
        tasks
    }
    
    func updateTask(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index] = task
        }
        save()
    }
    
    func toggleCompletion(for id: UUID) {
        guard let index = tasks.firstIndex(where: { $0.id == id }) else { return }
        tasks[index].isCompleted.toggle()
        save()
    }
    
    func removeTask(withId id: UUID) {
        guard let index = tasks.firstIndex(where: { $0.id == id }) else { return }
        tasks.remove(at: index)
        save()
    }
    
    // MARK: - Dev Data
    
    private func loadDevData() {
        tasks = [
            Task(title: "Buy milk for the cat", isCompleted: false, priority: .normal),
            Task(title: "Wash cat's dishes", isCompleted: true, priority: .important),
            Task(title: "Play with cat", isCompleted: true, priority: .normal),
            Task(title: "Find another cat", isCompleted: false, priority: .important)
        ]
    }
}
