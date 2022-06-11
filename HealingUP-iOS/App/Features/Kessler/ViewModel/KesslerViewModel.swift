//
//  KesslerViewModel.swift
//  HealingUP-iOS
//
//  Created by Dicky Buwono on 06/06/22.
//

import Foundation

class KesslerViewModel: ObservableObject {
  
  @Published var kesslerQuizState: ViewState<[KesslerQuiz]> = .initiate
  @Published var fetchKesslerResultState: ViewState<[KesslerResult]> = .initiate
  @Published var addKesslerState: ViewState<Bool> = .initiate
  
  
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
  
  func addKesslerResult(kResult: KesslerResult) {
    addKesslerState = .loading
    firebaseManager.addKesslerResult(kResult: kResult.map()) { result in
      switch result {
      case .success(let isSuccess):
        self.addKesslerState = .success(data: isSuccess)
      case .failure(let firebaseError):
        if case .invalidRequest(let error) = firebaseError {
          self.addKesslerState = .error(error: error)
        }
      }
    }
  }
  
  func fetchKesslerResult() {
    fetchKesslerResultState = .loading
    firebaseManager.fetchKesslerResult() { result in
      switch result {
      case .success(let data):
        if data.isEmpty {
          self.fetchKesslerResultState = .empty
        } else {
          self.fetchKesslerResultState = .success(data: data.map {
            $0.map() })
        }
      case .failure(let firebaseError):
        if case .invalidRequest(let error) = firebaseError {
          self.fetchKesslerResultState = .error(error: error)
        }
      }
    }
  }
  
}
