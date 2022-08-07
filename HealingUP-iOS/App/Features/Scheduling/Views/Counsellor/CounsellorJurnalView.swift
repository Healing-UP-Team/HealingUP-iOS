//
//  CounsellorJurnalView.swift
//  HealingUP-iOS
//
//  Created by Muhammad Rifki Widadi on 07/08/22.
//

import SwiftUI

struct CounsellorJurnalView: View {
  var viewModel: JournalsViewModel

  var userName: String

  @State private var searchText = ""

  var body: some View {
    List(searchResult) { journal in
      JournalCell(journal: journal)

    }
    .navigationTitle(userName)
    .listStyle(.plain)
    .listRowSeparator(Visibility.hidden)
    .searchable(text: $searchText)
    .navigationBarTitle("Jurnal")
    .onAppear { // (1)
      self.viewModel.subscribe()
    }
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
