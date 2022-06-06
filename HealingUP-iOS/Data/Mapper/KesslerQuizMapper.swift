//
//  KesslerQuizMapper.swift
//  HealingUP-iOS
//
//  Created by Dicky Buwono on 06/06/22.
//

import Foundation

extension KesslerQuizEntity {
  func map() -> KesslerQuiz {
    return KesslerQuiz(question: question.orEmpty(), answer: answer ?? [String]())
  }
}

extension KesslerQuiz {
  func map() -> KesslerQuizEntity {
    return KesslerQuizEntity(question: question, answer: answer)
  }
}
