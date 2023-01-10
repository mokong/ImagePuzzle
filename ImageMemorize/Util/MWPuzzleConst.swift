//
//  MWPuzzleConst.swift
//  ImageMemorize
//
//  Created by Horizon on 28/12/2022.
//

import Foundation
import UIKit

let kScreenWidth = UIScreen.main.bounds.size.width
let kScreenHeigt = UIScreen.main.bounds.size.height

let kEnableTintKey = "kEnableTintKey"
let kRefreshMainVCNote = "kRefreshMainVCNote"

struct MWPuzzleConst {
    static func isEnableTint() -> Bool {
        var result = false
        if let value = UserDefaults.standard.value(forKey: kEnableTintKey) as? Bool {
            result = value
        }
        return result
    }
    
    static func saveEnableTint(_ value: Bool) {
        UserDefaults.standard.setValue(value, forKey: kEnableTintKey)
        UserDefaults.standard.synchronize()
    }
}
