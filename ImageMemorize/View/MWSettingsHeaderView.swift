//
//  MWSettingsHeaderView.swift
//  ImageMemorize
//
//  Created by Horizon on 10/01/2023.
//

import UIKit

class MWSettingsHeaderView: UIView {

    // MARK: - properties
    fileprivate lazy var displayImageView = UIImageView(image: UIImage(named: "icon_launch"))
    fileprivate lazy var displayLabel = UILabel()
    
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
        addSubview(displayImageView)
        
        addSubview(displayLabel)
        if let displayName = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String {
            displayLabel.text = displayName
        }
        displayLabel.font = UIFont.custom.titleFont
        displayLabel.textColor = UIColor.custom.primary
    }
    
    fileprivate func setupLayouts() {
        displayImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(6.0)
            make.top.equalToSuperview().inset(27.0)
            make.width.height.equalTo(100.0)
        }
        
        displayLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(displayImageView.snp.bottom).inset(-10.0)
        }
    }
    
    // MARK: - utils
    
    
    // MARK: - action
    
    
    // MARK: - other
    
    
}
