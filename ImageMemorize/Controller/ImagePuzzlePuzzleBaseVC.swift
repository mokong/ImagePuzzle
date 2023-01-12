//
//  ImagePuzzlePuzzleBaseVC.swift
//  ImageMemorize
//
//  Created by MorganWang on 27/12/2022.
//

import UIKit

class ImagePuzzlePuzzleBaseVC: UIViewController {

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
        view.backgroundColor = UIColor.white
        navigationController?.navigationBar.tintColor = UIColor.white
        updateNavigationBarColor()
    }
    
    func updateNavigationBarColor() {
        guard let navigationBar = navigationController?.navigationBar else {
            return
        }
        
        if #available(iOS 13.0, *) {
            let barAppearance = UINavigationBarAppearance()
            barAppearance.backgroundColor = UIColor.custom.primary
            barAppearance.shadowColor = UIColor.clear
            barAppearance.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor: UIColor.white,
                NSAttributedString.Key.font: UIFont.custom.titleFont
            ]
            navigationBar.scrollEdgeAppearance = barAppearance
            navigationBar.standardAppearance = barAppearance
            navigationBar.shadowImage = UIImage()
        } else {
            // Fallback on earlier versions
            UINavigationBar.appearance().isTranslucent = false
            UINavigationBar.appearance().barTintColor = UIColor.custom.primary
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
