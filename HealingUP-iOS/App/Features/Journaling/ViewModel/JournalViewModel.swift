//
//  JournalViewModel.swift
//  Semhas
//
//  Created by Muhammad Rifki Widadi on 27/07/22.
//

import Combine
import FirebaseFirestore
import Firebase

class JournalViewModel: ObservableObject {
  @Published var journal: Journal
  @Published var modified = false
  @Published var emotion = ["😔", "🙂", "😊", "😁", "😆"]

  private var db = Firestore.firestore()
  private let path = "journals"

  private var cancellables = Set<AnyCancellable>()

  init(journal: Journal = Journal(emoji: "", title: "", note: "", date: Date().ISO8601Format())) {
    self.journal = journal
    self.$journal
      .dropFirst()
      .sink { [weak self] _ in
        self?.modified = true
      }
      .store(in: &cancellables)
  }

  func addJournal(_ journal: Journal) {
      do {
        var newJournal = journal
        if let userId = Auth.auth().currentUser?.uid {
          newJournal.userId = userId
        }
        _ = try db.collection(path).addDocument(from: newJournal)
      } catch {
        print(error.localizedDescription)
      }
  }

  private func updateJournal(_ journal: Journal) {
    if let journalId = journal.id {
      do {
        try db.collection(path).document(journalId).setData(from: journal)
      } catch {
        print(error.localizedDescription)
      }
    }
  }

  private func updateOrAddJournal() {
    if let _ = journal.id {
      self.updateJournal(self.journal)
    } else {
      self.addJournal(self.journal)
    }
  }

  private func removeJournal() {
    if let journalId = journal.id {
        db.collection(path).document(journalId).delete { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
  }

  // MARK: - Model Management
  func save() {
      updateOrAddJournal()
  }

  // MARK: - UI Handler
  func handleDoneTapped() {
      self.save()
  }

  func handleDeleteTapped() {
      self.removeJournal()
  }
}
