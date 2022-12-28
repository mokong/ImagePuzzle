//
//  Optional_Extensions.swift
//  MorganWang
//
//  Created by Horizon on 20/07/2022.
//

import Foundation

public
extension Optional {
    func orThrow(
        _ errorExpression: @autoclosure () -> Error
    ) throws -> Wrapped {
        guard let value = self else {
            throw errorExpression()
        }

        return value
    }

    /**
     guard let query = searchBar.text, query.length > 2 else {
         return
     }
     performSearch(with: query)

     
     searchBar.text.matching { $0.count > 2 }
                   .map(performSearch)
     */
    func matching(_ predicate: (Wrapped) -> Bool) -> Wrapped? {
        guard let value = self else {
            return nil
        }

        guard predicate(value) else {
            return nil
        }

        return value
    }
}

public
extension Optional where Wrapped: Collection {
    var isNilOrEmpty: Bool {
        return self?.isEmpty ?? true
    }
}

extension Optional where Wrapped == String {
    var wrapNil: String {
        if let self = self {
            return self
        } else {
            return ""
        }
    }
}

extension Optional where Wrapped == UIView {
    mutating func get<T: UIView>(
        orSet expression: @autoclosure () -> T
    ) -> T {
        guard let view = self as? T else {
            let newView = expression()
            self = newView
            return newView
        }

        return view
    }
}
