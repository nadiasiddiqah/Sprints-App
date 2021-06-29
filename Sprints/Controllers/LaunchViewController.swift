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
    
    @IBOutlet weak var sprintView: UIView!
    
    lazy var sprintGif: GIFImageView = {
        let gif = GIFImageView()
        gif.contentMode = .scaleAspectFit
        gif.animate(withGIFNamed: "sprintlaunch")
        
        return gif
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        playAnimation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func playAnimation() {
        sprintView.addSubview(sprintGif)
        
        sprintGif.topToSuperview()
        sprintGif.bottomToSuperview()
        sprintGif.leftToSuperview()
        sprintGif.rightToSuperview()
    }
    
}
