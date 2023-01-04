//
//  MWMainViewController.swift
//  ImageMemorize
//
//  Created by Horizon on 27/12/2022.
//

import UIKit
import SnapKit
import Darwin
import Toast_Swift

class MWMainViewController: MWPuzzleBaseVC {
    
    // MARK: - properties
    private(set) lazy var topModule = MWMainTopModule(self)
    private(set) lazy var puzzleModule = MWMainPuzzleModule(self)
    private(set) lazy var bottomModule = MWMainBottomModule(self)
    private(set) var displayImage: UIImage?
    
    private(set) var puzzleItems: [Int: MWMainPuzzleItem] = [:]
    private(set) var divideCount: Int = 9
    private(set) var matchCount: Int = 0
    
    // MARK: - view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "拼图"
        view.backgroundColor = UIColor.custom.puzzleBack2
        
        setupSubmodules()
        initData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        updateClipImageSizes()
    }
    
    // MARK: - init
    fileprivate func setupSubmodules() {
        topModule.install()
        puzzleModule.install()
        bottomModule.install()
    }
    
    fileprivate func initData() {
        displayImage = UIImage(named: "IMG_2361.JPG")
        
        topModule.initData()
        topModule.displayImage = displayImage
        
        puzzleModule.initData()
        
        bottomModule.initData()
    }
    
    // MARK: - utils
    func handelPanMove(_ pandView: UIView) {
        print(pandView.center)
        let convertRect = self.view.convert(pandView.frame, from: pandView.superview)
        var targetItem: MWMainPuzzleItem?
        for index in puzzleItems.keys {
            guard let item = puzzleItems[index], item.image == nil else {
                continue
            }
            let rect = item.imageRect
            if CGRectContainsRect(rect, convertRect) {
                print(rect)
                if let targetBtn = pandView as? UIButton {
                    item.image = targetBtn.currentImage
                    item.manualMatchAreaIndex = targetBtn.tag - bottomModule.view.kTagBeginValue
                }
                targetItem = item
                break
            }
        }
        if let targetItem = targetItem {
            // means pan ended frame in targetRect,
            // then display pan image in targetRect
            puzzleModule.updateSingleView(with: targetItem)
            matchCount += 1
        } else {
            // means not match
            bottomModule.view.resetPanViewCenter(pandView)
        }
        
        if matchCount == divideCount {
            // all image have been placed, then check their position
            checkImagePositionMatched()
        }
    }
    
    fileprivate func checkImagePositionMatched() {
        var allMatched = true
        for item in puzzleItems.values {
            if item.puzzleAreaIndex != item.manualMatchAreaIndex {
                allMatched = false
                break
            }
        }
        var msg: String = ""
        if !allMatched {
            // reset all views
            // Fixed-Me:
            msg = "失败，再次尝试吧"
        } else {
            // move to next level
            // Fixed-Me:
            msg = "恭喜，恭喜，干的漂亮"
        }
        
        if msg.count > 0 {
            view.makeToast(msg)
        }
        // resetTimer
        // if allMatched, then regenerate clip Image indexes, else just reset display
        // Fixed-Me:
        
    }
    
    // MARK: - action
    
    
    // MARK: - other
    fileprivate func updateClipImageSizes() {
        // get puzzle every piece of view frame
        for subImageView in puzzleModule.view.backView.subviews where subImageView.isKind(of: UIImageView.self) {
            // convert subimageView frame to VC.view coordinate
            let convertRect = self.view.convert(subImageView.frame, from: subImageView.superview)
            // save imageView rect and index to one item
            let tagIndex = subImageView.tag - puzzleModule.view.kTagBeginValue
            if let existItem = puzzleItems[tagIndex] {
                existItem.imageRect = convertRect
            } else {
                let item = MWMainPuzzleItem()
                item.imageRect = convertRect
                item.puzzleAreaIndex = tagIndex
                puzzleItems[tagIndex] = item
            }
        }
    }

    
}
