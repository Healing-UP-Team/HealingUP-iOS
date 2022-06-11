//
//  FirebaseManager+KesslerResult.swift
//  HealingUP-iOS
//
//  Created by Dicky Buwono on 06/06/22.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestoreSwift

extension DefaultFirebaseManager {
  
  func addKesslerResult(kResult: KesslerResultEntity, completion: @escaping CompletionResult<Bool>) {
    guard let kResultId = kResult.id else { return }
    firestoreCollection(.kesslerResult)
      .document(kResultId)
      .setData(kResult.asFormDictionary()) { error in
        if let error = error {
          return completion(.failure(.invalidRequest(error: error)))
        } else {
          return completion(.success(true))
        }
      }
  }
  
  func fetchKesslerResult(completion: @escaping CompletionResult<[KesslerResultEntity]>) {
    guard let userId = firebaseAuth.currentUser?.uid else { return }
    firestoreCollection(.kesslerResult)
      .whereField("user_id", isEqualTo: userId)
      .orderByDate(recordDate: .kesslerResult, descending: true)
      .getDocuments { querySnapshot, error in
        if let error = error {
          completion(.failure(.invalidRequest(error: error)))
        } else if let querySnapshot = querySnapshot, !querySnapshot.isEmpty {
          var kResults = [KesslerResultEntity]()
          for document in querySnapshot.documents {
            do {
              if document.exists {
              let kResult = try document.data(as: KesslerResultEntity.self)
              kResults.append(kResult)
              completion(.success(kResults))
              } else {
                completion(.failure(.unknownError))
              }
            } catch {
              completion(.failure(.unknownError))
            }
          }
        } else if let querySnapshot = querySnapshot, querySnapshot.isEmpty {
          completion(.success([KesslerResultEntity]()))
        }
      }
  }
}


 
 
