//
//  MWMainViewController.swift
//  ImageMemorize
//
//  Created by Horizon on 27/12/2022.
//

import UIKit
import SnapKit
import Darwin

class MWMainViewController: MWPuzzleBaseVC {
    
    // MARK: - properties
    private(set) lazy var topModule = MWMainTopModule(self)
    private(set) lazy var puzzleModule = MWMainPuzzleModule(self)
    private(set) lazy var bottomModule = MWMainBottomModule(self)
    private(set) var displayImage: UIImage? {
        didSet {
            updateClipImageSizes()
        }
    }
    private(set) var clipImageSizes: [CGRect] = []
    private(set) var divideCount: Int = 9
    
    // MARK: - view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "拼图"
        view.backgroundColor = UIColor.custom.puzzleBack2
        
        setupSubmodules()
        initData()
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
    
    
    // MARK: - action
    
    
    // MARK: - other
    fileprivate func updateClipImageSizes() {
        if let displayImage = displayImage {
            clipImageSizes = []
            let rowCount = sqrt(Double(divideCount))
            let width = displayImage.size.width / rowCount
            let height = displayImage.size.height / rowCount
            let rowInt = Int(rowCount)
            for i in 0..<rowInt {
                for j in 0..<rowInt {
                    let rect = CGRect(x: CGFloat(i) * width, y: CGFloat(j) * height, width: width, height: height)
                    clipImageSizes.append(rect)
                }
            }
        }
    }

    
}
