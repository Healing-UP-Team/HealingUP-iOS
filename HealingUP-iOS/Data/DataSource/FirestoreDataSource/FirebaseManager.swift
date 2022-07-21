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
  // MARK: Membership
  func registerUser(email: String, password: String, completion: @escaping CompletionResult<Bool>)
  func signInUser(email: String, password: String, completion: @escaping CompletionResult<Bool>)
  func signOutUser(completion: @escaping CompletionResult<Bool>)
  func createUser(user: UserEntity, completion: @escaping CompletionResult<Bool>)
  func updateUser(user: UserEntity, completion: @escaping CompletionResult<Bool>)
  func fetchUser(completion: @escaping CompletionResult<UserEntity>)
  func fetchUsers(isUser: Bool, completion: @escaping CompletionResult<[UserEntity]>)
  func fetchUser(email: String, completion: @escaping CompletionResult<UserEntity>)
  func fetchUserById(id: String, completion: @escaping CompletionResult<UserEntity>)

  // MARK: Kessler
  func fetchQuiz(completion: @escaping CompletionResult<[KesslerQuizEntity]>)
  func addKesslerResult(kResult: KesslerResultEntity, completion: @escaping CompletionResult<Bool>)
  func fetchKesslerResult(completion: @escaping CompletionResult<[KesslerResultEntity]>)

  // MARK: Schedule
  func createSchedule(schedule: ScheduleEntity, completion: @escaping CompletionResult<Bool>)
  func fetchSchedule(completion: @escaping CompletionResult<[ScheduleEntity]>)
  func fetchCounsellorSchedule(completion: @escaping CompletionResult<[ScheduleEntity]>)
  func updateStatusSchedule(schedule: ScheduleEntity, completion: @escaping CompletionResult<Bool>)
}

class DefaultFirebaseManager: FirebaseManager {

  static let shared: DefaultFirebaseManager = DefaultFirebaseManager()
  let firebaseAuth = Auth.auth()

}
