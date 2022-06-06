//
//  ContentView.swift
//  HealingUp-Watch WatchKit Extension
//
//  Created by Dicky Buwono on 24/05/22.
//

import SwiftUI
import HealthKit

struct ContentView: View {
  @ObservedObject var heart = HeartHistoryTest()
  
    var body: some View {
        Text("Hello, World!")
            .padding()
            .onAppear {
              
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
