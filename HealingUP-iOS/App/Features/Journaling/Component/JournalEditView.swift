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
          Picker("Emosi", selection: $viewModel.journal.emoji) {
            ForEach(viewModel.emotion, id: \.self) { emoji in
              Text(emoji)
            }
          }.pickerStyle(.segmented)
        } header: {
          Text("Bagaimana emosimu saat ini?")
        }

        Section {
          TextField("Apa aktivitasmu hari ini?", text: $viewModel.journal.title)
          Label(viewModel.journal.date.toStringWith(format: "EE, dd MMM yyyy") ?? "", systemImage: "calendar")
            .foregroundColor(.gray)
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
              Text("Hapus Jurnal")
                .foregroundColor(.red)
            }

          }
        }
      }
      .navigationTitle(mode == .new ? "Jurnal Baru" : viewModel.journal.title)
      .navigationBarTitleDisplayMode(mode == .new ? .inline : .large)
      .toolbar {
        ToolbarItem(placement: .navigationBarLeading) {
          Button(action: { self.handleCancelTapped() }) {
            Text("Kembali")
          }
        }
        ToolbarItem(placement: .navigationBarTrailing) {
          Button(action: { self.handleDoneTapped() }) {
            Text(mode == .new ? "Selesai" : "Simpan")
          }
          .disabled(!viewModel.modified) // (8)
        }

      }
      .confirmationDialog("Apakah kamu yakin?", isPresented: self.$presentActionSheet) {
        Button(role: .destructive) {
          self.handleDeleteTapped()
        } label: {
          Text("Hapus")
        }

        Button(role: .cancel, action: {}) {
          Text("Kembali")
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
