//
//  ImagePuzzleMainBigImagePreview.swift
//  ImageMemorize
//
//  Created by MorganWang on 12/01/2023.
//

import UIKit

class ImagePuzzleMainBigImagePreview: UIView {

    // MARK: - properties
    var backTapCallback: (() -> Void)?
    lazy var displayImageView: UIImageView = UIImageView(frame: self.bounds)
    
    var displayImage: UIImage? {
        didSet {
            displayImageView.image = displayImage
        }
    }
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupSubviews() {
        isUserInteractionEnabled = true
        backgroundColor = UIColor.clear
                
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(handleBackTap))
        addGestureRecognizer(tapGes)

        addSubview(displayImageView)
    }
    
    fileprivate func setupLayouts() {
        displayImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.equalToSuperview().inset(21.0)
        }
    }
    
    // MARK: - utils
    
    
    // MARK: - action
    @objc fileprivate func handleBackTap() {
        backTapCallback?()
    }
    
    // MARK: - other
    
}
