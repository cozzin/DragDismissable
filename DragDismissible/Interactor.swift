//
//  Interactor.swift
//  DragDismissible
//
//  Created by seongho on 30/10/2018.
//  Copyright © 2018 seongho. All rights reserved.
//

import UIKit

class Interactor: UIPercentDrivenInteractiveTransition {
    var hasStarted: Bool = false {
        didSet {
            print("hasStarted: \(hasStarted)")
        }
    }
    var shouldFinish: Bool = false {
        didSet {
            print("shouldFinish: \(shouldFinish)")
        }
    }
}
