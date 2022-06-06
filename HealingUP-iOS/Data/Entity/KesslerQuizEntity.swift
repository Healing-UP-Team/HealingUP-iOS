//
//  KesslerQuizEntity.swift
//  HealingUP-iOS
//
//  Created by Dicky Buwono on 06/06/22.
//

import Foundation

struct KesslerQuizEntity: Codable, BodyCodable {
  
  enum CodingKeys: String, CodingKey {
    case question = "question"
    case answer = "answer"
  }
  
  var question: String?
  var answer: [String]?
  
  init(question: String?, answer: [String]?) {
    self.question = question
    self.answer = answer
  }
}
