//
//  TermsView.swift
//  HealingUP-iOS
//
//  Created by Dicky Buwono on 26/07/22.
//

import SwiftUI

struct TermsView: View {
  @ObservedObject var webViewModel = WebViewModel(url: Constant.termsLink)

  var body: some View {
    ZStack {
      WebViewContainer(webViewModel: webViewModel)
        .progressHUD(isShowing: $webViewModel.isLoading)
    }
    .navigationBarTitle(Text("Ketentuan Pengguna"), displayMode: .inline)
    .navigationBarItems(leading: Button(action: {
      webViewModel.shouldGoBack.toggle()
    }, label: {
      if webViewModel.canGoBack {
        Image(systemName: "arrow.left")
          .frame(width: 44, height: 44, alignment: .center)
          .foregroundColor(.black)
      } else {
        EmptyView()
          .frame(width: 0, height: 0, alignment: .center)
      }
    })
    )
  }
}

struct TermsView_Previews: PreviewProvider {
  static var previews: some View {
    TermsView()
  }
}
