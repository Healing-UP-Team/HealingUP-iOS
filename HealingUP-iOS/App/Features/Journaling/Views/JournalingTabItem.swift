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
  @State private var isListEmpty: Bool = false

  var journalListView: some View {
    List(searchResult) { journal in
      ZStack {
        NavigationLink(destination: JournalDetailView(journal: journal)) {
          EmptyView()
        }
        JournalCell(journal: journal)
      }
    }
    .listStyle(.plain)
    .listRowSeparator(Visibility.hidden)
    .sheet(isPresented: $showForm) {
      JournalEditView()
    }
    .searchable(text: $searchText)
    .navigationBarTitle("Jurnal")
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
    .onAppear { // (1)
      self.viewModel.subscribe()
    }
  }

  var body: some View {
    journalListView
  }

  var searchResult: [Journal] {
    if searchText.isEmpty {
      return viewModel.journals.sorted {
        $1.date < $0.date
      }
    } else {
      return viewModel.journals.filter { $0.title.contains(searchText) }
    }
  }
}

struct JournalList_Previews: PreviewProvider {
  static var previews: some View {
    JournalingTabItem()
      .previewDevice("iPhone 13")
  }
}
