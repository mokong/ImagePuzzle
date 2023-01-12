//
//  ImagePuzzlePuzzleBaseNC.swift
//  ImageMemorize
//
//  Created by MorganWang on 27/12/2022.
//

import UIKit

class ImagePuzzlePuzzleBaseNC: UINavigationController {
    // MARK: - view life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let tempBtn = UIButton(type: UIButton.ButtonType.custom)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let tempLabel = UILabel()
        tempLabel.font = UIFont.custom.courierFont
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }

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
