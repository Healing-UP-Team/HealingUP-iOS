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
  
  @State private var age = 0
  
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
        
        Text("Your age")
          .font(.system(size: 17, weight: .semibold))
          .padding(.top)
        Picker("", selection: $age) {
          ForEach(1...70, id: \.self) { number in
            Text("\(number) \tyears old")
              .font(.system(size: 17, weight: .semibold))
          }
        }
        .pickerStyle(.wheel)
        
      }.padding()
      Spacer()
      Button {
        viewModel.registerUser(email: email, password: password)
      } label: {
        Text("Daftar")
      }
      
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
        let newUser: User = .init(
          userId: DefaultFirebaseManager.shared.firebaseAuth.currentUser?.uid ?? "", role: .user,
          name: "",
          email: DefaultFirebaseManager.shared.firebaseAuth.currentUser?.email ?? "",
          age: age,
          minimumHrv: setupHrvNormal(age: age))
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
  
  private func setupHrvNormal(age: Int) -> Double {
    if age <= 25 {
      return 55
    } else if age > 25 && age <= 30 {
      return 45
    } else if age > 30 && age <= 35 {
      return 40
    } else if age > 35 && age <= 40 {
      return 35
    } else if age > 40 && age <= 50 {
      return 30
    } else {
      return 25
    }
  }
}

struct SignUpView_Previews: PreviewProvider {
  static var previews: some View {
    SignUpView(viewModel: AppAssembler.shared.resolve(), navigator: AppAssembler.shared.resolve(), isSignIn: .constant(false))
  }
}
