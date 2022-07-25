//
//  JournalCell.swift
//  Semhas
//
//  Created by Muhammad Rifki Widadi on 30/06/22.
//

import SwiftUI

struct JournalCell: View {
    var journal: Journal

    private var color: Color {
        Color.combColor[self.journal.emoji]!
    }

    private var textColor: Color {
        color == .accentPurple ? .white : .black
    }

    var body: some View {
        HStack {
            Text(journal.emoji)
                .font(.system(size: 30))
                .frame(width: 55, height: 49)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(.white, lineWidth: 1)
                )
                .padding()
            VStack(alignment: .leading, spacing: 8) {
                Text(journal.title)
                    .font(.system(size: 16))
                    .fontWeight(.medium)
                    .foregroundColor(textColor)
                HStack(spacing: 8) {
                    Image(systemName: "calendar")
                        .font(.system(size: 10))
                        .foregroundColor(textColor)
                    Text(journal.date)
                        .font(.system(size: 10))
                        .foregroundColor(textColor)
                }
            }
        }
        .frame(width: 358, height: 80, alignment: .leading)
        .background(
            Rectangle()
                .fill(color)
                .cornerRadius(16)
        )
    }
}

struct JournalCell_Previews: PreviewProvider {
    static var emoji = Emotion.data[0]
    static var previews: some View {
        JournalCell(journal: Journal(emoji: emoji.emoji, title: "Jogging", note: "Pagi itu saya joging kesana kemari dengan indah", date: "Rab, 27 Juli 2021"))
            .previewLayout(.fixed(width: 400, height: 100))
    }
}
