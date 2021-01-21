//
//  TaskListViewController.swift
//  Sprints
//
//  Created by Nadia Siddiqah on 12/30/20.
//

import Foundation
import UIKit
import CoreData



// MARK: - TimerData Class

// Custom class type to set task name/time in UITableView
class TaskData {
    var name: String?
    var time: [String]?
    
    init(name: String, time: [String]) {
        self.name = name
        self.time = time
    }
}

class TaskListViewController: UIViewController {
    
    // MARK: - Outlet Variables
    @IBOutlet weak var taskList: SelfSizedTableView!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var timeLeftLabel: UILabel!
    @IBOutlet weak var addTaskButton: UIButton!
    @IBOutlet weak var sprintButton: UIButton!
    
    // MARK: - Instance Variables
    var context: NSManagedObjectContext!
    var savedTotalTime: [String] = []
    
    var taskData = [TaskData]()
    
    var taskCount: Int = 1
    
    
    // MARK: - View Controller Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register TaskListCell.xib file
        let taskCellNib = UINib(nibName: "TaskCell", bundle: nil)
        taskList.register(taskCellNib, forCellReuseIdentifier: "taskCell")
        
        // Define max height for table view
        taskList.maxHeight = 351
        
        // Connect table view's dataSource and delegate to current view controller
        taskList.delegate = self
        taskList.dataSource = self
        
        // Update time labels on screen
        totalTimeLabel.text = "\(savedTotalTime[0] + ":" + savedTotalTime[1])"
        timeLeftLabel.text = totalTimeLabel.text
    
    }
    
    
    // MARK: - Action Methods
    
    // Adds new cell in Table View
    @IBAction func pressedAddTask(_ sender: UIButton) {
        taskCount += 1
        taskList.reloadData()
        taskList.scrollToRow(at: IndexPath(row: taskCount-1, section: 0), at: .bottom, animated: true)
    }
    
    // Saves data to Core Data
    @IBAction func pressedSprint(_ sender: Any) {
    }
    
    // MARK: - Methods
    @objc func pressedTimeButton(_ sender: UIButton) {
        print("Button tapped")
    }
    
}

extension TaskListViewController: UITableViewDataSource {
    
    // Return the number of rows in table view
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return taskCount
    }
    
    // Return the cell to the insert in table view
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskListCell
        
//        tableView.beginUpdates()
        cell.timeButton.tag = indexPath.row
        cell.timeButton.addTarget(self, action: #selector(pressedTimeButton(_:)), for: .touchUpInside)
//        tableView.endUpdates()
        
        return cell
        
//        var cell: TaskListCell! = tableView.dequeueReusableCell(withIdentifier: "taskCell") as? TaskListCell
//        if cell == nil {
//            let taskCellNib = UINib(nibName: "TaskListCell", bundle: nil)
//            tableView.register(taskCellNib, forCellReuseIdentifier: "taskCell")
//            cell = tableView.dequeueReusableCell(withIdentifier: "taskCell") as? TaskListCell
//        }
        
        // Configure cell
//        var cell: TaskListCell!
//
//        // If there is an existing cell, it returns reusable table view cell
//        if let c = tableView.dequeueReusableCell(withIdentifier: "taskCell") as? TaskListCell {
//            cell = c
//        // If there is no cell, it initializes new reusable table view cell
//        } else {
//            let c = TaskListCell(style: .default, reuseIdentifier: "taskCell")
//            cell = c
//        }
//
//        cell.timeButton.tag = indexPath.row
//        cell.timeButton.addTarget(self, action: #selector(pressedTimeButton(_:)), for: .touchUpInside)
        
        
        //cell.textLabel?.text = "New cell \(indexPath.row+1)"
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath)
//
//        let task = taskData[indexPath.row]
//
//        if let taskName = task.name, let taskTime = task.time {
//            cell.textLabel?.text = taskName
//            cell.textLabel?.text = "\(taskTime[0] + ":" + taskTime[1])"
//        }
//
//        return cell
    }
    
//    func tableView(_ tableView: UITableView,
//                   didSelectRowAt indexPath: IndexPath) {
//
//        if let cell = tableView.cellForRow(at: indexPath) as? TaskListCell {
//            cell.timeButton.tag = indexPath.row
//            cell.timeButton.addTarget(self, action: #selector(pressedTimeButton(_:)), for: .touchUpInside)
//        }
//    }
    
}

extension TaskListViewController: UITableViewDelegate {
}



