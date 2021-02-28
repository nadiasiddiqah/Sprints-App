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
    
    lazy var sprintGif: GIFImageView = {
        let gif = GIFImageView()
        gif.contentMode = .scaleAspectFit
        gif.animate(withGIFNamed: "sprintlaunch")
        return gif
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.addSubview(sprintGif)
        sprintGif.centerInSuperview()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        showGradientLayer(view: view)
    }
    
}
