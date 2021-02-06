//
//  TaskRunViewController.swift
//  Sprints
//
//  Created by Nadia Siddiqah on 1/11/21.
//

import Foundation
import UIKit

class TaskRunViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var taskRunList: SelfSizedTableView!
    @IBOutlet weak var timerLabel: UILabel!
    
    // MARK: - View Controller Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Connect table view's dataSource and delegate to current view controller
        taskRunList.delegate = self
        taskRunList.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
}


// MARK: - UITableViewDataSource Extension
extension TaskRunViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "taskRunCell",
                                                 for: indexPath)

        return cell
    }


}


// MARK: - UITableViewDelegate Extension
extension TaskRunViewController: UITableViewDelegate {

}
