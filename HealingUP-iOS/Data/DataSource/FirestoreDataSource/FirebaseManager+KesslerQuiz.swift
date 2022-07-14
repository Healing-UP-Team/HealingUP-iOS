//
//  FirebaseManager+KesslerQuiz.swift
//  HealingUP-iOS
//
//  Created by Dicky Buwono on 06/06/22.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestoreSwift
import FirebaseFirestore

extension DefaultFirebaseManager {

  func fetchQuiz(completion: @escaping CompletionResult<[KesslerQuizEntity]>) {
    firestoreCollection(.kesslerQuiz)
      .getDocuments { querySnapshot, error in
        if let error = error {
          completion(.failure(.invalidRequest(error: error)))
        } else if let querySnapshot = querySnapshot, !querySnapshot.isEmpty {
          var kesslerQuizs = [KesslerQuizEntity]()
          for document in querySnapshot.documents {
            do {
              if document.exists {
                let kesslerQuiz = try document.data(as: KesslerQuizEntity.self)
                kesslerQuizs.append(kesslerQuiz)
                completion(.success(kesslerQuizs))
              } else {
                completion(.failure(.unknownError))
              }
            } catch {
              completion(.failure(.unknownError))
            }
          }
        }
      }
  }
}
