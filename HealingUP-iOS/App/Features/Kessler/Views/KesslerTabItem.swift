//
//  KesslerTabItem.swift
//  HealingUP-iOS
//
//  Created by Dicky Buwono on 06/06/22.
//

import SwiftUI
import Combine

struct KesslerTabItem: View {
  let navigator: KesslerNavigator
  @ObservedObject var kesslerViewModel: KesslerViewModel
  @State var isStartQuiz = false
  @State private var fetchError: Error?
  @State private var isShowAlert = false
  @State var kesslerData = [KesslerQuiz]()
  @State var cancellables = Set<AnyCancellable>()
  @State var isShowBreath = false
  @Binding var tabSelection: Int

  init(navigator: KesslerNavigator, kesslerViewModel: KesslerViewModel, tabSelection: Binding<Int>) {
    self.navigator = navigator
    self.kesslerViewModel = kesslerViewModel
    self._tabSelection = tabSelection

    NotificationCenter.default.publisher(for: Notifications.moveToCounselling)
      .sink(receiveValue: { _ in
      }).store(in: &cancellables)

    NotificationCenter.default.publisher(for: Notifications.moveToJournaling)
      .sink(receiveValue: { _ in
      }).store(in: &cancellables)

    NotificationCenter.default.publisher(for: Notifications.moveToBreath)
      .sink(receiveValue: { _ in
      }).store(in: &cancellables)
  }

  var body: some View {
    VStack {
      ScrollView(showsIndicators: false) {
        Image(uiImage: .kesslerIntro)
          .resizable()
          .scaledToFit()
          .frame(height: 250)
          .padding()
        VStack(alignment: .leading) {
          Text("Hi, apa kabar?")
            .font(.system(size: 30, weight: .bold))
            .foregroundColor(Color.accentColor)
            .padding(.top, 20)
            .padding(.bottom, 15)
            .padding(.horizontal)
          Text("Dengan menjawab pertanyaan ini, HealingUp dapat membantu kamu mengetahui tingkat stres yang kamu alami dan merekomendasikan hal-hal yang dapat kamu lakukan untuk mengelola stres Anda")
            .foregroundColor(Color.accentColor)
            .padding(.horizontal)
            .multilineTextAlignment(.leading)
        }
      }
      Spacer()
      ButtonDefaultView(title: "Mulai", action: {
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
    .onReceive(NotificationCenter.default.publisher(for: Notifications.moveToCounselling)) { _ in
      self.tabSelection = 4
    }
    .onReceive(NotificationCenter.default.publisher(for: Notifications.moveToJournaling)) { _ in
      self.tabSelection = 3
    }
    .onReceive(NotificationCenter.default.publisher(for: Notifications.moveToBreath)) { _ in
      DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        self.isShowBreath = true
      }
    }
    .sheet(isPresented: $isShowBreath) {
      navigator.navigateToDeepBreathing(title: "Bernapas Perut", icon: .watchPerson, message: "Kamu bisa menggunakan fitur ini pada aplikasi HealingUp di Apple Watch kamu.", buttonTitle: "OK")
    }
  }
}

struct KesslerTabItem_Previews: PreviewProvider {
  static var previews: some View {
    KesslerTabItem(navigator: AppAssembler.shared.resolve(), kesslerViewModel: AppAssembler.shared.resolve(), tabSelection: .constant(0))
  }
}
