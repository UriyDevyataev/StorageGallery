//
//  TestViewController.swift
//  StorageGallery
//
//  Created by Юрий Девятаев on 20.02.2022.
//

import UIKit

class TestViewController: UIViewController {

    @IBOutlet weak var square: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        switch toInterfaceOrientation {
        case .landscapeLeft, .landscapeRight: print("landscape")
        case .portrait, .portraitUpsideDown: print("portrait")
        default: break
        }
    }

}
