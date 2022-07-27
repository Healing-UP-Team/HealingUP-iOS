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
  @State private var birthDate = Date()
  @State private var ageComp: DateComponents = DateComponents()
  @State private var isShowTerms = false

  var body: some View {
    NavigationView {
      VStack {
        NavigationLink(destination: navigator.navigateToWebView(url: Constant.termsLink, title: "Ketentuan Pengguna"), isActive: $isShowTerms) {
          EmptyView()
        }
        Spacer()
        VStack(alignment: .leading) {
          Text("Buat Akun")
            .font(.system(size: 40, weight: .bold))
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
            .padding(.bottom, 20)

          DatePicker(selection: $birthDate, in: ...Date(), displayedComponents: .date) {
            HStack {
              Image(systemName: "person")
                .frame(width: 30)
                .font(.system(size: 20))
                .foregroundColor(Color.gray)
              Text("Tanggal Lahir")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(Color.gray)
            }
          }
          .datePickerStyle(.compact)
          .onChange(of: birthDate, perform: { _ in
            ageComp = Calendar.current.dateComponents([.year, .month, .day], from: birthDate, to: Date())
            age = ageComp.year ?? 0
          })
          Divider()
            .background(Color.black)
            .padding(.top, 10)
            .padding(.bottom, 30)
        }
        .padding()

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

        ButtonDefaultView(title: "Daftar", action: {
          viewModel.registerUser(email: email, password: password)
        })

        Spacer()

        Button {
          isSignIn.toggle()
        } label: {
          HStack(spacing: 5) {
            Text("Sudah punya akun?")
              .foregroundColor(Color.gray)
              .font(.system(size: 17, weight: .medium))
            Text("Masuk")
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
          message: Text("\(signUpError?.localizedDescription ?? "Field tidak boleh kosong")"),
          dismissButton: .default(Text("OK"))
        )
      }
      .onViewStatable(
        viewModel.$registerState,
        onSuccess: { _ in
          NotificationService.shared.getToken { token in
            let newUser: User = .init(
              userId: DefaultFirebaseManager.shared.firebaseAuth.currentUser?.uid ?? "", role: .user,
              name: "",
              email: DefaultFirebaseManager.shared.firebaseAuth.currentUser?.email ?? "",
              age: age,
              minimumHrv: setupHrvNormal(age: age),
              fcmToken: token)
            viewModel.createUser(user: newUser)
          }
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
      .navigationBarTitle("")
      .navigationBarHidden(true)
    }
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
