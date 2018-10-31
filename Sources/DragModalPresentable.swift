//
//  DragModalPresentable.swift
//  DragDismissible
//
//  Created by seongho on 31/10/2018.
//  Copyright © 2018 seongho. All rights reserved.
//

import UIKit

private enum AssociatedKeys {
    static var interactor = "DragModalPresentableInteractor"
}

public protocol DragModalPresentable: UIViewControllerTransitioningDelegate {
    func animationControllerForDragDismissed() -> UIViewControllerAnimatedTransitioning?
    func interactionControllerForDragDismissal() -> UIViewControllerInteractiveTransitioning?
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
        
        var viewController = viewController
        viewController.interactor = interactor
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
