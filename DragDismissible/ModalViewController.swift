//
//  ModalViewController.swift
//  DragDismissible
//
//  Created by seongho on 30/10/2018.
//  Copyright © 2018 seongho. All rights reserved.
//

import UIKit

class ModalViewController: UIViewController, DragDismissible {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        
        addDragDismissGestureRecognizer()
    }
}
