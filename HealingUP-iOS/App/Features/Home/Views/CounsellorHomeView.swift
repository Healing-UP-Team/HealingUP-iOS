//
//  CounsellorHomeView.swift
//  HealingUP-iOS
//
//  Created by Dicky Buwono on 20/07/22.
//

import SwiftUI

struct CounsellorHomeView: View {
  @State var selection = 1
  let assembler = AppAssembler.shared

  init() {
    setDefaultNavigationBar()
    setDefaultTabBarView()
  }

  var body: some View {
    TabView(selection: $selection) {
      NavigationView {
        CounsellorScheduleTabItem(navigator: assembler.resolve(), viewModel: assembler.resolve())
          .navigationTitle(navigationSetTitle(item: selection))
      }
      .tabItem {
        Label("Konseling", systemImage: "person.2")
      }.tag(1)
      NavigationView {
        ProfileView(viewModel: assembler.resolve(), navigator: assembler.resolve())
          .navigationTitle(navigationSetTitle(item: selection))
      }
      .tabItem {
        Label("Profil", systemImage: "person")
      }.tag(2)
    }
  }

  private func navigationSetTitle(item: Int) -> String {
    switch item {
    case 1:
      return "Konseling"
    default:
      return "Profil"
    }
  }
}

struct CounsellorHomeView_Previews: PreviewProvider {
  static var previews: some View {
    CounsellorHomeView()
  }
}
