//
//  TaskListController.swift
//  Tick
//
//  Created by Анна Ветелева on 26.08.2025.
//

import UIKit

class TaskListController: UITableViewController {
    
    var taskStore: TaskStoreProtocol = TaskStore(useDevData: true)
    private var tasksByPriority: [TaskPriority: [Task]] = [:] {
        didSet {
            for (taskGroupPriority, taskGroup) in tasksByPriority {
                tasksByPriority[taskGroupPriority] = taskGroup.sorted { task1, task2 in
                    let firstTaskPosition = taskStatusPosition.firstIndex(of: task1.isCompleted) ?? 0
                    let secondTaskPosition = taskStatusPosition.firstIndex(of: task2.isCompleted) ?? 0
                    return firstTaskPosition < secondTaskPosition
                }
            }
        }
    }
    
    let sectionsPrioritiesPosition: [TaskPriority] = [.important, .normal]
    var taskStatusPosition: [Bool] = [false, true]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: "TaskCell")
        loadTasks(tasks: taskStore.getTasks())
        taskStore.onChange = { [weak self] tasks in
            self?.loadTasks(tasks: tasks)
            self?.tableView.reloadData()
        }
    }
    
    private func loadTasks(tasks: [Task]) {
        sectionsPrioritiesPosition.forEach { priority in
            tasksByPriority[priority] = []
        }
        tasks.forEach { task in
            tasksByPriority[task.priority]?.append(task)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionsPrioritiesPosition.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let priority = sectionsPrioritiesPosition[section]
        guard let currentPriorityTasks = tasksByPriority[priority] else { return 0 }
        return currentPriorityTasks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskTableViewCell
        let priority = sectionsPrioritiesPosition[indexPath.section]
        guard let currentTask = tasksByPriority[priority]?[indexPath.row] else { return cell }
        cell.configure(with: currentTask)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title: String?
        switch sectionsPrioritiesPosition[section] {
        case .important:
            title = "Important"
        case .normal:
            title = "Current"
        }
        return title
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
