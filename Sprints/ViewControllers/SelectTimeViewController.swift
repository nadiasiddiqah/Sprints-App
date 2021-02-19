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
    var timeStep: Float = 15
    
    // Pass to TaskListVC
    var selectedTaskTime = String()
    var selectedTaskTimeInt = Int()
    
//    // Passed from TaskListVC
//    var currentTimeLeftInt = Int()
//    var clickedTaskTimeInt = Int()
//    var switchToSprintButton = Bool()
    
    // MARK: - Outlet Variables
    @IBOutlet weak var setTimeLabel: UILabel!
    @IBOutlet weak var setTimeSlider: UISlider!
    @IBOutlet weak var saveTimeButton: UIButton!
    
    // MARK: - View Controller Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        enableSaveTimeButton()
        
        // Initialize setTimeLabel
        updateTimeLabel()
        
        // Initialize setTimeSlider
        setTimeSlider.value = timeFloat
        
//        if switchToSprintButton {
//            setTimeSlider.maximumValue = Float((currentTimeLeftInt + clickedTaskTimeInt) / 60)
//        } else {
//            setTimeSlider.maximumValue = Float(currentTimeLeftInt / 60)
//        }
//        print(currentTimeLeftInt)
//        print(Float(currentTimeLeftInt/60))
        
        // Observes value changes in setTimeSlider
        setTimeSlider.addTarget(self, action: #selector(adjustTimeSlider(_:)), for: .valueChanged)
    }
    
    // MARK: - Action Methods
    
    // Updates UISlider and setTimeLabel value
    @IBAction func adjustTimeSlider(_ sender: UISlider) {
        timeFloat = round(sender.value / timeStep) * timeStep
        sender.value = timeFloat
        updateTimeLabel()
        enableSaveTimeButton()
    }
    
    func enableSaveTimeButton() {
        if selectedTaskTimeInt == 0 {
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
    
    // MARK: - Methods
    
    // Update Time Label with Slider Value
    func updateTimeLabel() {
        
        // Convert time from Float to Int
        let timeInt = Int(timeFloat)

        // Set hour/min value
        let hour = timeInt / 60
        let min = timeInt % 60
        
        selectedTaskTimeInt = hour + min
        
        // Update setTimeLabel
        setTimeLabel.text = String(format: "%01d:%02d", hour, min)
    }
    

    // MARK: - Navigation
    
    // Segue to TaskListVC (runs when unwind segue is triggered)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let time = setTimeLabel.text {
            selectedTaskTime = time
        }
    }

}
