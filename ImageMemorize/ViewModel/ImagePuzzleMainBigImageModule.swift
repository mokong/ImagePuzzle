//
//  ImagePuzzleMainBigImageModule.swift
//  ImageMemorize
//
//  Created by MorganWang on 12/01/2023.
//

import Foundation
import UIKit

class ImagePuzzleMainBigImageModule {
    // MARK: - properties
    private(set) weak var vc: ImagePuzzleMainViewController?
    private(set) lazy var view = ImagePuzzleMainBigImagePreview(frame: .zero)
    private(set) lazy var alphaView = UIView(frame: CGRect.zero)
    
    // MARK: - init
    init(_ vc: ImagePuzzleMainViewController) {
        self.vc = vc
        
    }
    
    fileprivate func setupAlphaView() {
        guard let vc = vc else { return }
        alphaView.backgroundColor = UIColor.black
        alphaView.alpha = 0.6
        alphaView.frame = vc.view.frame
        alphaView.isUserInteractionEnabled = true
        vc.view.addSubview(alphaView)
    }
    
    // MARK: - utils
    func show() {
        guard let vc = vc else { return }
        setupAlphaView()
        
        vc.view.addSubview(view)
        view.backTapCallback = { [weak self] in
            self?.hide()
        }
        view.displayImage = vc.displayImage
        view.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.view.alpha = 0.0
        UIView.animate(withDuration: 0.2) {
            self.view.alpha = 1.0
        }
    }
    
    func hide() {
        
        UIView.animate(withDuration: 0.1) {
            self.view.alpha = 0.0
        } completion: { finished in
            if finished {
                self.view.removeFromSuperview()
                self.alphaView.removeFromSuperview()
            }
        }
    }

    
    // MARK: - action
    
    // MARK: - other
    
}
