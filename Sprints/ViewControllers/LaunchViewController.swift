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
        let view = GIFImageView()
        view.contentMode = .scaleAspectFit
        view.animate(withGIFNamed: "sprintlaunch")
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.addSubview(sprintGif)
        sprintGif.centerInSuperview()
    }
}
