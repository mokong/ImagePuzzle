//
//  MWMainTopView.swift
//  ImageMemorize
//
//  Created by Horizon on 27/12/2022.
//

import UIKit
import SnapKit

class MWMainTopView: UIView {

    // MARK: - properties
    private lazy var timeBtn = UIButton(type: UIButton.ButtonType.custom)
    private lazy var fullImageView = UIImageView(frame: .zero)
    
    var fullImage: UIImage? {
        didSet {
            fullImageView.image = fullImage
            guard let image = fullImage else {
                return
            }
            let imageWHRatio = image.size.width / image.size.height
            let imageH = 70.0
            let imageW = imageH * imageWHRatio
            fullImageView.snp.remakeConstraints { make in
                make.centerY.equalToSuperview()
                make.trailing.equalToSuperview().inset(40.0)
                make.height.equalTo(imageH)
                make.width.equalTo(imageW)
            }
        }
    }
    
    var btnText: String? {
        didSet {
            timeBtn.setTitle(btnText, for: .normal)
        }
    }
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupSubviews() {
        setupTimeBtn()
        setupFullImageView()
    }
    
    fileprivate func setupTimeBtn() {
        timeBtn.titleLabel?.font = UIFont.custom.courierMediumFont
        timeBtn.setTitleColor(UIColor.custom.primary, for: UIControl.State.normal)
        addSubview(timeBtn)
        let kTimeBtnH: CGFloat = 32.0
        timeBtn.layer.cornerRadius = kTimeBtnH / 2.0
        timeBtn.layer.borderWidth = 1.5
        timeBtn.layer.borderColor = UIColor.custom.primary.cgColor
        
        timeBtn.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(32.0)
            make.height.equalTo(kTimeBtnH)
            make.width.equalTo(78.0)
            make.centerY.equalToSuperview()
        }
    }
    
    fileprivate func setupFullImageView() {
        addSubview(fullImageView)
        
        fullImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(40.0)
            make.height.equalTo(60.0)
        }
    }
    
    
    // MARK: - utils
    
    
    // MARK: - action
    
    
    // MARK: - other
    
    
}
