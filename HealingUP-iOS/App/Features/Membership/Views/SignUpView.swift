//
//  SignUpView.swift
//  HealingUP-iOS
//
//  Created by Dicky Buwono on 23/05/22.
//

import SwiftUI

struct SignUpView: View {
  @ObservedObject var viewModel: MembershipViewModel
  let navigator: HomeNavigator
  
  @State var email = ""
  @State var password = ""
  @Binding var isSignIn: Bool
  @State private var signUpError: Error?
  @State private var isShowAlert = false
  @State private var isSignedIn = false
  
  var body: some View {
    VStack {
      Spacer()
      VStack(alignment: .leading) {
        TextField("Email", text: $email)
          .font(.system(size: 17, weight: .semibold))
        Divider()
          .background(Color.black)
          .padding(.bottom, 30)
        SecureField("Password", text: $password)
          .font(.system(size: 17, weight: .semibold))
        Divider()
          .background(Color.black)
      }.padding()
      
      Button {
        viewModel.registerUser(email: email, password: password)
      } label: {
        Text("Daftar")
      }
      
      Spacer()
      Button {
        isSignIn.toggle()
      } label: {
        Text("Sudah punya akun? login sekarang")
      }
      .padding()
    }
    .alert(isPresented: $isShowAlert) {
      Alert(
        title: Text("Gagal"),
        message: Text("\(signUpError?.localizedDescription ?? "Field tidak boleh kosong")"),
        dismissButton: .default(Text("OK"))
      )
    }
    
    .onViewStatable(
      viewModel.$registerState,
      onSuccess: { _ in
        let newUser: User = .init(userId: DefaultFirebaseManager.shared.firebaseAuth.currentUser?.uid ?? "", role: .user, name: "", email: DefaultFirebaseManager.shared.firebaseAuth.currentUser?.email ?? "")
        viewModel.createUser(user: newUser)
      },
      onError: { error in
        signUpError = error
        isShowAlert = true
      })
    .onViewStatable(
      viewModel.$createUserState,
      onSuccess: { success in
        isSignedIn = success
        isShowAlert = false
      },
      onError: { error in
        signUpError = error
        isShowAlert = true
      })
    .fullScreenCover(isPresented: $isSignedIn) {
      navigator.navigateToHome()
    }
    .progressHUD(isShowing: $viewModel.registerState.isLoading)
    .progressHUD(isShowing: $viewModel.createUserState.isLoading)
  }
}

struct SignUpView_Previews: PreviewProvider {
  static var previews: some View {
    SignUpView(viewModel: AppAssembler.shared.resolve(), navigator: AppAssembler.shared.resolve(), isSignIn: .constant(false))
  }
}
