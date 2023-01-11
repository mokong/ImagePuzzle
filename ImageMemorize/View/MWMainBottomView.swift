//
//  MWMainBottomView.swift
//  ImageMemorize
//
//  Created by Horizon on 28/12/2022.
//

import UIKit

class MWMainBottomView: UIView {

    // MARK: - properties
    var tappedCallback: ((Int) -> Void)?
    var panCallback: ((UIView) -> Void)?
    
    private lazy var backView = UIView(frame: CGRect.zero)
    private let kMaxInRow: Int = 5
    let kTagBeginValue: Int = 1100
    private var initialCenter: CGPoint = .zero
    var isTintEnabled: Bool = false
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupSubviews() {
        isUserInteractionEnabled = true
        backView.isUserInteractionEnabled = true
        
        addSubview(backView)
        
        backView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - utils
    func updateSubviews(with divideCount: Int, itemList: [MWMainBottomItem]) {
        backView.removeAllSubviews()
        
        let remainNum = divideCount % kMaxInRow
        
        // total column
        var column = divideCount / kMaxInRow
        if remainNum > 0 {
            column += 1
        }
        
        var topSpace: CGFloat = 0.0
        let gapSpace = 10.0
        let whValue: CGFloat = (kScreenWidth - CGFloat(kMaxInRow + 1) * gapSpace) / CGFloat(kMaxInRow)
        var leftSpace = 0.0
        
        for i in 0..<column {
            var rowNum = kMaxInRow
            if i == column - 1 && remainNum != 0 {
                rowNum = remainNum
            }
            
            topSpace = CGFloat(i) * (gapSpace + whValue)
            for j in 0..<rowNum {
                leftSpace = gapSpace +  CGFloat(j) * (whValue + gapSpace)
                
                let singleView = MWMainBottomSingleView(frame: CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0))
                backView.addSubview(singleView)

                let currentIndex = i * kMaxInRow + j
                singleView.updateTag(kTagBeginValue + currentIndex)
                if currentIndex < itemList.count {
                    let item = itemList[currentIndex]
                    singleView.updateBackgrounImage(item.image, title: isTintEnabled ? "\(item.imageClipIndex + 1)" : nil)
                }
                singleView.tappedCallback = { [weak self] btn in
                    self?.handleBtnAction(btn)
                }
                singleView.panCallback = { [weak self] panGes in
                    self?.handlePan(panGes)
                }
                singleView.snp.makeConstraints { make in
                    make.leading.equalToSuperview().inset(leftSpace)
                    make.top.equalToSuperview().inset(topSpace)
                    make.width.height.equalTo(whValue)
                }
            }
        }
    }
    
    fileprivate func getTargetView(from index: Int) -> MWMainBottomSingleView? {
        for subview in backView.subviews {
            if let tempSingleView = subview as? MWMainBottomSingleView,
               tempSingleView.singleBtn.tag == kTagBeginValue + index {
                return tempSingleView
            }
        }
        return nil
    }
    
    func retrieveBack(with item: MWMainBottomItem) {
        guard let targetSingleView = getTargetView(from: item.displayIndex) else {
            return
        }
        targetSingleView.singleBtn.isHidden = false
        var frame = targetSingleView.singleBtn.frame
        frame.origin = CGPoint.zero
        UIView.animate(withDuration: 0.3, delay: 0, options: UIView.AnimationOptions.curveLinear) {
            targetSingleView.singleBtn.frame = frame
        }
    }
    
    func resetPanViewCenter(_ panView: UIView) {
        UIView.animate(withDuration: 0.5, delay: 0.0) {
            panView.center = self.initialCenter
        }
    }
    
    // MARK: - action
    @objc fileprivate func handleBtnAction(_ sender: UIButton) {
        let tagIndex = sender.tag - kTagBeginValue
        tappedCallback?(tagIndex)
    }
    
    @objc fileprivate func handlePan(_ sender: UIPanGestureRecognizer) {
        guard let panView = sender.view else {
            return
        }
        switch sender.state {
        case .began:
            initialCenter = panView.center
        case .changed:
            let translation = sender.translation(in: self.superview)
            panView.center = CGPoint(x: initialCenter.x + translation.x,
                                     y: initialCenter.y + translation.y)
        case .ended:
            panCallback?(panView)
        case .cancelled:
            resetPanViewCenter(panView)
        default:
            break
        }
    }
    
    // MARK: - other
    
}
