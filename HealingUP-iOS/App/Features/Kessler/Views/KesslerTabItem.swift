//
//  KesslerTabItem.swift
//  HealingUP-iOS
//
//  Created by Dicky Buwono on 06/06/22.
//

import SwiftUI

struct KesslerTabItem: View {
  
  let navigator: KesslerNavigator
  @ObservedObject var kesslerViewModel: KesslerViewModel
  @State var isStartQuiz = false
  @State private var fetchError: Error?
  @State private var isShowAlert = false
  @State var kesslerData = [KesslerQuiz]()
  
  var body: some View {
    VStack {
      VStack {
        Spacer()
        Text("Hi, how are you?")
          .font(.system(size: 20, weight: .bold))
          .padding(.bottom, 5)
        Text("This feature wil help you to know your stress level")
        //          .padding(.horizontal)
          .multilineTextAlignment(.center)
        
        Spacer()
        
        Button {
          kesslerViewModel.fetchKesslerQuiz()
        }label: {
          Text("Start now!")
        }
        
        if !kesslerData.isEmpty {
          NavigationLink(destination: navigator.navigateToKesslerQuizView(kesslerQuizs: kesslerData), isActive: $isStartQuiz) {
            EmptyView()
          }
        }
      }
      .onViewStatable(
        kesslerViewModel.$kesslerQuizState,
        onSuccess: { success in
          kesslerData = success
          isStartQuiz = true
        },
        onError: { error in
          fetchError = error
          isShowAlert = true
        })
      
      .alert(isPresented: $isShowAlert) {
        Alert(
          title: Text("Gagal"),
          message: Text("\(fetchError?.localizedDescription ?? "Field tidak boleh kosong")"),
          dismissButton: .default(Text("OK"))
        )
      }
    }
    .progressHUD(isShowing: $kesslerViewModel.kesslerQuizState.isLoading)
  }
}

struct KesslerTabItem_Previews: PreviewProvider {
  static var previews: some View {
    KesslerTabItem(navigator: AppAssembler.shared.resolve(), kesslerViewModel: AppAssembler.shared.resolve())
  }
}