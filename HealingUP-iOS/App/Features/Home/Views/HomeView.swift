//
//  HomeView.swift
//  HealingUP-iOS
//
//  Created by Dicky Buwono on 23/05/22.
//

import SwiftUI

struct HomeView: View {
  @State var selection = 1
  let assembler = AppAssembler.shared

  init() {
    setDefaultTabBarView()
    setDefaultNavigationBar()
  }

  var body: some View {
    TabView(selection: $selection) {
      NavigationView {
        HeartRateTabItem(navigator: assembler.resolve(), viewModel: assembler.resolve(), tabSelection: $selection)
          .navigationTitle(navigationSetTitle(item: selection))
      }
      .tabItem {
        Label("Heart", systemImage: "bolt.heart.fill")
      }.tag(1)
      NavigationView {
        KesslerTabItem(navigator: assembler.resolve(), kesslerViewModel: assembler.resolve())
          .navigationTitle(navigationSetTitle(item: selection))
      }
      .tabItem {
        Label("Kessler", systemImage: "doc.text.magnifyingglass")
      }.tag(2)
        NavigationView {
          JournalingTabItem(navigator: AppAssembler.shared.resolve(), journalingViewModel: AppAssembler.shared.resolve())
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
          Label("Journaling", systemImage: "pencil.and.outline")
        }.tag(3)
      NavigationView {
        ScheduleTabItem(navigator: assembler.resolve(), viewModel: assembler.resolve())
          .navigationTitle(navigationSetTitle(item: selection))
      }
      .tabItem {
        Label("Schedule", systemImage: "timer")
      }.tag(4)
      NavigationView {
        ProfileView(viewModel: assembler.resolve(), navigator: assembler.resolve())
          .navigationTitle(navigationSetTitle(item: selection))
      }
      .tabItem {
        Label("Profile", systemImage: "person")
      }.tag(5)
    }
  }

  private func navigationSetTitle(item: Int) -> String {
    switch item {
    case 1:
      return "Heart"
    case 2:
      return "Kessler"
    case 4:
      return "Schedule"
    case 3:
        return "Journaling"
    case 4:
      return "Schedule"
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
