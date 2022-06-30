//
//  CircularProgressView.swift
//  HealingUp-Watch WatchKit Extension
//
//  Created by Dicky Buwono on 27/06/22.
//

import SwiftUI

struct CircularProgressView: View {
    let progress: Double
    let minimumValue: Double
    let strokeWidth: Double
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(
                  progress < minimumValue/100 ? Color.pink.opacity(0.5) : Color.blue.opacity(0.5) ,
                    lineWidth: strokeWidth
                )
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                  progress < minimumValue/100 ? Color.pink : Color.blue ,
                    style: StrokeStyle(
                        lineWidth: strokeWidth,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeOut, value: progress)

        }
    }
}
