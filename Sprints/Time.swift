//
//  Time.swift
//  Sprints
//
//  Created by Nadia Siddiqah on 2/10/21.
//

import Foundation
import UIKit

// MARK: - Global variables
var gradientLayer = CAGradientLayer()

var pickedTime = Int()

var tasks = [Task]()
var taskNames = [String]()
var taskTimes = [Int]()

var completedTaskInfo = [CompletedTask]()

// MARK: - Global helper methods
func showTimeLabel(time: Int) -> String {
    let hour = time / 3600
    let min = time / 60 % 60
    return String(format: "%01d:%02d", hour, min)
}

func showSecInLabel(time: Int) -> String {
    var formattedTime = String()
    let hour = time / 60 / 60
    let min = time / 60 % 60
    let sec = time % 60
    
    if hour == 0 {
        formattedTime = String(format: "%02d:%02d", min, sec)
    } else {
        formattedTime = String(format: "%01d:%02d:%02d", hour, min, sec)
    }
    
    return formattedTime
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

func buttonEnabling(button: UIButton, enable: Bool) {
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

func buttonSpringAction(button: UIButton,
                        selectedColor: UIColor, normalColor: UIColor,
                        pressDownTime: TimeInterval, normalTime: TimeInterval,
                        completionBlock: @escaping () -> Void) {
    UIView.animate(withDuration: pressDownTime, delay: 0,
                   usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5,
                   options: .curveEaseIn) {
        button.backgroundColor = selectedColor
        button.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
    } completion: { _ in
        UIView.animate(withDuration: normalTime, delay: 0,
                       usingSpringWithDamping: 0.5, initialSpringVelocity: 2,
                       options: .curveEaseIn) {
            button.backgroundColor = normalColor
            button.transform = CGAffineTransform.identity
        } completion: { _ in
            completionBlock()
        }
    }
}

let blue = #colorLiteral(red: 0.01116534323, green: 0.4508657455, blue: 0.9130660892, alpha: 1)
let teal = #colorLiteral(red: 0.08938745409, green: 0.5523278713, blue: 0.5999835134, alpha: 1)
let lavender = #colorLiteral(red: 0.4824807048, green: 0.4465178847, blue: 0.9689412713, alpha: 1)
let green = #colorLiteral(red: 0, green: 0.6272221804, blue: 0.4726006389, alpha: 1)

func showGradientLayer(view: UIView) {
    let blue = #colorLiteral(red: 0.01116534323, green: 0.4508657455, blue: 0.9130660892, alpha: 1)
    let teal = #colorLiteral(red: 0.08938745409, green: 0.5523278713, blue: 0.5999835134, alpha: 1)
    let lavender = #colorLiteral(red: 0.4824807048, green: 0.4465178847, blue: 0.9689412713, alpha: 1)

    //        gradientLayer.colors = [UIColor.systemTeal.cgColor, blueGradient.cgColor, lavenderGradient.cgColor]
    gradientLayer.colors = [lavender.cgColor, blue.cgColor, teal.cgColor]
    gradientLayer.frame = view.bounds
    view.layer.insertSublayer(gradientLayer, at: 0)
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
