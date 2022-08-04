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
        Label("Beranda", systemImage: "house")
      }.tag(1)
      NavigationView {
        KesslerTabItem(navigator: assembler.resolve(), kesslerViewModel: assembler.resolve(), tabSelection: $selection)
          .navigationTitle(navigationSetTitle(item: selection))
      }
      .tabItem {
        Label("Pengukuran", systemImage: "doc.text.magnifyingglass")
      }.tag(2)
        NavigationView {
          JournalingTabItem()
            .navigationTitle(navigationSetTitle(item: selection))
        }
        .tabItem {
          Label("Jurnal", systemImage: "pencil.and.outline")
        }.tag(3)
      NavigationView {
        ScheduleTabItem(navigator: assembler.resolve(), viewModel: assembler.resolve())
          .navigationTitle(navigationSetTitle(item: selection))
      }
      .tabItem {
        Label("Konseling", systemImage: "person.2")
      }.tag(4)
      NavigationView {
        ProfileView(viewModel: assembler.resolve(), navigator: assembler.resolve())
          .navigationTitle(navigationSetTitle(item: selection))
      }
      .tabItem {
        Label("Profil", systemImage: "person")
      }.tag(5)
    }
  }

  private func navigationSetTitle(item: Int) -> String {
    switch item {
    case 1:
      return "Beranda"
    case 2:
      return "Pengukuran Stres"
    case 3:
      return "Jurnal"
    case 4:
      return "Konseling"
    default:
      return "Profil"
    }
  }

}

struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    HomeView()
  }
}
