//
//  KesslerDataListView.swift
//  HealingUP-iOS
//
//  Created by Dicky Buwono on 06/06/22.
//

import SwiftUI

struct KesslerDataListView: View {
  @ObservedObject var kesslerViewModel: KesslerViewModel
  @State private var isShowAlert = false
  @State private var fetchError: Error?
  @State var kResults = [KesslerResult]()
  var isFirsTime: Binding<Bool>?
  
  var body: some View {
    ScrollView {
      if !kResults.isEmpty {
        ForEach(kResults, id: \.id) { result in
          VStack {
            KesslerResultItemView(kesslerResult: result)
          }
        }
        
      }
    }
    .navigationTitle("Stress Level")
    .alert(isPresented: $isShowAlert) {
      Alert(
        title: Text("Gagal"),
        message: Text("\(fetchError?.localizedDescription ?? "Field tidak boleh kosong")"),
        dismissButton: .default(Text("OK"))
      )
    }
    .onAppear {
      kesslerViewModel.fetchKesslerResult()
    }
    .onViewStatable(
      kesslerViewModel.$fetchKesslerResultState,
      onSuccess: { data in
        self.kResults = data
        self.isFirsTime?.wrappedValue = false
      },
      onEmpty: {
        self.isFirsTime?.wrappedValue = true
      },
      onError: { error in
        fetchError = error
        isShowAlert = true
      })
    .progressHUD(isShowing: $kesslerViewModel.fetchKesslerResultState.isLoading)
  }
}

struct KesslerDataListView_Previews: PreviewProvider {
  static var previews: some View {
    KesslerDataListView(kesslerViewModel: AppAssembler.shared.resolve(), isFirsTime: .constant(false))
  }
}
