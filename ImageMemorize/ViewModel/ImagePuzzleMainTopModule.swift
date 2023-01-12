//
//  ImagePuzzleMainTopModule.swift
//  ImageMemorize
//
//  Created by MorganWang on 27/12/2022.
//

import Foundation
import UIKit
import MKCommonSwiftLib

class ImagePuzzleMainTopModule {
    // MARK: - properties
    private(set) weak var vc: ImagePuzzleMainViewController?
    private(set) lazy var view = ImagePuzzleMainTopView(frame: .zero)
    private(set) var timer: Timer?
    private(set) var count: Int = 0
    
    var displayImage: UIImage? {
        didSet {
            view.fullImage = displayImage
        }
    }
    
    // MARK: - init
    init(_ vc: ImagePuzzleMainViewController) {
        self.vc = vc
        
        setupSubviews()
    }
    
    fileprivate func setupSubviews() {
        vc?.view.addSubview(view)
        
        view.fullImageTapCallback = { [weak self] in
            self?.handleFullImagePreview()
        }
    }
    
    func install() {
        guard let vc = vc else { return }
        let topSpace = vc.topBarHeight + 20.0
        view.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(topSpace)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(74.0)
        }
    }
    
    func initData() {        
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(handleTimeAdd), userInfo: nil, repeats: true)
        }
        RunLoop.main.add(timer!, forMode: RunLoop.Mode.common)
        timer?.fire()
    }
    
    // MARK: - utils
    func pauseTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func restartTimer() {
        initData()
    }
    
    func resetTimer() {
        count = 0
        timer?.invalidate()
        timer = nil
        initData()
    }
    
    // MARK: - action
    @objc fileprivate func handleTimeAdd() {
        count += 1
        
        let seconds = count % 60
        let minute = count / 60
        let secondsStr = getTimeDisplayStr(seconds)
        let minuteStr = getTimeDisplayStr(minute)
        view.btnText = minuteStr + ":" + secondsStr
    }
    
    fileprivate func handleFullImagePreview() {
        vc?.previewModule.show()
    }
    
    // MARK: - other
    fileprivate func getTimeDisplayStr(_ value: Int) -> String {
        if value < 10 {
            return String(format: "0%ld", value)
        } else {
            return String(format: "%ld", value)
        }
    }
    
}
