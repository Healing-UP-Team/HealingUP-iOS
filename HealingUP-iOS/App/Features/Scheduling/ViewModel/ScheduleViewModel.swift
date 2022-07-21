//
//  ScheduleViewModel.swift
//  HealingUP-iOS
//
//  Created by Dicky Buwono on 19/07/22.
//

import Foundation

class ScheduleViewModel: ObservableObject {

  @Published var createScheduleState: ViewState<Bool> = .initiate
  @Published var fetchScheduleState: ViewState<[Schedule]> = .initiate
  @Published var fetchCounsellorScheduleState: ViewState <[Schedule]> = .initiate
  @Published var updateScheduleState: ViewState<Bool> = .initiate

  private let firebaseManager: FirebaseManager

  init(firebaseManager: FirebaseManager) {
    self.firebaseManager = firebaseManager
  }

  func createSchedule(schedule: Schedule) {
    createScheduleState = .loading
    firebaseManager.createSchedule(schedule: schedule.map()) { result in
      switch result {
      case .success(let isSuccess):
        self.createScheduleState = .success(data: isSuccess)
      case .failure(let firebaseError):
        if case .invalidRequest(let error) = firebaseError {
          self.createScheduleState = .error(error: error)
        }
      }
    }
  }

  func fetchSchedule() {
    fetchScheduleState = .loading
    firebaseManager.fetchSchedule { result in
      switch result {
      case .success(let data):
        if data.isEmpty {
          self.fetchScheduleState = .empty
        } else {
          self.fetchScheduleState = .success(data: data.map {
            $0.map()
          })
        }
      case .failure(let firebaseError):
        if case .invalidRequest(let error) = firebaseError {
          self.fetchScheduleState = .error(error: error)
        }
      }
    }
  }

  func fetchCounsellorSchedule() {
    fetchCounsellorScheduleState = .loading
    firebaseManager.fetchCounsellorSchedule { result in
      switch result {
      case .success(let data):
        if data.isEmpty {
          self.fetchCounsellorScheduleState = .empty
        } else {
          self.fetchCounsellorScheduleState = .success(data: data.map {
            $0.map()
          })
        }
      case .failure(let firebaseError):
        if case .invalidRequest(let error) = firebaseError {
          self.fetchCounsellorScheduleState = .error(error: error)
        }
      }
    }
  }

  func updateSchedule(schedule: Schedule) {
    updateScheduleState = .loading
    firebaseManager.updateStatusSchedule(schedule: schedule.map()) { result in
      switch result {
      case .success(let isSuccess):
        self.updateScheduleState = .success(data: isSuccess)
      case .failure(let firebaseError):
        if case .invalidRequest(let error) = firebaseError {
          self.updateScheduleState = .error(error: error)
        }
      }
    }
  }
}
