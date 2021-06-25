//
//  LaunchViewController.swift
//  Sprints
//
//  Created by Nadia Siddiqah on 1/11/21.
//

import UIKit
import TinyConstraints
import Gifu

class LaunchViewController: UIViewController {
     
    // MARK: Lazy Variables
    lazy var sprintAnimation: GIFImageView = {
        let gifImageView = GIFImageView()
        gifImageView.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
        gifImageView.animate(withGIFNamed: "sprintlaunch")
        
        return gifImageView
    }()
    
    // MARK: - Outlet Variables
    @IBOutlet weak var sprintGifImageView: UIImageView!
    
    // MARK: - View Controller Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        playAnimation()
    }
    
    func playAnimation() {
        sprintGifImageView.addSubview(sprintAnimation)
        sprintAnimation.centerInSuperview()
    }
}
