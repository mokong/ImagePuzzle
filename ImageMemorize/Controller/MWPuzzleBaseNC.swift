//
//  MWPuzzleBaseNC.swift
//  ImageMemorize
//
//  Created by Horizon on 27/12/2022.
//

import UIKit

class MWPuzzleBaseNC: UINavigationController {
    // MARK: - view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Orientations
    override var shouldAutorotate: Bool {
        if let topVC = self.topViewController {
            return topVC.shouldAutorotate
        }
        else {
            return super.shouldAutorotate
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if let topVC = self.topViewController {
            return topVC.supportedInterfaceOrientations
        }
        else {
            return super.supportedInterfaceOrientations
        }
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        if let topVC = self.topViewController {
            return topVC.preferredInterfaceOrientationForPresentation
        }
        else {
            return super.preferredInterfaceOrientationForPresentation
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if let topVC = self.topViewController {
            return topVC.preferredStatusBarStyle
        }
        else {
            return super.preferredStatusBarStyle
        }
    }
    
    override var childForStatusBarStyle: UIViewController? {
        return self.topViewController
    }
    
    // MARK: - init
    
    
    // MARK: - utils
    
    
    // MARK: - action
    
    
    // MARK: - other
    
    
}
