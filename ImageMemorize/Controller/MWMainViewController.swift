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
    private(set) var displayImage: UIImage? {
        didSet {
            generateBottomItemList()
            generateClipImageNewSequenceList()
        }
    }
    
    private(set) var puzzleItems: [Int: MWMainPuzzleItem] = [:]
    private(set) var divideCount: Int = 9
    private(set) var matchCount: Int = 0
    private(set) var bottomDataList: [MWMainBottomItem] = []
    var clipImageSequenceList: [MWMainBottomItem] = []
    
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
                    let index = targetBtn.tag - bottomModule.view.kTagBeginValue
                    let bottomItem = clipImageSequenceList[index]
                    item.manualMatchAreaIndex = bottomItem.imageClipIndex
                    item.image = bottomItem.image
                    targetBtn.isHidden = true
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
        
        // clear puzzleItems
        puzzleItems = [:]
        
        var msg: String = ""
        if !allMatched {
            // reset all views
            msg = "失败，再次尝试吧"
            showErrorAlert()
            doesnotMatchResetDisplay()
        } else {
            // move to next level
            msg = "恭喜，恭喜，干的漂亮"
            showSuccessAlert()
            displayNewImageOrSequenceMatch()
        }
        
        if msg.count > 0 {
            view.makeToast(msg, duration: 0.3)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.matchCount = 0
            if !allMatched {
                self.doesnotMatchResetDisplay()
            } else {
                // move to next level
                self.displayNewImageOrSequenceMatch()
                // resetTimer
                self.topModule.resetTimer()
            }
        }
    }
    
    fileprivate func showErrorAlert() {

    }
    
    fileprivate func showSuccessAlert() {

    }
    
    fileprivate func doesnotMatchResetDisplay() {
        // Fixed-Me:
        // 1. clear all image on puzzle view
        // 2. reset all button on bottom view remain the same sequence
        puzzleModule.resetData()
        let itemList = self.clipImageSequenceList
        bottomModule.resetData(with: itemList)
    }
    
    fileprivate func displayNewImageOrSequenceMatch() {
        // Fixed-Me:
        // 1. clear all image on puzzle view
        // 2. generate new image or not
        // 3. reset all button on bottom view, regenerate new sequence
        puzzleModule.resetData()
        displayImage = UIImage(named: "")
        generateClipImageNewSequenceList()
        bottomModule.resetData(with: clipImageSequenceList)
    }
    
    fileprivate func generateClipImageNewSequenceList() {
        let randomList = createRandomMan(0, end: divideCount)
        if randomList.count != bottomDataList.count {
            print("generateClipImageNewSequenceList failed")
            return
        }
        self.clipImageSequenceList = []
        for i in randomList {
            clipImageSequenceList.append(bottomDataList[i])
        }
    }
    
    fileprivate func generateBottomItemList() {
        guard let displayImage = displayImage else { return }

        bottomDataList = []
        // clip image to divide pieces in sequence
        let number = Int(sqrt(Double(divideCount)))
        let width = displayImage.size.width / CGFloat(number)
        let height = displayImage.size.height / CGFloat(number)
        for row in 0..<number {
            for column in 0..<number {
                let x = CGFloat(column) * width
                let y = CGFloat(row) * height
                let rect = CGRect(x: x, y: y, width: width, height: height)
                let image = displayImage.tailoring(in: rect)
                let bottomItem = MWMainBottomItem()
                bottomItem.image = image
                bottomItem.imageClipIndex = row * number + column
                print(bottomItem.imageClipIndex)
                bottomDataList.append(bottomItem)
            }
        }
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

    fileprivate func createRandomMan(_ start: Int, end: Int) -> [Int] {
        var nums: [Int] = []
        for i in start..<end {
            nums.append(i)
        }
        
        var resultList: [Int] = []
        while nums.count > 0 {
            let index = Int.random(in: 0..<nums.count)
            resultList.append(nums.remove(at: index))
        }
        return resultList
    }
    
}
