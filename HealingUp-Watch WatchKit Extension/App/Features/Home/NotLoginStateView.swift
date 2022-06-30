//
//  NotLoginStateView.swift
//  HealingUp-Watch WatchKit Extension
//
//  Created by Dicky Buwono on 27/06/22.
//

import SwiftUI

struct NotLoginStateView: View {
  @ObservedObject var heart = HeartRateViewModel()
  
    var body: some View {
      Text("Please login on your iPhone")
    }
}

struct NotLoginStateView_Previews: PreviewProvider {
    static var previews: some View {
        NotLoginStateView()
    }
}
