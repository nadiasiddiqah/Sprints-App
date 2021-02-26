//
//  CompletedViewController.swift
//  Sprints
//
//  Created by Nadia Siddiqah on 1/12/21.
//

import UIKit
import Gifu

class CompletedViewController: UIViewController {
    
    lazy var sprintGif: GIFImageView = {
        let view = GIFImageView()
        view.contentMode = .scaleAspectFit
        view.animate(withGIFNamed: "sprintlaunch")
        return view
    }()

//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view.
//        view.addSubview(sprintGif)
//        sprintGif.centerInSuperview()
//    }

    // MARK: - View Controller Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToStart" {
            tasks.removeAll()
            completedTaskInfo.removeAll()
        }
    }

}
