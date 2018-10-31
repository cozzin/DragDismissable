//
//  ViewController.swift
//  DragDismissible
//
//  Created by seongho on 30/10/2018.
//  Copyright © 2018 seongho. All rights reserved.
//

import UIKit

class ViewController: UIViewController, DragModalPresentable {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onTouchButton(_ sender: Any) {
        presentDragDismissible(ModalViewController(), animated: true)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animationControllerForDragDismissed()
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactionControllerForDragDismissal()
    }
}
