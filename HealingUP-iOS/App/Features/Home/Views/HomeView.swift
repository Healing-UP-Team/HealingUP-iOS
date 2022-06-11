//
//  HomeView.swift
//  HealingUP-iOS
//
//  Created by Dicky Buwono on 23/05/22.
//

import SwiftUI

struct HomeView: View {
  @State var selection = 1
  
  var body: some View {
    TabView(selection: $selection) {
      NavigationView {
        KesslerTabItem(navigator: AppAssembler.shared.resolve(), kesslerViewModel: AppAssembler.shared.resolve())
          .navigationTitle(navigationSetTitle(item: selection))
      }
      .tabItem {
        Label("Kessler", systemImage: "person")
      }.tag(1)
      NavigationView {
        HeartRateView()
          .navigationTitle(navigationSetTitle(item: selection))
      }
      .tabItem {
        Label("Menu", systemImage: "person")
      }.tag(2)
      NavigationView {
        ProfileView(viewModel: AppAssembler.shared.resolve(), navigator: AppAssembler.shared.resolve())
          .navigationTitle(navigationSetTitle(item: selection))
      }
      .tabItem {
        Label("Profile", systemImage: "person")
      }.tag(3)
    }
  }
  
  private func navigationSetTitle(item: Int) -> String {
    switch item {
    case 1:
      return "Stress Level"
    case 2:
      return "Heart Rate"
    default:
      return "Profile"
    }
  }
  
}

struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    HomeView()
  }
}
