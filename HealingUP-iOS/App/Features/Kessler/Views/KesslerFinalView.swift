//
//  KesslerFinalView.swift
//  HealingUP-iOS
//
//  Created by Dicky Buwono on 06/06/22.
//

import SwiftUI
import FirebaseAuth

struct KesslerFinalView: View {
  var score: Int
  @State private var isShowAlert = false
  @State private var storeError: Error?
  @ObservedObject var kesslerViewModel: KesslerViewModel
  @Environment(\.presentationMode) var presentationMode
  @State var recomendation: [StressHandling] = []
  
  var body: some View {
    VStack {
      Spacer()
      Text("Your stress level")
        .font(.system(size: 20, weight: .semibold))
        .padding(.horizontal)
        .padding(.bottom, 1)
        .foregroundColor(.gray)
      Text(stressLevelCheck().rawValue)
        .padding(.horizontal)
        .foregroundColor(Color(uiColor: .accentPurple))
        .font(.system(size: 25, weight: .bold))
        .multilineTextAlignment(.center)
        .padding(.bottom, 1)
      Text("You can check your level stress on next month")
        .multilineTextAlignment(.center)
        .padding(.horizontal)
        .foregroundColor(.gray)
        .font(.caption2)
      
      Spacer()
      if stressLevelCheck() != .well {
        recomendationView()
      } else {
        Text("You're fine, keep it up!")
          .font(.system(size: 25, weight: .bold))
          .foregroundColor(Color(uiColor: .accentPurple))
      }
      
      Spacer()
     
      ButtonDefaultView(title: "Back to Home", action: {
        presentationMode.wrappedValue.dismiss()
      })
    }
    .padding()
    .alert(isPresented: $isShowAlert) {
      Alert(
        title: Text("Gagal"),
        message: Text("\(storeError?.localizedDescription ?? "Field tidak boleh kosong")"),
        dismissButton: .default(Text("OK"))
      )
    }
    .onAppear {
      if let userId = Auth.auth().currentUser?.uid {
        let kResult = KesslerResult(userId: userId, stressLevel: stressLevelCheck(), createAt: Date())
        kesslerViewModel.addKesslerResult(kResult: kResult)
      }
      switch stressLevelCheck() {
      case .mild:
        self.recomendation = [
          .init(title: "Deep Breathing", caption: "Take a deep breath", img: "nose", type: .breathing),
          .init(title: "Journaling", caption: "Express your feelings in writing", img: "note.text", type: .journaling)
        ]
      case .moderate:
        self.recomendation = [
          .init(title: "Counseling", caption: "Schedule a counseling session with a psychologist", img: "person.2", type: .counseling)
        ]
      case .disorder:
        self.recomendation = [
          .init(title: "Counseling", caption: "Schedule a counseling session with a psychologist", img: "person.2", type: .counseling)
        ]
      default:
        break
      }
    }
    .onViewStatable(
      kesslerViewModel.$addKesslerState,
      onError: { error in
        storeError = error
        isShowAlert = true
      })
    .progressHUD(isShowing: $kesslerViewModel.addKesslerState.isLoading)
  }
  
  private func stressLevelCheck() -> StressLevel {
    if score <= 19 {
      return StressLevel.well
    } else if score >= 20 && score <= 24 {
      return StressLevel.mild
    } else if score >= 25 && score <= 29 {
      return StressLevel.moderate
    } else {
      return StressLevel.disorder
    }
  }
  
  @ViewBuilder
  func recomendationView() -> some View {
    VStack(alignment: .leading) {
      Text("Recomendation")
        .font(.system(size: 20, weight: .semibold))
        .foregroundColor(Color(uiColor: .accentPurple))
        .padding(.bottom)
      
      ForEach(recomendation, id: \.self) { item in
        RecomendationCardView(stressHandling: item)
      }
      
    }.padding()
  }
}

struct KesslerFinalView_Previews: PreviewProvider {
  static var previews: some View {
    KesslerFinalView(score: 20, kesslerViewModel: AppAssembler.shared.resolve())
  }
}


