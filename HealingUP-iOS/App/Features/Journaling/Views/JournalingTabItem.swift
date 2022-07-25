//
//  JournalingTabItem.swift
//  HealingUP-iOS
//
//  Created by Muhammad Rifki Widadi on 12/07/22.
//

import SwiftUI

struct JournalingTabItem: View {
    let navigator: JournalingNavigator
    @ObservedObject var journalingViewModel: JournalingViewModel

    @ObservedObject var journalVM = JournalViewModel()
    @State private var searchText = ""
    @State private var showForm = false


    var body: some View {
            List {
                ForEach(searchResult) { journal in
                    NavigationLink(destination: JournalView(journal: journal)) {
                        JournalCell(journal: journal)

                    }.swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button {

                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                        .tint(.red)

                        Button {

                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                        .tint(.green)

                }
                }
            }
            .sheet(isPresented: $showForm) {
                JournalForm()
            }
            .searchable(text: $searchText)
            .listRowSeparator(.hidden)
            .listStyle(.plain)
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

    }

    var searchResult: [Journal] {
        if searchText.isEmpty {
            return journalVM.journal
        } else {
            return journalVM.journal.filter { $0.title.contains(searchText) }
        }
    }
}

struct JournalingTabItem_Previews: PreviewProvider {
    static var previews: some View {
        JournalingTabItem(navigator: AppAssembler.shared.resolve(), journalingViewModel: AppAssembler.shared.resolve())
    }
}
