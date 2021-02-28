//
//  CompletedViewController.swift
//  Sprints
//
//  Created by Nadia Siddiqah on 1/12/21.
//

import UIKit
import Gifu

class CompletedViewController: UIViewController {
    
    // MARK: - Lazy Variables
    lazy var taskCompleteGif: GIFImageView = {
        let gif = GIFImageView(frame: CGRect(x: taskCompleteGifView.frame.origin.x, y: taskCompleteGifView.frame.origin.y,
                                              width: taskCompleteGifView.frame.width, height: taskCompleteGifView.frame.height))
        gif.contentMode = .scaleAspectFit
        gif.animate(withGIFNamed: "taskCompleteAnimation")
        gif.animationRepeatCount = 1
        return gif
    }()
    
    lazy var confettiGif: GIFImageView = {
        let gif = GIFImageView(frame: view.bounds)
        gif.contentMode = .scaleAspectFill
        gif.animate(withGIFNamed: "completionAnimation")
        gif.animationRepeatCount = 3
        return gif
    }()
    
    // MARK: - Outlet Variables
    @IBOutlet weak var taskCompleteGifView: UIImageView!

    // MARK: - View Controller Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        taskCompleteGifView.addSubview(taskCompleteGif)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) { [self] in
            view.addSubview(confettiGif)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        showGradientLayer(view: view)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    // MARK: - Methods
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToStart" {
            tasks.removeAll()
            completedTaskInfo.removeAll()
        }
    }

}
