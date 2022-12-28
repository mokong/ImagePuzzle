//
//  UIDevice_Extensions.swift
//  ImageMemorize
//
//  Created by Horizon on 27/12/2022.
//

import Foundation
import UIKit
import AVFoundation
import Photos

public extension UIDevice {
    /// 底部 safeArea 高度
    static func topSafeAreaHeight() -> CGFloat {
        if #available(iOS 11.0, *) {
            if let window = UIApplication.shared.delegate?.window,
                let height = window?.safeAreaInsets.top,
                height > 0 {
                return height
            }
            else {
                return 0.0
            }
        } else {
            // Fallback on earlier versions
            return 0.0
        }
    }
    
    /// 底部 safeArea 高度
    static func bottomSafeAreaHeight() -> CGFloat {
        if #available(iOS 11.0, *) {
            if let window = UIApplication.shared.delegate?.window,
                let height = window?.safeAreaInsets.bottom,
                height > 0 {
                return height
            }
            else {
                return 0.0
            }
        } else {
            // Fallback on earlier versions
            return 0.0
        }
    }
    
    /// 不准确的导航栏高度
    static func navigationBarH() -> CGFloat {
        if isFullScreen() {
            return 88.0
        }
        else {
            return 64.0
        }
    }
    
    /// 是否是全面屏
    static func isFullScreen() -> Bool {
        if #available(iOS 11.0, *) {
            if let window = UIApplication.shared.delegate?.window,
                let height = window?.safeAreaInsets.bottom,
                height > 0 {
                return true
            }
            else {
                return false
            }
        } else {
            // Fallback on earlier versions
            return false
        }
    }
    
    /// 状态栏高度
    static func statusBarH() -> CGFloat {
        var height: CGFloat = 0.0
        if #available(iOS 13.0, *) {
            height = UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            height = UIApplication.shared.statusBarFrame.height
        }
        return height
    }
    
    class func grantedPhotoAuthorization(completion: ((Bool) -> Void)?) {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .denied:
            completion?(false)
        case .restricted:
            completion?(false)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { status in
                if status == .authorized {
                    completion?(true)
                }
                else {
                    completion?(false)
                }
            }
        case .authorized:
            completion?(true)
        default:
            completion?(false)
        }
    }
    
    class func cameraAuthorization(_ granted: ((Bool) -> Void)?) {
        grantedCameraAuthorization(from: AVMediaType.video, completion: granted)
    }
    
    class func noAuthHandle(with msg: String, on vc: UIViewController) {
        let alert = UIAlertController(title: "提示", message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "确定", style: UIAlertAction.Style.default, handler: { action in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
        }))
        DispatchQueue.main.async {
            vc.present(alert, animated: true, completion: nil)
        }
    }
    
    class func grantedCameraAuthorization(from type: AVMediaType, completion: ((Bool) -> Void)?) {
        let authStatus = AVCaptureDevice.authorizationStatus(for: type)
        switch authStatus {
        case .denied:
            // 用户禁止
            completion?(false)
        case .notDetermined:
            // 尚未授权
            AVCaptureDevice.requestAccess(for: type) { granted in
                completion?(granted)
            }
        case .authorized:
            completion?(true)
        default:
            completion?(false)
        }
    }
    
    var appVersion: String {
        let infoDic = Bundle.main.infoDictionary
        let appVersion = (infoDic?["CFBundleShortVersionString"] as? String) ?? ""
        return appVersion
    }

    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }

        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
            
        case "iPhone8,4":                           return "iPhone SE"
        case "iPhone9,1":                           return "iPhone 7"
        case "iPhone9,2":                           return "iPhone 7 Plus"
        case "iPhone9,3":                           return "iPhone 7"
        case "iPhone9,4":                           return "iPhone 7 Plus"
        case "iPhone10,1":                              return "iPhone 8"
        case "iPhone10,2":                              return "iPhone 8 Plus"
        case "iPhone10,4":                              return "iPhone 8"
        case "iPhone10,5":                              return "iPhone 8 Plus"
        case "iPhone10,3":                              return "iPhone X"
        case "iPhone10,6":                              return "iPhone X"
        case "iPhone11,2":                              return "iPhone XS"
        case "iPhone11,4":                              return "iPhone XS Max"
        case "iPhone11,6":                              return "iPhone XS Max"
        case "iPhone11,8":                              return "iPhone XR"
        case "iPhone12,1":                              return "iPhone 11"
        case "iPhone12,3":                              return "iPhone 11 Pro"
        case "iPhone12,5":                              return "iPhone 11 Pro Max"
        case "iPhone12,8":                              return "iPhone SE 2"
        case "iPhone13,1":                              return "iPhone 12 mini"
        case "iPhone13,2":                              return "iPhone 12"
        case "iPhone13,3":                              return "iPhone 12 Pro"
        case "iPhone13,4":                              return "iPhone 12 Pro Max"
        case "iPhone14,4":                              return "iPhone 13 mini"
        case "iPhone14,5":                              return "iPhone 13"
        case "iPhone14,2":                              return "iPhone 13 Pro"
        case "iPhone14,3":                              return "iPhone 13 Pro Max"
        case "iPhone14,6": return "iPhone SE 3"
        case "iPhone14,7": return "iPhone 14"
        case "iPhone14,8": return "iPhone 14 Plus"
        case "iPhone15,2": return "iPhone 14 Pro"
        case "iPhone15,3": return "iPhone 14 Pro Max"
            
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,7", "iPad6,8":                      return "iPad Pro"
        case "AppleTV5,3":                              return "Apple TV"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
}
