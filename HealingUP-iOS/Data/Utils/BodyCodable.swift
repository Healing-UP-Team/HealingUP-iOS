//
//  BodyCodable.swift
//  HealingUP-iOS
//
//  Created by Dicky Buwono on 23/05/22.
//

import Foundation

protocol BodyCodable {
  func asFormDictionary() -> [String: Any]
}

extension BodyCodable where Self: Codable {
  func asFormDictionary() -> [String: Any] {
    guard let data = try? JSONEncoder().encode(self),
          let dict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] else {
            return [:]
          }
    return dict
  }
}
