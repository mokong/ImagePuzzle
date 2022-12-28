//
//  JSONEncoder_Extensions.swift
//  AccountForOthers
//
//  Created by Horizon on 28/05/2022.
//

import Foundation

// Base解析失败原因
public
enum BaseParseError: Error {
    case emptyResponse
    case failedDecoder
}

public
extension JSONDecoder {
    static func transToModel<T: Codable>(_ jsonObj: Any, keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .convertToCamelCase) -> (T?, BaseParseError?) {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonObj)
            return transToModelWithData(jsonData)
        } catch {
            print(error.localizedDescription)
            return (nil, BaseParseError.failedDecoder)
        }
    }
    
    static func transToModel<T: Codable>(_ json: String?, keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .convertToCamelCase) -> (T?, BaseParseError?) {
        if json.isNilOrEmpty {
            return (nil, BaseParseError.emptyResponse)
        }
        else {
            let data = json?.data(using: .utf8)
            return transToModelWithData(data, keyDecodingStrategy: keyDecodingStrategy)
        }
    }
    
    static func transToModelWithData<T: Codable>(_ data: Data?, keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .convertToCamelCase) -> (T?, BaseParseError?) {
        if let jsonData = data {
            do {
                let decoder = JSONDecoder()
//                decoder.keyDecodingStrategy = keyDecodingStrategy
                let model = try decoder.decode(T.self, from: jsonData)
                return (model, nil)
            }
            catch {
                print(error.localizedDescription)
                return (nil, BaseParseError.failedDecoder)
            }
        }
        else {
            return (nil, BaseParseError.emptyResponse)
        }
    }
}

public
extension Encodable {
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        return dictionary
    }

    func asList() throws -> [[String: Any]] {
        let data = try JSONEncoder().encode(self)
        guard let list = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String: Any]] else {
            throw NSError()
        }
        return list
    }

    func jsonStr() throws -> String {
        let jsonData = try JSONEncoder().encode(self)
        guard let jsonString = String(data: jsonData, encoding: .utf8) else {
            throw NSError()
        }
        return jsonString
    }
}

struct SimpleCodingKey : CodingKey {
    var stringValue: String
    var intValue: Int?

    init(stringValue: String) {
        self.stringValue = stringValue
    }

    init(intValue: Int) {
        self.stringValue = "\(intValue)"
        self.intValue = intValue
    }
}

public
extension JSONDecoder.KeyDecodingStrategy {
    static var convertToPascalCase: JSONDecoder.KeyDecodingStrategy {
        return .custom { codingKeys in
            guard var str = codingKeys.last?.stringValue else {
                return SimpleCodingKey(stringValue: "")
            }
            guard let firstChar = str.first else {
                return SimpleCodingKey(stringValue: str)
            }
            let startIdx = str.startIndex
            str.replaceSubrange(startIdx...startIdx,
                                with: String(firstChar).uppercased())
            return SimpleCodingKey(stringValue: str)
        }
    }

    static var convertToCamelCase: JSONDecoder.KeyDecodingStrategy {
        return .custom { codingKeys in
            guard var str = codingKeys.last?.stringValue else {
                return SimpleCodingKey(stringValue: "")
            }
            guard let firstChar = str.first else {
                return SimpleCodingKey(stringValue: str)
            }
            let startIdx = str.startIndex
            str.replaceSubrange(startIdx...startIdx,
                                with: String(firstChar).lowercased())
            return SimpleCodingKey(stringValue: str)
        }
    }
}
