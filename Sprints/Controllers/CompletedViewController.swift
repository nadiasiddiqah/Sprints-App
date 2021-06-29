//
//  CompletedViewController.swift
//  Sprints
//
//  Created by Nadia Siddiqah on 1/12/21.
//

import UIKit
import Gifu
import Lottie

class CompletedViewController: UIViewController {
    
    // MARK: - Lazy Variables
    lazy var confettiView: AnimationView = {
        let animationView = AnimationView()
        view.addSubview(animationView)
        animationView.animation = Animation.named("confettiAnimation")
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        animationView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        animationView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        animationView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        return animationView
    }()
    
    lazy var taskCompleteView: AnimationView = {
        let animationView = AnimationView()
        imageView.addSubview(animationView)
        animationView.animation = Animation.named("taskCompleteAnimation")
        animationView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        animationView.contentMode = .scaleAspectFit
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        
        animationView.topAnchor.constraint(equalTo: imageView.topAnchor).isActive = true
        animationView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true
        animationView.leftAnchor.constraint(equalTo: imageView.leftAnchor).isActive = true
        animationView.rightAnchor.constraint(equalTo: imageView.rightAnchor).isActive = true
        return animationView
    }()
    
    // MARK: - Outlet Variables
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var startNewSprint: UIButton!
    
    // MARK: - View Controller Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        playAnimation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        Utils.showGradientLayer(view: view)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    // MARK: - Methods
    func playAnimation() {
        taskCompleteView.animationSpeed = 1.4
        taskCompleteView.play(fromProgress: 0, toProgress: 0.2, loopMode: .playOnce, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [self] in
            view.bringSubviewToFront(startNewSprint)
            confettiView.animationSpeed = 0.85
            confettiView.play(fromProgress: 0, toProgress: 1, loopMode: .playOnce) { _ in
                self.confettiView.isHidden = true
                self.startNewSprint.isHidden = false
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
                taskCompleteView.animationSpeed = 0.75
                taskCompleteView.play(fromProgress: 0.08, toProgress: 0.2, loopMode: .playOnce, completion: nil)
            }
        }
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToStart" {
            Utils.tasks.removeAll()
            Utils.completedTaskInfo.removeAll()
        }
    }

}
