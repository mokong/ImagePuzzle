//
//  ImagePuzzleMainPuzzleItem.swift
//  ImageMemorize
//
//  Created by MorganWang on 30/12/2022.
//

import Foundation
import UIKit

class ImagePuzzleMainPuzzleItem {
    var puzzleAreaIndex: Int = -99 // 第几块区域
    var imageRect: CGRect = CGRect.zero // 图片区域
    var image: UIImage? // 图片
    var manualMatchAreaIndex: Int = -1 // 手动匹配的区域
}
