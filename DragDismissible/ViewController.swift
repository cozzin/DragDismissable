//
//  ViewController.swift
//  DragDismissible
//
//  Created by seongho on 30/10/2018.
//  Copyright © 2018 seongho. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let interactor = Interactor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onTouchButton(_ sender: Any) {
        let targetViewController = ModalViewController()
        targetViewController.interactor = interactor
        targetViewController.transitioningDelegate = self
        targetViewController.modalPresentationStyle = .custom
        present(targetViewController, animated: true)
    }
}

extension ViewController: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissAnimator()
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
}
