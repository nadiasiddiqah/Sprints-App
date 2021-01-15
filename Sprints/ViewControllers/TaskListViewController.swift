//
//  TaskListViewController.swift
//  Sprints
//
//  Created by Nadia Siddiqah on 12/30/20.
//

import Foundation
import UIKit
import CoreData

class TaskListViewController: UIViewController {
    
    //var taskData = [String]()
//    var taskData = ["walk dog", "brush teeth"]
//    var taskTime = ["15", "20"]
//    var newtask: String = ""
    
    // MARK: - Outlet Variables
    @IBOutlet weak var taskList: UITableView!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var timeLeftLabel: UILabel!
    
    
    // MARK: - Instance Variables
    var context: NSManagedObjectContext!
    var savedTotalTime: [String] = []
    
    
    // MARK: - View Controller Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Connect table view's dataSource and delegate to current view controller
        taskList.delegate = self
        taskList.dataSource = self
        //taskList.isHidden = true
        
        // Update time labels on screen
        totalTimeLabel.text = "\(savedTotalTime[0] + ":" + savedTotalTime[1])"
        timeLeftLabel.text = totalTimeLabel.text
        
        //taskData = []
    }
    
}

extension TaskListViewController: UITableViewDataSource {
    
    // Return the number of rows in table view
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return 1
        //return taskData.count
    }
    
    // Return the cell to the insert in table view
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell")!
        
        //cell.textLabel?.text = taskData[indexPath.row]
        
        return cell
    }
    
    
}

extension TaskListViewController: UITableViewDelegate {
    
}


