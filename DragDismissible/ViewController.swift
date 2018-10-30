//
//  ViewController.swift
//  DragDismissible
//
//  Created by seongho on 30/10/2018.
//  Copyright © 2018 seongho. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
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

extension ViewController: DragModalPresentable { }

protocol DragModalPresentable: UIViewControllerTransitioningDelegate {
    func animationControllerForDragDismissed() -> UIViewControllerAnimatedTransitioning?
    func interactionControllerForDragDismissal() -> UIViewControllerInteractiveTransitioning?
}

private enum AssociatedKeys {
    static var interactor = "DragModalPresentableInteractor"
}

extension DragModalPresentable where Self: ViewController {
    var interactor: Interactor? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.interactor) as? Interactor
        }
        set(value) {
            objc_setAssociatedObject(self, &AssociatedKeys.interactor, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    func presentDragDismissible<T: UIViewController & DragDismissible>(_ viewController: T, animated: Bool, completion: (() -> Void)? = nil) {
        let interactor = Interactor()
        self.interactor = interactor
        viewController.setInteractor(interactor)
        viewController.transitioningDelegate = self
        viewController.modalPresentationStyle = .custom
        present(viewController, animated: animated, completion: completion)
    }
    
    func animationControllerForDragDismissed() -> UIViewControllerAnimatedTransitioning? {
        return DismissAnimator()
    }
    
    func interactionControllerForDragDismissal() -> UIViewControllerInteractiveTransitioning? {
        return (interactor?.hasStarted ?? false) ? interactor : nil
    }
}
