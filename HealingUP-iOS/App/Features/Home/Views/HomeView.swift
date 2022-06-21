//
//  HomeView.swift
//  HealingUP-iOS
//
//  Created by Dicky Buwono on 23/05/22.
//

import SwiftUI

struct HomeView: View {
  @State var selection = 1
  @State var uiTabarController: UITabBarController?
  
  var body: some View {
    TabView(selection: $selection) {
      NavigationView {
        HeartRateTabItem(navigator: AppAssembler.shared.resolve(), viewModel: AppAssembler.shared.resolve(), tabSelection: $selection)
          .navigationTitle(navigationSetTitle(item: selection))
          .introspectTabBarController { (UITabBarController) in
            UITabBarController.tabBar.isHidden = false
            uiTabarController = UITabBarController
          }
          .onAppear {
            uiTabarController?.tabBar.isHidden = false
          }
      }
      .tabItem {
        Label("HRV", systemImage: "person")
      }.tag(1)
      NavigationView {
        KesslerTabItem(navigator: AppAssembler.shared.resolve(), kesslerViewModel: AppAssembler.shared.resolve())
          .navigationTitle(navigationSetTitle(item: selection))
          .introspectTabBarController { (UITabBarController) in
            UITabBarController.tabBar.isHidden = false
            uiTabarController = UITabBarController
          }
          .onAppear {
            uiTabarController?.tabBar.isHidden = false
          }
      }
      .tabItem {
        Label("Kessler", systemImage: "person")
      }.tag(2)
      NavigationView {
        KesslerDataTabItem(kesslerViewModel: AppAssembler.shared.resolve())
          .navigationTitle(navigationSetTitle(item: selection))
          .introspectTabBarController { (UITabBarController) in
            UITabBarController.tabBar.isHidden = false
            uiTabarController = UITabBarController
          }
          .onAppear {
            uiTabarController?.tabBar.isHidden = false
          }
      }
      .tabItem {
        Label("History", systemImage: "clock.arrow.circlepath")
      }.tag(3)
      NavigationView {
        ProfileView(viewModel: AppAssembler.shared.resolve(), navigator: AppAssembler.shared.resolve())
          .navigationTitle(navigationSetTitle(item: selection))
          .introspectTabBarController { (UITabBarController) in
            UITabBarController.tabBar.isHidden = false
            uiTabarController = UITabBarController
          }
          .onAppear {
            uiTabarController?.tabBar.isHidden = false
          }
      }
      .tabItem {
        Label("Profile", systemImage: "person")
      }.tag(4)
    }
  }
  
  private func navigationSetTitle(item: Int) -> String {
    switch item {
    case 1:
      return "Heart Rate Variability"
    case 2:
      return "Kessler"
    case 3:
      return "History"
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
