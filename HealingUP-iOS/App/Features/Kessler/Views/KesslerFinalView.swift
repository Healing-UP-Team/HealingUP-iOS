//
//  KesslerFinalView.swift
//  HealingUP-iOS
//
//  Created by Dicky Buwono on 06/06/22.
//

import SwiftUI
import FirebaseAuth

struct KesslerFinalView: View {
  var score: Int?
  @State private var isShowAlert = false
  @State private var storeError: Error?
  @ObservedObject var kesslerViewModel: KesslerViewModel
  @Environment(\.presentationMode) var presentationMode
  @State var recomendation: [StressHandling] = []
  
  var body: some View {
    VStack {
      Spacer()
      Text("Your stress level")
        .font(.system(size: 25, weight: .bold))
        .padding(.horizontal)
        .padding(.bottom, 1)
        .foregroundColor(.gray)
      Text(stressLevelCheck().rawValue)
        .padding(.horizontal)
        .foregroundColor(.black)
        .font(.system(size: 20, weight: .bold))
        .padding(.bottom, 1)
      Text("You can check your level stress on next month")
        .multilineTextAlignment(.center)
        .padding(.horizontal)
        .foregroundColor(.gray)
        .font(.caption2)
      
      Spacer()
        
//        Text(recomendation())
//          .frame(width: UIScreen.main.bounds.width/1.3, alignment: .leading)
//        switch stressLevelCheck() {
//        case .well
//
//        default:
//          recomendation()
//        }
      recomendationView()
      
      Spacer()
      Button {
        presentationMode.wrappedValue.dismiss()
      }label: {
        Text("Back to Home")
          .font(.system(size: 18, weight: .medium))
          .frame(width: UIScreen.main.bounds.width/1.3, height: 20, alignment: .center)
          .padding()
          .foregroundColor(.white)
          .background(Color.blue)
          .cornerRadius(5)
      }
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
          .init(title: "Deep Breathing", caption: "Lorem", img: "nose", type: .breathing),
          .init(title: "Journaling", caption: "Lorem", img: "note.text", type: .journaling)
        ]
      case .moderate:
        self.recomendation = [
          .init(title: "Counseling", caption: "Lorem", img: "person.2", type: .counseling)
        ]
      case .disorder:
        self.recomendation = [
          .init(title: "Counseling", caption: "Lorem", img: "person.2", type: .counseling)
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
    guard let score = score else {
      return StressLevel.well
    }
    
    if score >= 10 && score <= 19 {
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
        .padding(.bottom)
      
      ForEach(recomendation, id: \.self) { item in
        RecomendationCardView(stressHandling: item)
      }
      
    }.padding()
  }
}

struct KesslerFinalView_Previews: PreviewProvider {
  static var previews: some View {
    KesslerFinalView(score: 10, kesslerViewModel: AppAssembler.shared.resolve())
  }
}


