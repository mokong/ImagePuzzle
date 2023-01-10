//
//  MWMainPuzzleModule.swift
//  ImageMemorize
//
//  Created by Horizon on 27/12/2022.
//

import Foundation
import UIKit

class MWMainPuzzleModule {
    // MARK: - properties
    private(set) weak var vc: MWMainViewController?
    private(set) lazy var view = MWMainPuzzleView(frame: .zero)
    
    // MARK: - init
    init(_ vc: MWMainViewController) {
        self.vc = vc
        
        setupSubviews()
    }
    
    fileprivate func setupSubviews() {
        vc?.view.addSubview(view)
    }
    
    func install() {
        guard let vc = vc else { return }
        view.snp.makeConstraints { make in
            make.top.equalTo(vc.topModule.view.snp.bottom).offset(30.0)
            make.leading.trailing.equalToSuperview().inset(30.0)
        }
    }
    
    func initData() {
        guard let vc = vc else { return }
        view.update(with: vc.divideCount)
    }
    
    // MARK: - utils
    func updateSingleView(with item: MWMainPuzzleItem) {
        view.updateSingleView(with: item)
    }
    
    func resetData() {
        guard let vc = vc else { return }
        view.update(with: vc.divideCount)
    }
    
    // MARK: - action
    
    
    // MARK: - other
    
}
