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
   
//    @IBOutlet weak var timeField: IQDropDownTextField!
    
    // MARK: - Instance Variables
    var context: NSManagedObjectContext!
    var savedTotalTime: [String] = []
    
    var taskData = [TaskData]()
    
    var taskCount: Int = 1
    
    
    // MARK: - View Controller Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register TaskListCell.xib file
        let taskCellNib = UINib(nibName: "TaskListCell", bundle: nil)
        taskList.register(taskCellNib, forCellReuseIdentifier: "taskCell")
        
//        timeField.isOptionalDropDown = false
//        timeField.itemList = ["0:15", "0:30", "0:45", "1:00", "1:30", "2:00", "2:30", "3:00"]
        
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
//        // Adds TaskData item at the beginning of array
//        taskData = [TaskData(name: "Task #1", time: ["0", "1", "2"])] + taskData
//
//        taskList.beginUpdates()
//        // Adds first row
//        taskList.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
//        taskList.endUpdates()
    }
    
    // Saves data to Core Data
    @IBAction func pressedSprint(_ sender: Any) {
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
        var cell: UITableViewCell
        
        if let c = tableView.dequeueReusableCell(withIdentifier: "taskCell") {
            cell = c
        } else {
            let c = UITableViewCell(style: .default, reuseIdentifier: "taskCell")
            cell = c
        }
        
        //cell.textLabel?.text = "New cell \(indexPath.row+1)"
        return cell
        
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
    
    
}

extension TaskListViewController: UITableViewDelegate {
    
}


