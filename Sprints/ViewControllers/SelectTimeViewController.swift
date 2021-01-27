//
//  SelectTimeViewController.swift
//  Sprints
//
//  Created by Nadia Siddiqah on 1/20/21.
//

import UIKit

class SelectTimeViewController: UIViewController {
    
    // MARK: - Instance Variables
    var timeFloat: Float = 0
    
    var hour: String = "0"
    var min: String = "00"
    var selectedTaskTime: String!
//    var selectedRowIndex: IndexPath = []
    
    // MARK: - Outlet Variables
    @IBOutlet weak var setTimeLabel: UILabel!
    @IBOutlet weak var setTimeSlider: UISlider!
    @IBOutlet weak var saveTimeButton: UIButton!
    
    // MARK: - Action Methods
    
    // Updates UISlider and setTimeLabel value
    @IBAction func adjustTimeSlider(_ sender: UISlider) {
        timeFloat = sender.value
        updateTimeLabel()
        enableSaveTimeButton()
    }
    
    func enableSaveTimeButton() {
        if (hour, min) == ("0", "00") {
            // Animate disabling save button
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear) {
                self.saveTimeButton.alpha = 0.6
            } completion: { _ in
                self.saveTimeButton.isEnabled = false
            }
        } else {
            // Animate enabling save button
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear) {
                self.saveTimeButton.alpha = 1
            } completion: { _ in
                self.saveTimeButton.isEnabled = true
            }
        }
    }
    
    // Save set time + returns to TaskList screen
//    @IBAction func saveTimeButton(_ sender: UIButton) {
//        if (hour, min) != ("0", "00") {
//            selectedTaskTime = "\(hour + ":" + min)"
//            performSegue(withIdentifier: "unwindToTaskList", sender: self)
//        } else {
//            let alert = UIAlertController(title: "Error", message: "Please enter valid time", preferredStyle: .alert)
//            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//            alert.addAction(action)
//            present(alert, animated: true, completion: nil)
//        }
//    }
    
    // MARK: - View Controller Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        enableSaveTimeButton()
        
        // Initialize setTimeLabel
        updateTimeLabel()
        
        // Initialize setTimeSlider
        setTimeSlider.value = timeFloat
        
        // Observes value changes in setTimeSlider
        setTimeSlider.addTarget(self, action: #selector(adjustTimeSlider(_:)), for: .valueChanged)

    }
    
    // MARK: - Methods
    
    // Update Time Label with Slider Value
    func updateTimeLabel() {
        
        // Convert time from Float to Int
        let timeInt = Int(timeFloat)
        
        // Initialize setTimeLabel
        let timeSet = "\(hour + ":" + min)"

        // Set hour value
        hour = "\(timeInt / 60)"
        
        // Check min conditions + set min value
        let minCheck = timeInt % 60
        
        switch minCheck {
        case 0:
            min = "00"
        case 1...9:
            min = "0" + "\(minCheck)"
        default:
            min = "\(minCheck)"
        }
        
        // Update setTimeLabel
        setTimeLabel.text = timeSet
    }
    

    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let time = setTimeLabel.text {
            selectedTaskTime = time
        }
    }

    
////  Segue runs when unwind segue is triggered
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        selectedTaskTime = "\(hour + ":" + min)"
////        if segue.identifier == "savedTime" {
////            let controller = segue.destination as! TaskListViewController
////            controller.selectedTaskTime = selectedTaskTime
////            //controller.taskList.reloadRows(at: [selectedRowIndex], with: .automatic)
////        }
//    }


}
