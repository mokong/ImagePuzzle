//
//  MWMainBottomSingleView.swift
//  ImageMemorize
//
//  Created by Horizon on 10/01/2023.
//

import UIKit

class MWMainBottomSingleView: UIView {

    // MARK: - properties
    var tappedCallback: ((UIButton) -> Void)?
    var panCallback: ((UIPanGestureRecognizer) -> Void)?
    fileprivate lazy var singleBtn = UIButton(type: UIButton.ButtonType.custom)

    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupSubviews() {
        backgroundColor = UIColor.custom.second
//        layer.borderColor = UIColor.custom.fourth.cgColor
//        layer.borderWidth = 1.5
        
        addSubview(singleBtn)
        singleBtn.setTitleColor(UIColor.custom.whiteText, for: UIControl.State.normal)
        singleBtn.addTarget(self, action: #selector(handleBtnAction(_:)), for: .touchUpInside)
        let panGes = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        singleBtn.addGestureRecognizer(panGes)
        
        singleBtn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - utils
    func updateTag(_ tagValue: Int) {
        singleBtn.tag = tagValue
    }
    
    func updateBackgrounImage(_ image: UIImage?, title: String?) {
        singleBtn.setBackgroundImage(image, for: .normal)
        singleBtn.setTitle(title, for: .normal)
    }
    
    // MARK: - action
    @objc fileprivate func handleBtnAction(_ sender: UIButton) {
        tappedCallback?(sender)
    }
    
    @objc fileprivate func handlePan(_ sender: UIPanGestureRecognizer) {
        panCallback?(sender)
    }
    
    // MARK: - other
    
    
}
