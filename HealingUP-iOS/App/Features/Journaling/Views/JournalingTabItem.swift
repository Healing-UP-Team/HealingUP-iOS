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

  var emptyListView: some View {
    VStack(alignment: .center) {
      Spacer()
      Image(uiImage: .kesslerIntro)
        .resizable()
        .scaledToFit()
        .frame(height: 250)
        .padding()
      VStack(alignment: .leading) {
        Text("Jurnal Kosong")
          .font(.system(size: 30, weight: .bold))
          .foregroundColor(Color.accentColor)
          .padding(.top, 10)
          .padding(.bottom, 10)
          .padding(.horizontal)
        Text("Sepertinya kamu belum mengisi jurnal sebelumnya, silahkan isi jurnal dengan klik tombol di kanan atas")
          .foregroundColor(Color.accentColor)
          .padding(.horizontal)
          .multilineTextAlignment(.leading)
      }
      Spacer()
    }
  }
  var journalListView: some View {
    List {
        ForEach(searchResult) { journal in
          NavigationLink(destination: JournalDetailView(journal: journal)) {
            JournalCell(journal: journal)
          }
        }
    }
    .listStyle(.plain)
    .listRowSeparator(Visibility.hidden)
    .onAppear() { // (1)
      self.viewModel.subscribe()
    }
  }

  var body: some View {
    ZStack {
      emptyListView
        .opacity(searchResult.isEmpty ? 1.0 : 0.0)
      journalListView
    }
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
      .previewDevice("iPhone 13")
  }
}
