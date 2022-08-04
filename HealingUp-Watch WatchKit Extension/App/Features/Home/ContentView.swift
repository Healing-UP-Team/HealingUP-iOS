//
//  ContentView.swift
//  HealingUp-Watch WatchKit Extension
//
//  Created by Dicky Buwono on 24/05/22.
//

import SwiftUI
import HealthKit

public enum MenuWatch {
  case heart
  case deepBreathing
}

struct HomeMenu: Hashable {
  var imageName: String
  var title: String
  var menuType: MenuWatch
}

struct ContentView: View {
  @ObservedObject var heart = HeartRateViewModel()

  private var menu: [HomeMenu] = [
    .init(imageName: "wind", title: "Bernapas", menuType: .deepBreathing),
    .init(imageName: "heart", title: "Jantung", menuType: .heart)
  ]

  var body: some View {
    ScrollView {
      ForEach(menu, id: \.self) { item in
        NavigationLink(destination: navigationHandler(item.menuType)) {
          buttonView(item)
        }
        .background(Color.init(hex: "#303030"))
        .cornerRadius(10)
        .shadow(color: Color.gray.opacity(0.5), radius: 2, x: 0, y: 0)
        .padding(.horizontal, 10)
      }
    }.navigationTitle("Healing UP")
      .navigationBarBackButtonHidden(true)
  }

  @ViewBuilder
  private func buttonView(_ menu: HomeMenu) -> some View {
    HStack(spacing: 0) {
      Image(systemName: menu.imageName)
        .font(.system(size: 25))
        .foregroundColor(Color.white)

      Text(menu.title)
        .foregroundColor(Color.white)
        .font(.system(size: 17, weight: .medium))
        .padding()

      Spacer()
      Image(systemName: "chevron.forward")
        .font(.system(size: 10, weight: .medium))
        .foregroundColor(Color.white)

    }
  }

  private func navigationHandler(_ menu: MenuWatch) -> AnyView {
    switch menu {
    case .heart:
      return AnyView(HeartRateVariabilityView())
    case .deepBreathing:
      return AnyView(DeepBreathingPreparationView())
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
