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

    var body: some View {
      if isSignUp {
        navigator.navigateToSignUp(isSignIn: $isSignUp)
      } else {
        VStack {
          VStack {
            Image(systemName: "person")
              .font(.system(size: 200))
            Text("HealingUP")
              .font(.system(size: 50, weight: .bold))

            VStack(alignment: .leading) {
              TextField("Email", text: $email)
                .font(.system(size: 17, weight: .semibold))
              Divider()
                .background(Color.black)
                .padding(.bottom, 30)
              SecureField("Passowrd", text: $password)
                .font(.system(size: 17, weight: .semibold))
              Divider()
                .background(Color.black)
            }.padding()

            Button {
              viewModel.signInUser(email: email, password: password)
            } label: {
              Text("Login")
            }

            Spacer()
            Button {
              isSignUp.toggle()
            } label: {
              Text("Tidak punya akun? Daftar sekarang")
            }
            .padding()

          }
          .alert(isPresented: $isShowAlert) {
            Alert(
              title: Text("Gagal"),
              message: Text("\(signInError?.localizedDescription ?? "Field tidak boleh kosong")"),
              dismissButton: .default(Text("OK"))
            )
          }
          .onViewStatable(
            viewModel.$signInState,
            onSuccess: { success in
              isSignedIn = success
              isShowAlert = false
            },
            onError: { error in
              signInError = error
              isShowAlert = true
            })
          .fullScreenCover(isPresented: $isSignedIn) {
            navigator.navigateToHome()
          }
        }
        .progressHUD(isShowing: $viewModel.signInState.isLoading)
      }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
      SignInView(viewModel: AppAssembler.shared.resolve(), navigator: AppAssembler.shared.resolve())
    }
}
