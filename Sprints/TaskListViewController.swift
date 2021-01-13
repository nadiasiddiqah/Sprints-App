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
//    var taskData = ["walk dog", "brush teeth"]
//    var taskTime = ["15", "20"]
//    var newtask: String = ""
    
    @IBOutlet weak var taskList: UITableView!
    
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
        return 1
        //return taskData.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell",
                                                 for: indexPath)
        
        //cell.textLabel?.text = taskData[indexPath.row]
        
        return cell
    }
    
    
}

extension TaskListViewController: UITableViewDelegate {
    
}


