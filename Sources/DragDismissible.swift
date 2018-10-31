//
//  DragDismissible.swift
//  DragDismissible
//
//  Created by seongho on 31/10/2018.
//  Copyright © 2018 seongho. All rights reserved.
//

import UIKit

public protocol DragDismissible {
    mutating func setInteractor(_ interactor: Interactor?)
    func addDragDismissGestureRecognizer(on targetView: UIView?)
}

private enum AssociatedKeys {
    static var interactor = "DragModalPresentableInteractor"
}

private enum Constants {
    static let percentThreshold: CGFloat = 0.3
}

extension DragDismissible where Self: UIViewController {
    
    var interactor: Interactor? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.interactor) as? Interactor
        }
        set(value) {
            objc_setAssociatedObject(self, &AssociatedKeys.interactor, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    mutating func setInteractor(_ interactor: Interactor?) {
        self.interactor = interactor
    }
    
    func addDragDismissGestureRecognizer(on targetView: UIView? = nil) {
        (targetView ?? view)?.addGestureRecognizer(UIPanGestureRecognizer(handler: { [weak self] sender in
            (sender as? UIPanGestureRecognizer).flatMap {
                self?.handlePanGesture($0)
            }
        }))
    }
    
    func handlePanGesture(_ sender: UIPanGestureRecognizer) {
        guard let interactor = interactor else {
            return
        }
        
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
            interactor.shouldFinish = progress > Constants.percentThreshold
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

// MARK: - GestureClosureSleeve

private class GestureClosureSleeve {
    let closure: (UIGestureRecognizer) -> ()
    
    init (_ closure: @escaping (UIGestureRecognizer) -> ()) {
        self.closure = closure
    }
    
    @objc
    func execute(_ sender: UIGestureRecognizer) {
        closure(sender)
    }
}

private extension UIGestureRecognizer {
    convenience init(handler: @escaping (UIGestureRecognizer) -> ()) {
        let sleeve = GestureClosureSleeve(handler)
        self.init(target: sleeve, action: #selector(GestureClosureSleeve.execute(_:)))
        objc_setAssociatedObject(self, "\(arc4random())", sleeve, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    func addAction(_ handler: @escaping (UIGestureRecognizer)->()) {
        let sleeve = GestureClosureSleeve(handler)
        addTarget(sleeve, action: #selector(GestureClosureSleeve.execute(_:)))
        objc_setAssociatedObject(self, "\(arc4random())", sleeve, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}
