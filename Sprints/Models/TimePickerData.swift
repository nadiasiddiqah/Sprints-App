//
//  TimePickerData.swift
//  Sprints
//
//  Created by Nadia Siddiqah on 6/24/21.
//

import Foundation

// Custom class type to set hour/min options in UIPickerView

class TimePickerData {
    var hour: String
    var minute: [String]
    
    init(hour: String, minute: [String]) {
        self.hour = hour
        self.minute = minute
    }
}
