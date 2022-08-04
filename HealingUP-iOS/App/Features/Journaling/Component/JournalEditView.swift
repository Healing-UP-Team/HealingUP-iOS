//
//  CustomUIPicker.swift
//  Semhas
//
//  Created by Muhammad Rifki Widadi on 06/07/22.
//

import SwiftUI

enum Mode {
  case new, edit
}

enum Action {
  case delete, done, cancel
}

struct JournalEditView: View {

  // MARK: - Vriable init
  @StateObject var viewModel = JournalViewModel()
  var mode: Mode = .new
  var completionHandler: ((Result<Action, Error>) -> Void)?

  // MARK: - Local variable
  @Environment(\.presentationMode) private var presentationMode
  @State private var presentActionSheet = false

  // MARK: - UI Component
  var body: some View {
    NavigationView {
      Form {
        Section {
          Picker("Emotion", selection: $viewModel.journal.emoji) {
            ForEach(viewModel.emotion, id: \.self) { emoji in
              Text(emoji)
            }
          }.pickerStyle(.segmented)
        } header: {
          Text("Bagaimana emosimu saat ini?")
        }

        Section {
          TextField("Apa aktivitasmu hari ini?", text: $viewModel.journal.title)
          Text(viewModel.journal.date.toStringWith(format: "EE, dd MMM yyyy") ?? "")
        } header: {
          Text("Judul")
        }
        Section {
          Text("Ceritakan mengenai aktivitasmu hari ini ?")
            .fontWeight(.light)
            .foregroundColor(.gray)
          TextEditor(text: $viewModel.journal.note)
            .cornerRadius(12)
            .opacity(0.5)
        } header: {
          Text("Detail")
        }

        if mode == .edit {
          Section {
            Button {
              self.presentActionSheet.toggle()
            } label: {
              Text("Delete Journal")
                .foregroundColor(.red)
            }

          }
        }
      }
      .navigationTitle(mode == .new ? "New Journal" : viewModel.journal.title)
      .navigationBarTitleDisplayMode(mode == .new ? .inline : .large)
      .toolbar {
        ToolbarItem(placement: .navigationBarLeading) {
          Button(action: { self.handleCancelTapped() }) {
            Text("Cancel")
          }
        }
        ToolbarItem(placement: .navigationBarTrailing) {
          Button(action: { self.handleDoneTapped() }) {
            Text(mode == .new ? "Done" : "Save")
          }
          .disabled(!viewModel.modified) // (8)
        }

      }
      .confirmationDialog("Are You Sure?", isPresented: self.$presentActionSheet) {
        Button(role: .destructive) {
          self.handleDeleteTapped()
        } label: {
          Text("Delete")
        }

        Button(role: .cancel, action: {}) {
          Text("Cancel")
        }
      }
    }
  }

  func handleCancelTapped() { // (9)
    dismiss()
  }

  func handleDoneTapped() { // (10)
    self.viewModel.handleDoneTapped()
    dismiss()
  }

  func handleDeleteTapped() { // (5)
    viewModel.handleDeleteTapped()
    self.dismiss()
    self.completionHandler?(.success(.delete))
  }

  func dismiss() { // (11)
    self.presentationMode.wrappedValue.dismiss()
  }

}

struct JournalEditView_Preview: PreviewProvider {
  static var previews: some View {
    JournalEditView()
      .previewLayout(.sizeThatFits)
  }
}
