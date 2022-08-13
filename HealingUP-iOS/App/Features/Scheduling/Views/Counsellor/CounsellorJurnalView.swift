//
//  CounsellorJurnalView.swift
//  HealingUP-iOS
//
//  Created by Muhammad Rifki Widadi on 07/08/22.
//

import SwiftUI

struct CounsellorJurnalView: View {
  var viewModel: JournalsViewModel

    @Binding var journals: [Journal]

  var userName: String

  @State private var searchText = ""

  var body: some View {
    List(searchResult) { journal in
      JournalCell(journal: journal)
    }
    .navigationTitle("Jurnal \(userName)")
    .listStyle(.plain)
    .listRowSeparator(Visibility.hidden)
    .refreshable {
        self.viewModel.subscribe()
    }
    .searchable(text: $searchText)
    .navigationBarTitle("Jurnal")
    .onAppear { // (1)
      self.viewModel.subscribe()
    }
  }

  var searchResult: [Journal] {
    if searchText.isEmpty {
      return journals.sorted {
        $1.date < $0.date
      }
    } else {
      return journals.filter { $0.title.contains(searchText) }
    }
  }
}
