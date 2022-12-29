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
    
    private lazy var backView = UIView(frame: CGRect.zero)
    private let kMaxInRow: Int = 5
    private let kTagBeginValue: Int = 1100
    private var initialCenter: CGPoint = .zero
    
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
    func updateSubviews(with divideCount: Int) {
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
                let singleBtn = UIButton(type: UIButton.ButtonType.custom)
                backView.addSubview(singleBtn)
                singleBtn.backgroundColor = UIColor.orange
                singleBtn.tag = kTagBeginValue + i * kMaxInRow + j
                singleBtn.setTitle(String(format: "%ld", singleBtn.tag - kTagBeginValue), for: .normal)
                singleBtn.setTitleColor(UIColor.custom.whiteText, for: UIControl.State.normal)
                singleBtn.addTarget(self, action: #selector(handleBtnAction(_:)), for: .touchUpInside)
                let panGes = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
                singleBtn.addGestureRecognizer(panGes)
                
                singleBtn.snp.makeConstraints { make in
                    make.leading.equalToSuperview().inset(leftSpace)
                    make.top.equalToSuperview().inset(topSpace)
                    make.width.height.equalTo(whValue)
                }
            }
            
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
        case .ended,
                .cancelled:
            UIView.animate(withDuration: 0.5, delay: 0.0) {
                panView.center = self.initialCenter
            }
        default:
            break
        }
    }
    
    // MARK: - other
    
}
