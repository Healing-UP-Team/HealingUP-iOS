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
    Color.combColor[self.journal.emoji] ?? .accentPurple
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
          Text(journal.date.toStringWith(format: "EE, dd MMM yyyy") ?? "")
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
  static var journal = Journal(emoji: "🫠", title: "tes", note: "tes", date: Date())
  static var previews: some View {
    List(0..<5) { _ in
      JournalCell(journal: journal)
        .previewLayout(.fixed(width: 400, height: 100))
    }.listStyle(.inset)
  }
}
