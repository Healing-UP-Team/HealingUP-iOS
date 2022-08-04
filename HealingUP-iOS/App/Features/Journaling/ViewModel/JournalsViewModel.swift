//
//  JournalViewModel.swift
//  Semhas
//
//  Created by Muhammad Rifki Widadi on 13/07/22.
//

import Combine
import FirebaseFirestore
import Firebase

class JournalsViewModel: ObservableObject {
  @Published var journals = [Journal]()

  private var db = Firestore.firestore()
  private var listenerRegistration: ListenerRegistration?

  private let path = "journals"

  deinit {
    unsubscribe()
  }

  func subscribe() {
    guard let userId = Auth.auth().currentUser?.uid else { return }
    fetchJournalById(userId: userId)
  }
  
  func fetchJournalById(userId: String) {
    if listenerRegistration == nil {
      listenerRegistration = db.collection(path)
        .whereField("userId", isEqualTo: userId)
        .addSnapshotListener { (querySnapshot, _) in
        guard let documents = querySnapshot?.documents else {
          print("No documents")
          return
        }

        self.journals = documents.compactMap { queryDocumentSnapshot in
          try? queryDocumentSnapshot.data(as: Journal.self)
        }
      }
    }

  }

  func unsubscribe() {
    if listenerRegistration != nil {
      listenerRegistration?.remove()
      listenerRegistration = nil
    }
  }

}
