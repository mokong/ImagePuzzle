//
//  ImagePuzzleSettingsRowItem.swift
//  ImageMemorize
//
//  Created by MorganWang on 10/01/2023.
//

import Foundation

struct ImagePuzzleSettingsRowItem {
    enum ItemType: String {
        case degreeOfDiffculty = "提示开关"
        case customImage = "自定义图片"
        case recommendApps = "分享给他人"
        case privacy = "隐私政策"
    }
    
    var type: ItemType = .degreeOfDiffculty
    
    var showSwitch: Bool {
        return type == .degreeOfDiffculty
    }
    
    var isSwitchOn: Bool {
        return ImagePuzzleConst.isEnableTint()
    }
    
    static func settingsList() -> [ImagePuzzleSettingsRowItem] {
        let typeList: [ItemType] = [.degreeOfDiffculty, .recommendApps, .privacy]
        var itemList: [ImagePuzzleSettingsRowItem] = []
        for tempType in typeList {
            let item = ImagePuzzleSettingsRowItem(type: tempType)
            itemList.append(item)
        }
        return itemList
    }
}
