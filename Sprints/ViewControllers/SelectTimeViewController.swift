//
//  SelectTimeViewController.swift
//  Sprints
//
//  Created by Nadia Siddiqah on 1/20/21.
//

import UIKit

class CustomSlider: UISlider {
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        let point = CGPoint(x: bounds.minX, y: bounds.midY)
        return CGRect(origin: point, size: CGSize(width: bounds.width, height: 15))
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        var bounds: CGRect = self.bounds
        bounds = bounds.insetBy(dx: -10, dy: -15)
        return bounds.contains(point)
    }
}

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
    
    // MARK: - Outlet Variables
    @IBOutlet weak var setTimeLabel: UILabel!
    @IBOutlet weak var setTimeSlider: CustomSlider!
    @IBOutlet weak var saveTimeButton: UIButton!
    
    // MARK: - View Controller Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        enableSaveTimeButton()
        
        // Initialize setTimeLabel
        updateTimeLabel()
        
        // Initialize setTimeSlider
        setTimeSlider.value = timeFloat
        setTimeSlider.maximumValue = Float(timeLeft/60)
        setTimeSlider.minimumTrackTintColor = Utils.lavender
        setTimeSlider.setThumbImage(UIImage(named: "sprintsSlider"), for: .normal)
        
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
            Utils.buttonEnabling(button: saveTimeButton, enable: false)
        } else {
            // Enable save button
            Utils.buttonEnabling(button: saveTimeButton, enable: true)
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
