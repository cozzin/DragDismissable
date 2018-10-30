//
//  ModalViewController.swift
//  DragDismissible
//
//  Created by seongho on 30/10/2018.
//  Copyright © 2018 seongho. All rights reserved.
//

import UIKit

protocol DragDismissible {
    func setInteractor(_ interactor: Interactor?)
    func setGesture()
}

private enum AssociatedKeys {
    static var interactor = "DragModalPresentableInteractor"
}

extension DragDismissible where Self: UIViewController {
    
    var interactor: Interactor? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.interactor) as? Interactor
        }
        set(value) {
            objc_setAssociatedObject(self, &AssociatedKeys.interactor, value, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    func setGesture() {
//        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:))))
    }
    
    func handlePanGesture(_ sender: UIPanGestureRecognizer) {
        guard let interactor = interactor else {
            return
        }
        let percentThreshold: CGFloat = 0.3
        let translation = sender.translation(in: view)
        let verticalMovement = translation.y / view.bounds.height
        let downwardMovement = fmaxf(Float(verticalMovement), 0.0)
        let downwardMovementPercent = fminf(downwardMovement, 1.0)
        let progress = CGFloat(downwardMovementPercent)
        
        switch sender.state {
        case .began:
            interactor.hasStarted = true
            dismiss(animated: true)
        case .changed:
            interactor.shouldFinish = progress > percentThreshold
            interactor.update(progress)
        case .cancelled:
            interactor.hasStarted = false
            interactor.cancel()
        case .ended:
            interactor.hasStarted = false
            interactor.shouldFinish ? interactor.finish() : interactor.cancel()
        default:
            break
        }
    }
}

class ModalViewController: UIViewController, DragDismissible {

    func setInteractor(_ interactor: Interactor?) {
        self.interactor = interactor
    }
    
    weak var interactor: Interactor?
    
    deinit {
        print("deinit \(self)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:))))
    }
    
    @objc
    func handlePanGesture(_ sender: UIPanGestureRecognizer) {
        guard let interactor = interactor else {
            return
        }
        let percentThreshold: CGFloat = 0.3
        let translation = sender.translation(in: view)
        let verticalMovement = translation.y / view.bounds.height
        let downwardMovement = fmaxf(Float(verticalMovement), 0.0)
        let downwardMovementPercent = fminf(downwardMovement, 1.0)
        let progress = CGFloat(downwardMovementPercent)

        switch sender.state {
        case .began:
            interactor.hasStarted = true
            dismiss(animated: true)
        case .changed:
            interactor.shouldFinish = progress > percentThreshold
            interactor.update(progress)
        case .cancelled:
            interactor.hasStarted = false
            interactor.cancel()
        case .ended:
            interactor.hasStarted = false
            interactor.shouldFinish ? interactor.finish() : interactor.cancel()
        default:
            break
        }
    }
}
