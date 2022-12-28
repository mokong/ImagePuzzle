//
//  UIView_Extensions.swift
//  CommonSwiftExtension
//
//  Created by Horizon on 17/05/2022.
//

import Foundation
import UIKit

public extension UIView {
    /// Remove all subviews
    func removeAllSubviews() {
        subviews.forEach({ $0.removeFromSuperview() })
    }
    
    public func snapshotImage() -> UIImage? {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            rendererContext.cgContext.setFillColor(UIColor.cyan.cgColor)
            rendererContext.cgContext.setStrokeColor(UIColor.yellow.cgColor)
            layer.render(in: rendererContext.cgContext)
        }
    }

    public func snapshotView() -> UIView? {
        if let snapshotImage = snapshotImage() {
            return UIImageView(image: snapshotImage)
        } else {
            return nil
        }
    }
}
