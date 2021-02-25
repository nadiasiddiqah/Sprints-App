//
//  Time.swift
//  Sprints
//
//  Created by Nadia Siddiqah on 2/10/21.
//

import Foundation
import UIKit

// MARK: - Global variables
var pickedTime = Int()

var tasks = [Task]()
var taskNames = [String]()
var taskTimes = [Int]()

var completedTaskInfo = [CompletedTask]()

// MARK: - Global helper methods
func showTimeLabel(time: Int) -> String {
    let hour = time / 60 / 60
    let min = (time - (hour * 60 * 60)) / 60
    return String(format: "%01d:%02d", hour, min)
}

func showTimeInSec(time: String) -> Int {
    let components = time.split(separator: ":").map { (x) -> Int in
        return Int(String(x))!
    }
    return (components[0]*60*60) + (components[1]*60)
}

func roundedBorder(object: [UIView]) {
    for i in object {
        i.layer.masksToBounds = true
        i.layer.cornerRadius = 10
        i.layer.borderWidth = 2
        i.layer.borderColor = UIColor.black.cgColor
    }
}

func buttonAnimation(button: UIButton, enable: Bool) {
    if enable == true {
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear) {
            button.alpha = 1
        } completion: { _ in
            button.isEnabled = true
        }
    } else {
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear) {
            button.alpha = 0.6
        } completion: { _ in
            button.isEnabled = false
        }
    }
}

// MARK: - Extensions
extension UIView {
    func fadeTransition(_ duration: CFTimeInterval) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.fade
        animation.duration = duration
        layer.add(animation, forKey: CATransitionType.fade.rawValue)
    }
}

extension UILabel {
  func strikeThroughText() {
    let attributeString = NSMutableAttributedString(string: self.text ?? "")
    attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle,
                                 value: NSUnderlineStyle.single.rawValue,
                                 range: NSMakeRange(0,attributeString.length))
    attributeString.addAttribute(NSAttributedString.Key.strikethroughColor,
                                 value: UIColor.black,
                                 range: NSMakeRange(0, attributeString.length))
    self.attributedText = attributeString
  }
  
    func removeStrikeThrough() {
        let attributeString = NSMutableAttributedString(string: self.text ?? "")
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle,
                                     value: NSUnderlineStyle.single.rawValue,
                                     range: NSMakeRange(0,attributeString.length))
        attributeString.addAttribute(NSAttributedString.Key.strikethroughColor,
                                     value: UIColor.clear,
                                     range: NSMakeRange(0, attributeString.length))
        self.attributedText = attributeString
    }
    
}

private var __maxLengths = [UITextField: Int]()
extension UITextField {
    @IBInspectable var maxLength: Int {
        get {
            guard let l = __maxLengths[self] else {
                return 150 // (global default-limit. or just, Int.max)
            }
            return l
        }
        set {
            __maxLengths[self] = newValue
            addTarget(self, action: #selector(fix), for: .editingChanged)
        }
    }
    @objc func fix(textField: UITextField) {
        if let t = textField.text {
            textField.text = String(t.prefix(maxLength))
        }
    }
}
