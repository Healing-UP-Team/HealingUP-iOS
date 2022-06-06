//
//  ProfileView.swift
//  HealingUP-iOS
//
//  Created by Dicky Buwono on 24/05/22.
//

import SwiftUI

struct ProfileView: View {
  
  @ObservedObject var viewModel: MembershipViewModel
  let navigator: ProfileNavigator
  @State var name = ""
  @State var isSignOut = false
  @State var profile: User?
  
  var body: some View {
    VStack {
      VStack {
        Text("Hi!")
        Text(name)
        
        Button {
          viewModel.signOutUser()
        } label: {
          Text("Logout")
        }
      }
      .onViewStatable(
        viewModel.$userState,
        onSuccess: { data in
          name = data.email
          profile = data
          
        })
      .onViewStatable(
        viewModel.$signOutState,
        onSuccess: { success in
          isSignOut = success
        })
    }
    .onAppear {
      viewModel.fetchUser()
    }
    .fullScreenCover(isPresented: $isSignOut) {
      navigator.navigateToSignIn()
    }
    .progressHUD(isShowing: $viewModel.userState.isLoading)
    .progressHUD(isShowing: $viewModel.signOutState.isLoading)
  }
}

struct ProfileView_Previews: PreviewProvider {
  static var previews: some View {
    ProfileView(viewModel: AppAssembler.shared.resolve(), navigator: AppAssembler.shared.resolve())
  }
}
