//
//  JournalList.swift
//  Semhas
//
//  Created by Muhammad Rifki Widadi on 30/06/22.
//

import SwiftUI

struct JournalingTabItem: View {
  @ObservedObject var viewModel = JournalsViewModel()
  @State private var searchText = ""
  @State private var showForm = false

  var body: some View {
    List {
      ForEach(searchResult) { journal in
        NavigationLink(destination: JournalDetailView(journal: journal)) {
          JournalCell(journal: journal)
        }
      }

    }
    .listStyle(.inset)
    .sheet(isPresented: $showForm) {
      JournalEditView()
    }
    .searchable(text: $searchText)
    .navigationBarTitle("Journaling")
    .toolbar {
      ToolbarItem(placement: .navigationBarTrailing) {
        Button {
          showForm.toggle()
        } label: {
          Image(systemName: "square.and.pencil")
            .resizable()
            .frame(width: 24, height: 24)
            .foregroundColor(.accentPurple)
        }
      }
    }
    .onAppear() { // (1)
      self.viewModel.subscribe()
    }
  }

  var searchResult: [Journal] {
    if searchText.isEmpty {
      return viewModel.journals
    } else {
      return viewModel.journals.filter { $0.title.contains(searchText) }
    }
  }

}

struct JournalList_Previews: PreviewProvider {
  static var previews: some View {
    JournalingTabItem()
  }
}
