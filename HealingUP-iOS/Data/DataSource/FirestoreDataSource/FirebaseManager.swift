//
//  FirebaseManager.swift
//  HealingUP-iOS
//
//  Created by Dicky Buwono on 23/05/22.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestoreSwift

typealias CompletionResult<T> = (Result<T, FirebaseError>) -> Void

protocol FirebaseManager {
  func registerUser(email: String, password: String, completion: @escaping CompletionResult<Bool>)
  func signInUser(email: String, password: String, completion: @escaping CompletionResult<Bool>)
  func signOutUser(completion: @escaping CompletionResult<Bool>)
  func createUser(user: UserEntity, completion: @escaping CompletionResult<Bool>)
  func updateUser(user: UserEntity, completion: @escaping CompletionResult<Bool>)
  func fetchUser(completion: @escaping CompletionResult<UserEntity>)
  func fetchUsers(isUser: Bool, completion: @escaping CompletionResult<[UserEntity]>)
  
}

class DefaultFirebaseManager: FirebaseManager {

  static let shared: DefaultFirebaseManager = DefaultFirebaseManager()
  let firebaseAuth = Auth.auth()
  
}
