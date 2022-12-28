//
//  MWMainBottomModule.swift
//  ImageMemorize
//
//  Created by Horizon on 27/12/2022.
//

import Foundation
import UIKit

class MWMainBottomModule {
    // MARK: - properties
    private(set) weak var vc: MWMainViewController?
    private(set) lazy var view = UIView(frame: .zero)
    
    // MARK: - init
    init(_ vc: MWMainViewController) {
        self.vc = vc
        
        setupSubviews()
    }
    
    fileprivate func setupSubviews() {
        vc?.view.addSubview(view)
    }
    
    func install() {
        
    }
    
    func initData() {
        
    }
    
    // MARK: - utils
    
    
    // MARK: - action
    
    
    // MARK: - other
    
}
