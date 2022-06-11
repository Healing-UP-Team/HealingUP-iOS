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
  @State var isFirstTime = false
  
  var body: some View {
    if isFirstTime {
      VStack {
        VStack {
          Spacer()
          Text("Hi, how are you?")
            .font(.system(size: 20, weight: .bold))
            .padding(.bottom, 5)
          Text("This feature wil help you to know your stress level")
            .padding(.horizontal)
            .multilineTextAlignment(.center)
          
          Spacer()
          
          Button {
            kesslerViewModel.fetchKesslerQuiz()
          }label: {
            Text("Start now!")
              .font(.system(size: 18, weight: .medium))
              .frame(width: UIScreen.main.bounds.width/1.3, height: 20, alignment: .center)
              .padding()
              .foregroundColor(.white)
              .background(Color.blue)
              .cornerRadius(5)
          }
          .padding()
          
          if !kesslerData.isEmpty {
            NavigationLink(destination: navigator.navigateToKesslerQuizView(kesslerQuizs: kesslerData, isFirstTime: $isFirstTime), isActive: $isStartQuiz) {
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
      .padding()
      .progressHUD(isShowing: $kesslerViewModel.kesslerQuizState.isLoading)
    } else {
      navigator.navigateToKesslerDataListView(isFirsTime: $isFirstTime)
    }
  }
}

struct KesslerTabItem_Previews: PreviewProvider {
  static var previews: some View {
    KesslerTabItem(navigator: AppAssembler.shared.resolve(), kesslerViewModel: AppAssembler.shared.resolve())
  }
}
