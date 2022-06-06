//
//  KesslerViewModel.swift
//  HealingUP-iOS
//
//  Created by Dicky Buwono on 06/06/22.
//

import Foundation

class KesslerViewModel: ObservableObject {
  
  @Published var kesslerQuizState: ViewState<[KesslerQuiz]> = .initiate
  
  
  private let firebaseManager: FirebaseManager
  
  init(firebaseManager: FirebaseManager) {
    self.firebaseManager = firebaseManager
  }
    
  func fetchKesslerQuiz() {
    kesslerQuizState = .loading
    firebaseManager.fetchQuiz() { result in
      switch result {
      case .success(let data):
        self.kesslerQuizState = .success(data: data.map { $0.map() })
      case .failure(let firebaseError):
        if case .invalidRequest(let error) = firebaseError {
          self.kesslerQuizState = .error(error: error)
        }
      }
    }
  }
  
}
