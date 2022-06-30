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
  case history
}

struct HomeMenu: Hashable {
  var imageName: String
  var title: String
  var menuType: MenuWatch
}

struct ContentView: View {
  @ObservedObject var heart = HeartRateViewModel()

  private var menu: [HomeMenu] = [
    .init(imageName: "heart.fill", title: "Heart", menuType: .heart),
    .init(imageName: "clock.arrow.circlepath", title: "History", menuType: .history)
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
  }
  
  @ViewBuilder
  private func buttonView(_ menu: HomeMenu) -> some View {
    HStack(spacing: 0) {
      Image(systemName: menu.imageName)
        .font(.system(size: 25))
      
      Text(menu.title)
        .foregroundColor(Color.white)
        .font(.system(size: 17, weight: .medium))
        .padding()
      
      Spacer()
      Image(systemName: "chevron.forward")
        .font(.system(size: 10, weight: .medium))
      
    }
  }
  
  private func navigationHandler(_ menu: MenuWatch) -> AnyView {
    switch menu {
    case .heart:
      return AnyView(HeartRateVariabilityView())
    case .history:
      return AnyView(Text("History"))
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}


extension Color {
  init(hex: String) {
    let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
    var int: UInt64 = 0
    Scanner(string: hex).scanHexInt64(&int)
    let a, r, g, b: UInt64
    switch hex.count {
    case 3: // RGB (12-bit)
      (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
    case 6: // RGB (24-bit)
      (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
    case 8: // ARGB (32-bit)
      (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
    default:
      (a, r, g, b) = (1, 1, 1, 0)
    }
    
    self.init(
      .sRGB,
      red: Double(r) / 255,
      green: Double(g) / 255,
      blue:  Double(b) / 255,
      opacity: Double(a) / 255
    )
  }
}
