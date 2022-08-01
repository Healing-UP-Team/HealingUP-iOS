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
  let navigator: KesslerNavigator
  @State private var isShowAlert = false
  @State private var storeError: Error?
  @ObservedObject var kesslerViewModel: KesslerViewModel
  @Environment(\.presentationMode) var presentationMode
  @State var recomendation: [StressHandling] = []
  @State var isShowTerms = false

  var body: some View {
    NavigationView {
      ScrollView(showsIndicators: false) {
        NavigationLink(destination: navigator.navigateToWebView(url: Constant.termsLink, title: "Ketentuan Pengguna HealingUp"), isActive: $isShowTerms) {
          EmptyView()
        }
        Text("Level Stres Kamu Alami")
          .font(.system(size: 20, weight: .semibold))
          .padding(.horizontal)
          .padding(.bottom, 1)
          .foregroundColor(.gray)
          .padding(.top)
        Text(stressLevelCheck().rawValue)
          .padding(.horizontal)
          .foregroundColor(Color(uiColor: .accentPurple))
          .font(.system(size: 20, weight: .bold))
          .multilineTextAlignment(.center)
          .padding(.bottom, 1)
        Text("Anda tidak dapat bergantung pada informasi di atas sebagai alternatif saran medis dari penyedia layanan kesehatan profesional sesuai dengan")
          .multilineTextAlignment(.center)
          .padding(.horizontal)
          .foregroundColor(.gray)
          .font(.system(size: 12, weight: .regular))
        
        Button {
          isShowTerms = true
        } label: {
          Text("Ketentuan pengguna HealingUp")
            .underline()
            .multilineTextAlignment(.center)
            .padding(.horizontal)
            .foregroundColor(Color.accentPurple)
            .font(.system(size: 12, weight: .semibold))
        }.padding(.bottom, 30)
        
        if stressLevelCheck() != .well {
          recomendationView()
        } else {
          Text("Kamu baik-baik saja, pertahankan!")
            .font(.system(size: 25, weight: .bold))
            .foregroundColor(Color(uiColor: .accentPurple))
        }

        ButtonDefaultView(title: "Kembali ke Beranda", action: {
          presentationMode.wrappedValue.dismiss()
        })
        .padding(.top)
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
            .init(title: "Bernafas", caption: "Ambil napas dalam-dalam", img: "nose", type: .breathing),
            .init(title: "Jurnal", caption: "Ekspresikan perasaanmu secara tertulis", img: "note.text", type: .journaling),
            .init(title: "Konseling", caption: "Jadwalkan sesi konseling dengan psikolog", img: "person.2", type: .counseling)
          ]
        case .moderate:
          self.recomendation = [
            .init(title: "Konseling", caption: "Jadwalkan sesi konseling dengan psikolog", img: "person.2", type: .counseling)
          ]
        case .disorder:
          self.recomendation = [
            .init(title: "Konseling", caption: "Jadwalkan sesi konseling dengan psikolog", img: "person.2", type: .counseling)
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
      .navigationTitle("")
      .navigationBarHidden(true)
    }
    
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
      Text("Rekomendasi")
        .font(.system(size: 20, weight: .bold))
        .foregroundColor(Color(uiColor: .accentPurple))
        .padding(.bottom)

      ForEach(recomendation, id: \.self) { item in
        RecomendationCardView(stressHandling: item)
          .onTapGesture {
            presentationMode.wrappedValue.dismiss()
            switch item.type {
            case .breathing:
              Notifications.moveToBreath.post()
            case .journaling:
              Notifications.moveToJournaling.post()
            case .counseling:
              Notifications.moveToCounselling.post()
            case .none:
              break
            }
          }
      }
    }.padding()
  }
}

struct KesslerFinalView_Previews: PreviewProvider {
  static var previews: some View {
    KesslerFinalView(score: 20, navigator: AppAssembler.shared.resolve(), kesslerViewModel: AppAssembler.shared.resolve())
  }
}
