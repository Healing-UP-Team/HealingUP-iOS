//
//  MembershipViewModel.swift
//  HealingUP-iOS
//
//  Created by Dicky Buwono on 23/05/22.
//

import Foundation
import WatchConnectivity

class MembershipViewModel: ObservableObject {

  @Published var userState: ViewState<User> = .initiate
  @Published var allUserState: ViewState<[User]> = .initiate
  @Published var userByEmailState: ViewState<User> = .initiate
  @Published var createUserState: ViewState<Bool> = .initiate
  @Published var updateUserState: ViewState<Bool> = .initiate
  @Published var registerState: ViewState<Bool> = .initiate
  @Published var signInState: ViewState<Bool> = .initiate
  @Published var signOutState: ViewState<Bool> = .initiate
  @Published var userByIdState: ViewState<User> = .initiate
  @Published var userCounselorState: ViewState<User> = .initiate

  @Published var userData: User?
  @Published var counselorName: String = ""
  @Published var schedule: Schedule?

  private let firebaseManager: FirebaseManager
  static let shared = MembershipViewModel(firebaseManager: AppAssembler.shared.resolve())

  init(firebaseManager: FirebaseManager, schedule: Schedule? = nil) {
    self.firebaseManager = firebaseManager
    self.schedule = schedule
  }

  func viewOnListSchedule() {
    fetchCounselorSchedule(email: schedule?.counsellorId ?? "")
  }

  func setupUserData() {
    firebaseManager.fetchUser { result in
      switch result {
      case .success(let data):
        self.userData = data.map()
      default:
        print("Failed fetch User")
      }
    }
  }

  func fetchUser() {
    userState = .loading
    firebaseManager.fetchUser { result in
      switch result {
      case .success(let data):
        self.userState = .success(data: data.map())
      case .failure(let firebaseError):
        if case .invalidRequest(let error) = firebaseError {
          self.userState = .error(error: error)
        }
      }
    }
  }

  func fetchUser(email: String) {
    userByEmailState = .loading
    firebaseManager.fetchUser(email: email) { result in
      switch result {
      case .success(let data):
        self.userByEmailState = .success(data: data.map())
      case .failure(let firebaseError):
        if case .invalidRequest(let error) = firebaseError {
          self.userByEmailState = .error(error: error)
        }
      }
    }
  }

  func fetchCounselorSchedule(email: String) {
    userCounselorState = .loading
    firebaseManager.fetchUser(email: email) { result in
      switch result {
      case .success(let data):
        self.userCounselorState = .success(data: data.map())
        self.counselorName = data.map().name
      case .failure(let firebaseError):
        if case .invalidRequest(let error) = firebaseError {
          self.userCounselorState = .error(error: error)
        }
      }
    }
  }

  func fetchUsers(isUser: Bool = false) {
    allUserState = .loading
    firebaseManager.fetchUsers(isUser: isUser) { result in
      switch result {
      case .success(let data):
        self.allUserState = .success(data: data.map { $0.map() })
      case .failure(let firebaseError):
        if case .invalidRequest(let error) = firebaseError {
          self.allUserState = .error(error: error)
        }
      }
    }
  }

  func fetchUserById(id: String) {
    userByIdState = .loading
    firebaseManager.fetchUserById(id: id) { result in
      switch result {
      case .success(let data):
        self.userByIdState = .success(data: data.map())
      case .failure(let firebaseError):
        if case .invalidRequest(let error) = firebaseError {
          self.userByIdState = .error(error: error)
        }
      }
    }
  }

  func createUser(user: User) {
    createUserState = .loading
    firebaseManager.createUser(user: user.map()) { result in
      switch result {
      case .success(let isSuccess):
        self.createUserState = .success(data: isSuccess)
      case .failure(let firebaseError):
        if case .invalidRequest(let error) = firebaseError {
          self.createUserState = .error(error: error)
        }
      }
    }
  }

  func updateUser(user: User) {
    updateUserState = .loading
    firebaseManager.updateUser(user: user.map()) { result in
      switch result {
      case .success(let isSuccess):
        self.updateUserState = .success(data: isSuccess)
      case .failure(let firebaseError):
        if case .invalidRequest(let error) = firebaseError {
          self.updateUserState = .error(error: error)
        }
      }
    }
  }

  func registerUser(email: String, password: String) {
    registerState = .loading
    firebaseManager.registerUser(email: email, password: password) { result in
      switch result {
      case .success(let isSuccess):
        self.registerState = .success(data: isSuccess)
      case .failure(let firebaseError):
        if case .invalidRequest(let error) = firebaseError {
          self.registerState = .error(error: error)
        }
      }
    }
  }

  func signInUser(email: String, password: String) {
    signInState = .loading
    firebaseManager.signInUser(email: email, password: password) { result in
      switch result {
      case .success(let isSuccess):
        self.signInState = .success(data: isSuccess)
      case .failure(let firebaseError):
        if case .invalidRequest(let error) = firebaseError {
          self.signInState = .error(error: error)
        }
      }
    }
  }

  func signOutUser() {
    signOutState = .loading
    firebaseManager.signOutUser { result in
      switch result {
      case .success(let isSuccess):
        self.signOutState = .success(data: isSuccess)
      default:
        break
      }
    }
  }

}
