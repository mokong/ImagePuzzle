//
//  ImagePuzzleMainBottomModule.swift
//  ImageMemorize
//
//  Created by MorganWang on 27/12/2022.
//

import Foundation
import UIKit

class ImagePuzzleMainBottomModule {
    // MARK: - properties
    private(set) weak var vc: ImagePuzzleMainViewController?
    private(set) lazy var view = ImagePuzzleMainBottomView(frame: .zero)
    
    // MARK: - init
    init(_ vc: ImagePuzzleMainViewController) {
        self.vc = vc
        
        setupSubviews()
    }
    
    fileprivate func setupSubviews() {
        let isTintEnabled = ImagePuzzleConst.isEnableTint()
        view.isTintEnabled = isTintEnabled
        vc?.view.addSubview(view)
        
        view.tappedCallback = { [weak self] index in
            self?.handleTapItem(index)
        }
        
        view.panCallback = { [weak self] panView in
            self?.vc?.handelPanMove(panView)
        }
    }
    
    func install() {
        guard let vc = vc else { return }
        view.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(vc.puzzleModule.view.snp.bottom).offset(20.0)
        }
    }
    
    func initData() {
        guard let vc = vc else { return }

        view.updateSubviews(with: vc.divideCount, itemList: vc.clipImageSequenceList)
    }
    
    func resetData(with itemList: [ImagePuzzleMainBottomItem]) {
        let isTintEnabled = ImagePuzzleConst.isEnableTint()
        view.isTintEnabled = isTintEnabled

        guard let vc = vc else { return }
        view.updateSubviews(with: vc.divideCount, itemList: itemList)
    }
    
    func retrieveBack(with item: ImagePuzzleMainBottomItem) {
        view.retrieveBack(with: item)
    }
    
    // MARK: - utils
    
    
    // MARK: - action
    fileprivate func handleTapItem(_ index: Int) {
        
    }
    
    // MARK: - other
    
}
