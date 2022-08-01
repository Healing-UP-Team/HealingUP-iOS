//
//  SignInView.swift
//  HealingUP-iOS
//
//  Created by Dicky Buwono on 23/05/22.
//

import SwiftUI

struct SignInView: View {
  @ObservedObject var viewModel: MembershipViewModel
  @ObservedObject var heartViewModel = HeartRateViewModel()
  let navigator: HomeNavigator

  @State var isSignUp = false
  @State var email = ""
  @State var password = ""
  @State private var signInError: Error?
  @State private var isShowAlert = false
  @State private var isSignedIn = false
  @State var user: User?
  @State var isShowTerms = false

  var body: some View {
    if isSignUp {
      navigator.navigateToSignUp(isSignIn: $isSignUp)
    } else {
      NavigationView {
        VStack {
          NavigationLink(destination: navigator.navigateToWebView(url: Constant.termsLink, title: "Ketentuan Pengguna"), isActive: $isShowTerms) {
            EmptyView()
          }
          VStack(alignment: .center) {
            Spacer()
            VStack(alignment: .leading) {
              Text("Masuk")
                .font(.system(size: 40, weight: .bold))
                .padding(.bottom, 2)
              Text("Silahkan masuk untuk melanjutkan.")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(Color.gray)
                .padding(.bottom, 50)
              HStack {
                Image(systemName: "envelope")
                  .frame(width: 30)
                  .font(.system(size: 20))
                  .foregroundColor(Color.gray)
                TextField("Email", text: $email)
                  .font(.system(size: 17, weight: .semibold))
                  .textContentType(.emailAddress)
              }
              Divider()
                .background(Color.black)
                .padding(.top, 10)
                .padding(.bottom, 30)
              HStack {
                Image(systemName: "lock")
                  .frame(width: 30)
                  .font(.system(size: 20))
                  .foregroundColor(Color.gray)
                SecureInputView("Kata Sandi", text: $password)
                  .font(.system(size: 17, weight: .semibold))
              }
              Divider()
                .background(Color.black)
                .padding(.top, 10)
                .padding(.bottom, 30)
            }
            .padding(.horizontal)

            VStack(alignment: .center) {
              Text("Dengan masuk atau mendaftar, saya menyetujui")
                .font(.system(size: 12, weight: .regular))
              Button {
                isShowTerms = true
              } label: {
                Text("Ketentuan Pengguna Healing UP")
                  .underline()
                  .font(.system(size: 12, weight: .bold))
              }
            }

            .padding(.bottom, 50)

            ButtonDefaultView(title: "Masuk", action: {
              viewModel.signInUser(email: email, password: password)
            })
            Spacer()
            Button {
              isSignUp.toggle()
            } label: {
              HStack(spacing: 5) {
                Text("Tidak punya akun?")
                  .foregroundColor(Color.gray)
                  .font(.system(size: 17, weight: .medium))
                Text("Daftar")
                  .foregroundColor(Color(uiColor: .accentPurple))
                  .font(.system(size: 17, weight: .bold))
              }
            }
            .padding()
          }
          .padding()
          .alert(isPresented: $isShowAlert) {
            Alert(
              title: Text("Gagal"),
              message: Text("\(signInError?.localizedDescription ?? "Field tidak boleh kosong")"),
              dismissButton: .default(Text("OK"))
            )
          }
          .onViewStatable(
            viewModel.$signInState,
            onSuccess: { _ in
              isShowAlert = false
              viewModel.fetchUser()
            },
            onError: { error in
              signInError = error
              isShowAlert = true
            })
          .onViewStatable(
            viewModel.$userState,
            onSuccess: { data in
              user = data
              var currentUser = data
              NotificationService.shared.getToken { token in
                currentUser.fcmToken = token
                viewModel.updateUser(user: currentUser)
              }
              if data.role == .psikolog {
                SessionManager.setUserCounsellor()
              } else {
                SessionManager.setUserNotCounsellor()
              }
              isSignedIn = true
              isShowAlert = false
            }
          )
          .fullScreenCover(isPresented: $isSignedIn) {
            if user?.role == .psikolog {
              navigator.navigateToHomeCounsellor()
            } else {
              navigator.navigateToHome()
            }
          }
        }
        .progressHUD(isShowing: $viewModel.signInState.isLoading)
        .progressHUD(isShowing: $viewModel.userState.isLoading)
        .navigationBarTitle("")
        .navigationBarHidden(true)
      }
    }
  }
}

struct SignInView_Previews: PreviewProvider {
  static var previews: some View {
    SignInView(viewModel: AppAssembler.shared.resolve(), navigator: AppAssembler.shared.resolve())
  }
}

struct CheckBoxView: View {
  @Binding var checked: Bool

  var body: some View {
    Image(systemName: checked ? "checkmark.square.fill" : "square")
      .foregroundColor(checked ? Color(UIColor.systemBlue) : Color.secondary)
      .onTapGesture {
        self.checked.toggle()
      }
  }
}
