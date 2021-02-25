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
    var selectedTaskTime = Int()
    
    // Pass to TaskListVC
    var selectedTaskTimeLabel = String()
    
    // Passed from TaskListVC
    var timeLeft = Int()
    var lastTimeSet = Int()
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
        
        // Customize max value for setTimeSlider
        setTimeSlider.maximumValue = Float(timeLeft/60)
        
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
        if selectedTaskTime == 0 {
            // Disable save button
            buttonAnimation(button: saveTimeButton, enable: false)
        } else {
            // Enable save button
            buttonAnimation(button: saveTimeButton, enable: true)
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
        
        selectedTaskTime = hour + min
        
        // Update setTimeLabel
        setTimeLabel.text = String(format: "%01d:%02d", hour, min)
    }
    

    // MARK: - Navigation
    
    // Segue to TaskListVC (runs when unwind segue is triggered)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let time = setTimeLabel.text {
            selectedTaskTimeLabel = time
        }
    }

}
