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
      ScrollView(showsIndicators: false) {
        Image(uiImage: .kesslerIntro)
          .resizable()
          .scaledToFit()
          .frame(height: 250)
          .padding()
        VStack(alignment: .leading) {
          Text("Hi, how are you?")
            .font(.system(size: 30, weight: .bold))
            .foregroundColor(Color.accentColor)
            .padding(.top, 20)
            .padding(.bottom, 15)
            .padding(.horizontal)
          Text("By answering these question, we can help you figure out your stress level and recommend things you can do to manage your stress")
            .foregroundColor(Color.accentColor)
            .padding(.horizontal)
            .multilineTextAlignment(.leading)
        }
      }
      Spacer()
      ButtonDefaultView(title: "Start now", action: {
        kesslerViewModel.fetchKesslerQuiz()
      })
      .padding(.vertical)

      if !kesslerData.isEmpty {
        NavigationLink(destination: navigator.navigateToKesslerQuizView(kesslerQuizs: kesslerData, isBackToRoot: $isStartQuiz), isActive: $isStartQuiz) {
          EmptyView()
        }
      }
    }
    .padding(.horizontal)
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
    .progressHUD(isShowing: $kesslerViewModel.kesslerQuizState.isLoading)
    .toolbar {
      ToolbarItem(placement: .navigationBarTrailing) {
        NavigationLink(destination: navigator.navigateToKesslerHistory) {
          Image(systemName: "clock.arrow.circlepath")
            .foregroundColor(Color.accentColor)
        }
      }
    }
  }
}

struct KesslerTabItem_Previews: PreviewProvider {
  static var previews: some View {
    KesslerTabItem(navigator: AppAssembler.shared.resolve(), kesslerViewModel: AppAssembler.shared.resolve())
  }
}
