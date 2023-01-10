//
//  MWSettingsCell.swift
//  ImageMemorize
//
//  Created by Horizon on 10/01/2023.
//

import UIKit

class MWSettingsCell: UITableViewCell {

    // MARK: - properties
    var switchValueChangedCallback: ((UISwitch) -> Void)?
    fileprivate lazy var titleLabel: UILabel = UILabel(frame: .zero)
    fileprivate lazy var rightImageView: UIImageView = UIImageView(image: UIImage(named: "icon_rightArrow"))
    fileprivate lazy var rightSwitch: UISwitch = UISwitch(frame: CGRect.zero)
    var showSwitch: Bool = false {
        didSet {
            rightSwitch.isHidden = !showSwitch
            rightImageView.isHidden = showSwitch
        }
    }
    
    // MARK: - init
    override func awakeFromNib() {
        super.awakeFromNib()
        setupSubviews()
        setupLayouts()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
        setupLayouts()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupSubviews() {
        contentView.backgroundColor = UIColor.custom.fifth
        
        titleLabel.font = UIFont.custom.normalFont
        titleLabel.textColor = UIColor.custom.primary
        contentView.addSubview(titleLabel)
        
        contentView.addSubview(rightImageView)
        
        rightSwitch.tintColor = UIColor.custom.primary
        rightSwitch.onTintColor = UIColor.custom.primary
        rightSwitch.isHidden = true
        rightSwitch.addTarget(self, action: #selector(handleSwitchAction(_:)), for: UIControl.Event.valueChanged)
        contentView.addSubview(rightSwitch)
    }
    
    fileprivate func setupLayouts() {
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(16.0)
        }
        rightImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(16.0)
            make.width.height.equalTo(16.0)
        }
        
        rightSwitch.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(16.0)
            make.width.equalTo(58.0)
        }
    }
    
    // MARK: - utils
    func update(_ text: String?) {
        titleLabel.text = text
    }
    
    // MARK: - action
    @objc fileprivate func handleSwitchAction(_ sender: UISwitch) {
        switchValueChangedCallback?(sender)
    }
    
    // MARK: - other
    class func reuseIdentifer() -> String {
        return "MWSettingsCell"
    }

}
