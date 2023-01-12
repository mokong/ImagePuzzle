//
//  ImagePuzzleMainViewController.swift
//  ImageMemorize
//
//  Created by MorganWang on 27/12/2022.
//

import UIKit
import SnapKit
import Darwin
import Toast_Swift

class ImagePuzzleMainViewController: ImagePuzzlePuzzleBaseVC {
    
    // MARK: - properties
    private(set) lazy var topModule = ImagePuzzleMainTopModule(self)
    private(set) lazy var puzzleModule = ImagePuzzleMainPuzzleModule(self)
    private(set) lazy var bottomModule = ImagePuzzleMainBottomModule(self)
    private(set) lazy var previewModule = ImagePuzzleMainBigImageModule(self)
    
    private(set) var displayImage: UIImage? {
        didSet {
            generateBottomItemList()
            generateClipImageNewSequenceList()
            topModule.displayImage = displayImage
        }
    }
    
    private(set) var puzzleItems: [ImagePuzzleMainPuzzleItem] = []
    private(set) var divideCount: Int = 9
    private(set) var matchCount: Int = 0
    private(set) var matchSequenceList: [ImagePuzzleMainPuzzleItem] = []
    private(set) var bottomDataList: [ImagePuzzleMainBottomItem] = []
    private(set) var clipImageSequenceList: [ImagePuzzleMainBottomItem] = []
    private(set) var needRefresh = false
    private(set) var stepBackItem: UIBarButtonItem?
    
    // MARK: - view life cycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let tempLabel = UILabel()
        tempLabel.font = UIFont.custom.courierFont
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()


        // Do any additional setup after loading the view.
        self.title = "拼图"
        view.backgroundColor = UIColor.custom.third
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleNeedRefreshNote), name: NSNotification.Name(rawValue: kRefreshMainVCNote), object: nil)
        
        setupNavigationItems()
        setupSubmodules()
        initData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        topModule.restartTimer()
        if needRefresh {
            puzzleModule.resetData()
            bottomModule.resetData(with: clipImageSequenceList)
            needRefresh = false
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        topModule.pauseTimer()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        updateClipImageSizes()
    }
    
    // MARK: - init
    fileprivate func setupNavigationItems() {
        let rightNavItem = UIBarButtonItem(image: UIImage(named: "icon_set"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(handleSettingAction(_:)))
        navigationItem.rightBarButtonItem = rightNavItem
        
        stepBackItem = UIBarButtonItem(image: UIImage(named: "step_back"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(handleStepBack(_:)))
    }
    
    fileprivate func setupSubmodules() {
        topModule.install()
        puzzleModule.install()
        bottomModule.install()
    }
    
    fileprivate func initData() {
        displayImage = generateDisplayImage()
        
        topModule.initData()
        topModule.displayImage = displayImage
        
        puzzleModule.initData()
        
        bottomModule.initData()
    }
    
    // MARK: - utils
    func handelPanMove(_ pandView: UIView) {
        print(pandView.center)
        let convertRect = self.view.convert(pandView.frame, from: pandView.superview)
        var targetItem: ImagePuzzleMainPuzzleItem?
        
        for item in puzzleItems {
            guard item.image == nil else {
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
            matchSequenceList.append(targetItem)
            matchCount += 1
        } else {
            // means not match
            bottomModule.view.resetPanViewCenter(pandView)
        }
        
        if matchCount == divideCount {
            // all image have been placed, then check their position
            checkImagePositionMatched()
        }
        
        updateStepbackDisplay()
    }
    
    fileprivate func updateStepbackDisplay() {
        if matchCount > 0 {
            navigationItem.leftBarButtonItem = stepBackItem
        } else {
            navigationItem.leftBarButtonItem = nil
        }
    }
    
    fileprivate func checkImagePositionMatched() {
        var allMatched = true
        for item in puzzleItems {
            if item.puzzleAreaIndex != item.manualMatchAreaIndex {
                allMatched = false
                break
            }
        }
        
        // clear puzzleItems
        puzzleItems = []
        matchSequenceList = []
        
        var msg: String = ""
        if !allMatched {
            // reset all views
            msg = "失败，再次尝试吧"
            showErrorAlert()
        } else {
            // move to next level
            msg = "恭喜，恭喜，干的漂亮"
            showSuccessAlert()
        }
        
        let delayDuration = 1.1
        if msg.count > 0 {
            view.makeToast(msg, duration: delayDuration)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delayDuration) {
            self.matchCount = 0
            self.updateStepbackDisplay()
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
        // 1. clear all image on puzzle view
        // 2. reset all button on bottom view remain the same sequence
        puzzleModule.resetData()
        let itemList = self.clipImageSequenceList
        bottomModule.resetData(with: itemList)
    }
    
    fileprivate func displayNewImageOrSequenceMatch() {
        // 1. clear all image on puzzle view
        // 2. generate new image or not
        // 3. reset all button on bottom view, regenerate new sequence
        puzzleModule.resetData()
        displayImage = generateDisplayImage()
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
            let bottomItem = bottomDataList[i]
            bottomItem.displayIndex = clipImageSequenceList.count
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
                let bottomItem = ImagePuzzleMainBottomItem()
                bottomItem.image = image
                bottomItem.imageClipIndex = row * number + column
                print(bottomItem.imageClipIndex)
                bottomDataList.append(bottomItem)
            }
        }
    }
    
    // MARK: - action
    @objc fileprivate func handleSettingAction(_ sender: UIBarButtonItem) {
        let settingsVC = ImagePuzzleSettingsVC()
        navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    @objc fileprivate func handleNeedRefreshNote() {
        needRefresh = true
    }
    
    @objc fileprivate func handleStepBack(_ sender: UIBarButtonItem) {
        // matchCount > 0, can step back
        // puzzleItems pop last object by sequence
        // bottomView update display
        // puzzleView update display
        if matchCount <= 0 {
            return
        }
        matchCount -= 1
        guard let latestItem = matchSequenceList.popLast() else {
            return
        }
        puzzleModule.retrieveBack(with: latestItem.puzzleAreaIndex)

        for tempBottomItem in clipImageSequenceList {
            if tempBottomItem.image == latestItem.image {
                bottomModule.retrieveBack(with: tempBottomItem)
                break
            }
        }
        latestItem.image = nil
        updateStepbackDisplay()
    }
    
    // MARK: - other
    fileprivate func updateClipImageSizes() {
        // get puzzle every piece of view frame
        for subImageView in puzzleModule.view.backView.subviews where subImageView.isKind(of: UIImageView.self) {
            // convert subimageView frame to VC.view coordinate
            let convertRect = self.view.convert(subImageView.frame, from: subImageView.superview)
            // save imageView rect and index to one item
            let tagIndex = subImageView.tag - puzzleModule.view.kTagBeginValue
            let existItem = puzzleItems.first(where: { $0.puzzleAreaIndex == tagIndex })
            if let existItem = existItem {
                existItem.imageRect = convertRect
            } else {
                let item = ImagePuzzleMainPuzzleItem()
                item.imageRect = convertRect
                item.puzzleAreaIndex = tagIndex
                puzzleItems.append(item)
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
 
    fileprivate func generateDisplayImage() -> UIImage? {
        let imageNamePrefix = "placeholder_image_"
        let randomIndex = Int.random(in: 1...9)
        let imageName = imageNamePrefix + "\(randomIndex)"
        return UIImage(named: imageName)
    }
}
