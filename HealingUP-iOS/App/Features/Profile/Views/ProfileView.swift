//
//  ProfileView.swift
//  HealingUP-iOS
//
//  Created by Dicky Buwono on 24/05/22.
//

import SwiftUI

struct ProfileMenu: Hashable {
  var menu: ProfileMenuEnum
  var image: String
}

enum ProfileMenuEnum: String {
  case personalInfo = "Informasi Personal"
  case aboutUs = "Tentang Kami"
  case terms = "Ketentuan Pengguna"
}

struct ProfileView: View {
  @ObservedObject var viewModel: MembershipViewModel
  let navigator: ProfileNavigator
  @State var isSignOut = false
  @State var profile: User?
  @State private var isShowAlert = false
  let profileMenuSectionOne: [ProfileMenu] = [
    .init(menu: .personalInfo, image: "person.crop.circle")
  ]
  let profileMenuSectionTwo: [ProfileMenu] = [
    .init(menu: .aboutUs, image: "person.2"),
    .init(menu: .terms, image: "doc.text")
  ]

  var body: some View {
    ScrollView(showsIndicators: false) {
      VStack {
        Image(uiImage: .appIcon)
          .resizable()
          .scaledToFit()
          .frame(height: UIScreen.main.bounds.height/4)
          .padding()

        Text(profile?.name ?? "Your Name")
          .font(.system(size: 20, weight: .semibold))
          .padding(.bottom)

        ForEach(profileMenuSectionOne, id: \.self) { item in
          NavigationLink(
            destination:
              Group {
                if item.menu == .personalInfo {
                  Text(item.menu.rawValue)
                }
              }
          ) {
            HStack {
              Image(systemName: item.image)
                .foregroundColor(Color.gray)
                .font(.system(size: 20))
                .frame(width: 30)
              Text(item.menu.rawValue)
                .foregroundColor(Color.black)
              Spacer()
              Image(systemName: "chevron.right")
                .foregroundColor(Color.gray)
            }
            .padding(.horizontal)
            .padding(.top)
          }
        }

        Divider()
          .padding()

        ForEach(profileMenuSectionTwo, id: \.self) { item in
          NavigationLink(
            destination:
              Group {
                if item.menu == .aboutUs {
                  navigator.navigateToWebView(url: Constant.aboutUsLink, title: "Tentang Kami")
                }
                if item.menu == .terms {
                  navigator.navigateToWebView(url: Constant.termsLink, title: "Ketentuan Pengguna")
                }
              }
          ) {
            HStack {
              Image(systemName: item.image)
                .foregroundColor(Color.gray)
                .font(.system(size: 20))
                .frame(width: 30)
              Text(item.menu.rawValue)
                .foregroundColor(Color.black)
              Spacer()
              Image(systemName: "chevron.right")
                .foregroundColor(Color.gray)
            }
            .padding(.horizontal)
            .padding(.top)
          }
        }
        Button {
          isShowAlert = true
        } label: {
          HStack {
            Image(systemName: "escape")
              .foregroundColor(Color.gray)
              .font(.system(size: 20))
              .frame(width: 30)
            Text("Keluar")
              .foregroundColor(Color.black)
            Spacer()
          }.padding()
        }
      }
      .onViewStatable(
        viewModel.$userState,
        onSuccess: { data in
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
    .alert(isPresented: $isShowAlert) {
      Alert(
        title: Text("Are you sure?"),
        message: Text("You will be logged out and have to log in again."),
        primaryButton: .destructive(Text("OK")) {
          viewModel.signOutUser()
        },
        secondaryButton: .cancel()
      )
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
