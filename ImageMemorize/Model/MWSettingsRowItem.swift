//
//  MWSettingsRowItem.swift
//  ImageMemorize
//
//  Created by Horizon on 10/01/2023.
//

import Foundation

struct MWSettingsRowItem {
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
        return MWPuzzleConst.isEnableTint()
    }
    
    static func settingsList() -> [MWSettingsRowItem] {
        let typeList: [ItemType] = [.degreeOfDiffculty, .customImage, .recommendApps, .privacy]
        var itemList: [MWSettingsRowItem] = []
        for tempType in typeList {
            let item = MWSettingsRowItem(type: tempType)
            itemList.append(item)
        }
        return itemList
    }
}
