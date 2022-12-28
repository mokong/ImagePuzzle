//
//  Data_Extension.swift
//  ToDoForOthers
//
//  Created by Horizon on 15/1/2022.
//

import Foundation
import CommonCrypto

extension Array {
    public init(reserveCapacity: Int) {
        self = Array<Element>()
        self.reserveCapacity(reserveCapacity)
    }
    
    var slice: ArraySlice<Element> {
        return self[self.startIndex ..< self.endIndex]
    }
}

extension Array where Element == UInt8 {
    public init(hex: String) {
        self.init(reserveCapacity: hex.unicodeScalars.lazy.underestimatedCount)
        var buffer: UInt8?
        var skip = hex.hasPrefix("0x") ? 2 : 0
        for char in hex.unicodeScalars.lazy {
            guard skip == 0 else {
                skip -= 1
                continue
            }
            guard char.value >= 48 && char.value <= 102 else {
                removeAll()
                return
            }
            let v: UInt8
            let c: UInt8 = UInt8(char.value)
            switch c {
            case let c where c <= 57:
                v = c - 48
            case let c where c >= 65 && c <= 70:
                v = c - 55
            case let c where c >= 97:
                v = c - 87
            default:
                removeAll()
                return
            }
            if let b = buffer {
                append(b << 4 | v)
                buffer = nil
            } else {
                buffer = v
            }
        }
        if let b = buffer {
            append(b)
        }
    }
    
    public func toHexString() -> String {
        return `lazy`.reduce("") {
            var s = String($1, radix: 16)
            if s.count == 1 {
                s = "0" + s
            }
            return $0 + s
        }
    }
}

extension Data {
    public init(hex: String) {
        self.init(Array<UInt8>(hex: hex))
    }
    public var bytes: Array<UInt8> {
        return Array(self)
    }
    public func toHexString() -> String {
        return bytes.toHexString()
    }
    
    /// AES 解密  字符串本身是加密后的字符
    ///
    /// - Parameters:
    ///   - key: key
    ///   - iv: 密钥
    /// - Returns: 解密后的字符
    func aesDecrypt(key:String,iv:String?,algorithm:CCAlgorithm = CCAlgorithm(kCCAlgorithmAES)) -> String? {
        guard let decryptedData = aescrypt(key: key, iv: iv, operation: CCOperation(kCCDecrypt),algorithm: algorithm) else { return nil }
        return String.init(data: decryptedData, encoding: .utf8)
    }
    
    ///  AES 加密
    ///
    /// - Parameters:
    ///   - key: 加密密钥
    ///   - iv:  加密算法、默认的 AES/DES
    ///   - operation: CCOperation(kCCEncrypt) CCOperation(kCCDecrypt)
    ///   - algorithm: CCAlgorithm
    /// - Returns: 计算的结果
    func aescrypt(key:String,iv:String?,operation: CCOperation,algorithm:CCAlgorithm = CCAlgorithm(kCCAlgorithmAES)) -> Data? {
        
        guard key.count == kCCKeySizeAES128 || key.count == kCCKeySizeAES256,let keyData = key.data(using: .utf8) else {
            debugPrint("Error: Failed to set a key.")
            return nil
        }
        
        var options = CCOptions(kCCOptionPKCS7Padding)
        if iv != nil{
            options = CCOptions(kCCOptionPKCS7Padding)//CBC 加密！
        }else{
            options = CCOptions(kCCOptionPKCS7Padding|kCCOptionECBMode)//ECB加密！
        }
        
        let ivData = iv?.data(using: .utf8)
        
        //key
        let keyBytes = keyData.bytes
        let keyLength = [UInt8](repeating: 0, count: key.count).count
        
        //data(input) 要加密的数据（指针）
        let dateBytes = self.bytes
        let dataLength = self.count
        
        //data(output) 加密后的数据（指针）
        var cryptData = Data(count: dataLength + Int(kCCBlockSizeAES128))
        let cryptLength = cryptData.count
        
        //iv
        let ivBytes = ivData?.bytes
        var bytesDecrypted: size_t = 0
        
        let status = cryptData.withUnsafeMutableBytes { (cryptBytes) -> Int32 in
            let cryptBytesBuffterPointer = cryptBytes.bindMemory(to: UInt8.self)
            guard let cryptBytesAddress = cryptBytesBuffterPointer.baseAddress else {
                return Int32(kCCParamError)
            }
            return CCCrypt(operation, algorithm, options, keyBytes, keyLength, ivBytes, dateBytes, dataLength, cryptBytesAddress, cryptLength, &bytesDecrypted)
        }
        
        
        guard Int32(status) == Int32(kCCSuccess) else {
            debugPrint("Error: Failed to crypt data. Status \(status)")
            return nil
        }
        cryptData.removeSubrange(bytesDecrypted..<cryptData.count)
        return cryptData
    }
}
