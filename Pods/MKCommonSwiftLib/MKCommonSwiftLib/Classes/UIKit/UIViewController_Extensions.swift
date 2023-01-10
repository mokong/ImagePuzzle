//
//  UIViewController_Extensions.swift
//  meijuplay
//
//  Created by Horizon on 22/12/2021.
//

import Foundation
import UIKit

extension UIViewController {
    public var topBarHeight: CGFloat {
        var top = self.navigationController?.navigationBar.frame.height ?? 0.0
        top += UIDevice.statusBarH()
        return top
    }
    
    
    public static func navBarColor() -> UIColor {
        return UIColor.custom.primary
    }

}
