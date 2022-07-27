//
//  JournalView.swift
//  Semhas
//
//  Created by Muhammad Rifki Widadi on 30/06/22.
//

import SwiftUI

struct JournalDetailView: View {
  //MARK: - State
  @Environment(\.presentationMode) var presentationMode
  @State var isShowEditJournalSheet = false

  //MARK: - State via init
  var journal: Journal

  private var color: Color {
    Color.combColor[self.journal.emoji] ?? .accentPurple
  }

  //MARK: - UI Component
  var body: some View {
    HStack{
      Spacer(minLength: 16)
      VStack(alignment: .leading, spacing: 20) {
        Text(journal.emoji)
          .font(.system(size: 30))
          .frame(width: 55, height: 49)
          .background(
            Rectangle()
              .fill(color)
              .cornerRadius(16)
          )
          .padding(.top, 20)
        Text(journal.title)
          .font(.system(size: 30, weight: .semibold))
          .foregroundColor(.accentPurple)
        HStack(spacing: 9) {
          Image(systemName: "calendar")
            .font(.system(size: 20))
            .foregroundColor(.accentPurple)
          Text(journal.date)
            .font(.system(size: 14))
            .foregroundColor(.accentPurple)
        }

        Text(journal.note)
          .foregroundColor(.accentPurple)
          .font(.system(size: 14, weight: .medium))
          .padding()
          .frame(minWidth: UIScreen.main.bounds.width - 32, minHeight: 100, alignment: .topLeading)
          .background(
            Rectangle()
              .fill(Color.softYellow)
              .cornerRadius(16)
          )
        Spacer()
      }
      Spacer(minLength: 16)
    }
    .toolbar {
      ToolbarItem(placement: .navigationBarTrailing) {
        Button {
          isShowEditJournalSheet.toggle()
        } label: {
          Text("Edit")
        }

      }
    }
    .sheet(isPresented: $isShowEditJournalSheet) {
      JournalEditView(viewModel: JournalViewModel(journal: journal), mode: .edit) { result in
        if case .success(let action) = result, action == .delete {
          self.presentationMode.wrappedValue.dismiss()
        }
      }
    }

  }
}

struct JournalView_Previews: PreviewProvider {
  static var journal = Journal(emoji: "🫠", title: "tes", note: "tes", date: "23 jul 2022")
  static var previews: some View {
    NavigationView {
      JournalDetailView(journal: journal)
    }
  }
}
