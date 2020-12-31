//
//  TaskListViewController.swift
//  Sprints
//
//  Created by Nadia Siddiqah on 12/30/20.
//

import Foundation
import UIKit

class TaskListViewController: UIViewController {
    
    //var taskData = [String]()
    var taskData = ["walk dog", "brush teeth"]
    var newtask: String = ""
    
    @IBOutlet weak var taskList: UITableView!
    
    @IBAction func addTask(_ sender: UIButton) {
        self.taskData.append("eat banana")
        self.taskList.reloadData()
        //taskList.insertRows(at: [IndexPath(row: taskData.count-1, section: 0)], with: .automatic)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskList.delegate = self
        taskList.dataSource = self
        
        //taskData = []
    }
    
}

extension TaskListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return taskData.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell",
                                                 for: indexPath)
        
        cell.textLabel?.text = taskData[indexPath.row]
        
        return cell
    }
    
    
}

extension TaskListViewController: UITableViewDelegate {
    
}


