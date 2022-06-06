//
//  HomeView.swift
//  HealingUP-iOS
//
//  Created by Dicky Buwono on 23/05/22.
//

import SwiftUI

struct HomeView: View {
  var body: some View {
    NavigationView {
      TabView {
        KesslerTabItem(navigator: AppAssembler.shared.resolve(), kesslerViewModel: AppAssembler.shared.resolve())
          .tabItem {
            Label("Kessler", systemImage: "person")
          }
        HeartRateView()
          .tabItem {
            Label("Menu", systemImage: "person")
          }
        ProfileView(viewModel: AppAssembler.shared.resolve(), navigator: AppAssembler.shared.resolve())
          .tabItem {
            Label("Profile", systemImage: "person")
          }
      }
    }
  }
}

struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    HomeView()
  }
}
