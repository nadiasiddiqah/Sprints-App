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
public class TaskData {
    var name: String
    var time: String
    
    init(name: String, time: String) {
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
    var savedTaskName = [String]()
    var savedTaskTime: [String] = []
    var selectedTaskTime = ""
    
    var taskCount: Int = 1
    
//    var selectedRowIndex: IndexPath = []
    
    
    // MARK: - View Controller Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Define max height for table view
        taskList.maxHeight = 351
        
        // Connect table view's dataSource and delegate to current view controller
        taskList.delegate = self
        taskList.dataSource = self
        
        // Update time labels on screen
        totalTimeLabel.text = "\(savedTotalTime[0] + ":" + savedTotalTime[1])"
        timeLeftLabel.text = totalTimeLabel.text
        
        // Update button title
    }
    
    // MARK: - Navigation
    
    // Unwind from SelectTimeVC
    @IBAction func unwindFromSelectTime(_ sender: UIStoryboardSegue) {
        if sender.source is SelectTimeViewController {
            if let controller = sender.source as? SelectTimeViewController {
                savedTaskTime.append(controller.selectedTaskTime)
            }
            taskList.reloadData()
        }
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskCell
        
        // Configure timeButton in cell
        cell.timeButton.tag = indexPath.row
        
        if savedTaskTime.isEmpty {
            cell.timeButton.setTitle("Set time", for: .normal)
        } else {
            cell.timeButton.setTitle(savedTaskTime[indexPath.row], for: .normal)
        }
        
//        // Configure nameField in cell
//        cell.nameField.tag = indexPath.row
//        cell.nameField.delegate = self
        
        return cell
    }
    
}

extension TaskListViewController: UITableViewDelegate {
    
    // De-selects a row after its selected
//    func tableView(_ tableView: UITableView,
//                   didSelectRowAt indexPath: IndexPath) {
//
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
}

extension TaskListViewController: UITextFieldDelegate {
    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        if let savedText = textField.text {
//            savedTaskName.append(savedText)
//        } else {
//            savedTaskName.append("")
//        }
//    }
    
    // Resigns text field in focus + dismisses upon pressing return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

