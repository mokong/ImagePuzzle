//
//  MWPuzzleBaseVC.swift
//  ImageMemorize
//
//  Created by Horizon on 27/12/2022.
//

import UIKit

class MWPuzzleBaseVC: UIViewController {

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
