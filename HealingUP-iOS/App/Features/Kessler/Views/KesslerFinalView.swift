//
//  KesslerFinalView.swift
//  HealingUP-iOS
//
//  Created by Dicky Buwono on 06/06/22.
//

import SwiftUI

struct KesslerFinalView: View {
  var score: Int?
  var body: some View {
    VStack{
      Text("Final Score : \(score ?? 0)")
    }
  }
}

struct KesslerFinalView_Previews: PreviewProvider {
  static var previews: some View {
    KesslerFinalView(score: 10)
  }
}
