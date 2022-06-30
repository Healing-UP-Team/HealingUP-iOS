//
//  CircularProgressView.swift
//  HealingUP-iOS
//
//  Created by Dicky Buwono on 20/06/22.
//

import SwiftUI

struct CircularProgressView: View {
    let progress: Double
    let minimumValue: Double
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(
                  progress < minimumValue/100 ? Color.pink.opacity(0.5) : Color.blue.opacity(0.5) ,
                    lineWidth: 20
                )
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                  progress < minimumValue/100 ? Color.pink : Color.blue ,
                    style: StrokeStyle(
                        lineWidth: 20,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeOut, value: progress)

        }
    }
}
