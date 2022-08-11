//
//  FirebaseManager+Schedule.swift
//  HealingUP-iOS
//
//  Created by Dicky Buwono on 20/07/22.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestoreSwift
import FirebaseFirestore

extension DefaultFirebaseManager {
  func createSchedule(schedule: ScheduleEntity, completion: @escaping CompletionResult<Bool>) {
    guard let scheduleId = schedule.id else { return }
    firestoreCollection(.schedule)
      .document(scheduleId)
      .setData(schedule.asFormDictionary()) { error in
        if let error = error {
          return completion(.failure(.invalidRequest(error: error)))
        } else {
          return completion(.success(true))
        }
      }
  }

  func fetchSchedule(completion: @escaping CompletionResult<[ScheduleEntity]>) {
    guard let userId = firebaseAuth.currentUser?.uid else { return }
    firestoreCollection(.schedule)
      .whereField("user_id", isEqualTo: userId)
      .orderByDate(recordDate: .schedule, descending: false)
      .addSnapshotListener { querySnapshot, error in
        if let error = error {
          completion(.failure(.invalidRequest(error: error)))
        } else if let querySnapshot = querySnapshot, !querySnapshot.isEmpty {
          var scheduleResults = [ScheduleEntity]()
          for document in querySnapshot.documents {
            do {
              if document.exists {
                let schedule = try document.data(as: ScheduleEntity.self)
                scheduleResults.append(schedule)
                completion(.success(scheduleResults))
              } else {
                completion(.failure(.unknownError))
              }
            } catch {
              completion(.failure(.unknownError))
            }
          }
        } else if let querySnapshot = querySnapshot, querySnapshot.isEmpty {
          completion(.success([ScheduleEntity]()))
        }
      }
  }

  func fetchCounsellorSchedule(completion: @escaping CompletionResult<[ScheduleEntity]>) {
    guard let userEmail = firebaseAuth.currentUser?.email else { return }
    firestoreCollection(.schedule)
      .whereField("counsellor_id", isEqualTo: userEmail)
      .orderByDate(recordDate: .schedule, descending: false)
      .addSnapshotListener { querySnapshot, error in
        if let error = error {
          completion(.failure(.invalidRequest(error: error)))
        } else if let querySnapshot = querySnapshot, !querySnapshot.isEmpty {
          var scheduleResults = [ScheduleEntity]()
          for document in querySnapshot.documents {
            do {
              if document.exists {
                let schedule = try document.data(as: ScheduleEntity.self)
                scheduleResults.append(schedule)
                completion(.success(scheduleResults))
              } else {
                completion(.failure(.unknownError))
              }
            } catch {
              completion(.failure(.unknownError))
            }
          }
        } else if let querySnapshot = querySnapshot, querySnapshot.isEmpty {
          completion(.success([ScheduleEntity]()))
        }
      }
  }

  func updateStatusSchedule(schedule: ScheduleEntity, completion: @escaping CompletionResult<Bool>) {
    guard let scheduleId = schedule.id else { return }
    firestoreCollection(.schedule)
      .document(scheduleId)
      .updateData(schedule.asFormDictionary()) { error in
        if let error = error {
          return completion(.failure(.invalidRequest(error: error)))
        } else {
          return completion(.success(true))
        }
      }
  }
}
