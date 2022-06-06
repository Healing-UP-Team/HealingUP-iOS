//
//  String.swift
//  HealingUP-iOS
//
//  Created by Dicky Buwono on 23/05/22.
//

import Foundation

extension Optional where Wrapped == String {
  func orEmpty() -> String {
    return self ?? ""
  }
}
