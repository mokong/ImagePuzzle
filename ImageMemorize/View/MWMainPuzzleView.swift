//
//  MWMainPuzzleView.swift
//  ImageMemorize
//
//  Created by Horizon on 28/12/2022.
//

import UIKit
import Darwin
import MKCommonSwiftLib

class MWMainPuzzleView: UIView {

    // MARK: - properties
    private(set) lazy var backView: UIView = UIView(frame: CGRect.zero)
    let kTagBeginValue: Int = 0
    
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
        backView.backgroundColor = UIColor.custom.second
        addSubview(backView)
        backView.layer.borderWidth = 2.0
        backView.layer.borderColor = UIColor.custom.fourth.cgColor
        
        backView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - utils
    func update(with dividedCount: Int) {
        backView.removeAllSubviews()
        
        let row = sqrt(Double(dividedCount))
        let rowInt = Int(row)
        let width = (kScreenWidth - 60.0) / row
        
        var leftSpace: CGFloat = 0.0
        var topSpace: CGFloat = 0.0

        for index in 0..<dividedCount {
            let rowCount = index % rowInt
            let columnCount = index / rowInt
            
            leftSpace = width * CGFloat(rowCount)
            topSpace = width * CGFloat(columnCount)
            
            let tempImageView = UIImageView()
            backView.addSubview(tempImageView)
            tempImageView.tag = kTagBeginValue + index
            
            tempImageView.backgroundColor = UIColor.custom.second
            tempImageView.contentMode = .scaleToFill
            tempImageView.layer.borderColor = UIColor.custom.fourth.cgColor
            tempImageView.layer.borderWidth = 1.0
            tempImageView.snp.makeConstraints { make in
                make.leading.equalToSuperview().inset(leftSpace)
                make.top.equalToSuperview().inset(topSpace)
                make.width.height.equalTo(width)
                if index == dividedCount - 1 {
                    make.bottom.equalToSuperview()
                }
            }
        }
    }
    
    func updateSingleView(with item: MWMainPuzzleItem) {
        // get targetView from singleIndex
        for subView in backView.subviews  {
            if let subImageView = subView as? UIImageView,
                subImageView.tag == kTagBeginValue + item.puzzleAreaIndex {
                subImageView.image = item.image
                subImageView.contentMode = .scaleToFill
            }
        }
    }

    // MARK: - action
    
    
    // MARK: - other
    
    
}
