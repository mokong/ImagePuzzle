//
//  ImagePuzzleMainPuzzleModule.swift
//  ImageMemorize
//
//  Created by MorganWang on 27/12/2022.
//

import Foundation
import UIKit

class ImagePuzzleMainPuzzleModule {
    // MARK: - properties
    private(set) weak var vc: ImagePuzzleMainViewController?
    private(set) lazy var view = ImagePuzzleMainPuzzleView(frame: .zero)
    
    // MARK: - init
    init(_ vc: ImagePuzzleMainViewController) {
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
    func updateSingleView(with item: ImagePuzzleMainPuzzleItem) {
        view.updateSingleView(with: item)
    }
    
    func retrieveBack(with puzzleIndex: Int) {
        view.retrieveBack(with: puzzleIndex)
    }
    
    func resetData() {
        guard let vc = vc else { return }
        view.update(with: vc.divideCount)
    }
    
    // MARK: - action
    
    
    // MARK: - other
    
}
