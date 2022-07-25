//
//  JournalView.swift
//  Semhas
//
//  Created by Muhammad Rifki Widadi on 30/06/22.
//

import SwiftUI

struct JournalView: View {
    var journal: Journal

    private var color: Color {
        Color.combColor[self.journal.emoji]!
    }

    var body: some View {
        HStack{
            Spacer(minLength: 16)
            VStack(alignment: .leading, spacing: 20) {
                Text(journal.emoji)
                    .font(.system(size: 30))
                    .frame(width: 55, height: 49)
                    .background(
                        Rectangle()
                            .fill(color)
                            .cornerRadius(16)
                    )
                    .padding(.top, 20)
                Text(journal.title)
                    .font(.system(size: 30, weight: .semibold))
                    .foregroundColor(.accentPurple)
                HStack(spacing: 9) {
                    Image(systemName: "calendar")
                        .font(.system(size: 20))
                        .foregroundColor(.accentPurple)
                    Text(journal.date)
                        .font(.system(size: 14))
                        .foregroundColor(.accentPurple)
                }

                Text(journal.note)
                    .foregroundColor(.accentPurple)
                    .font(.system(size: 14, weight: .medium))
                    .padding()
                    .frame(minWidth: UIScreen.main.bounds.width - 32, minHeight: 100, alignment: .topLeading)
                    .background(
                        Rectangle()
                            .fill(Color.softYellow)
                            .cornerRadius(16)
                    )

                Spacer()


            }
            Spacer(minLength: 16)
        }
        .navigationTitle("Journal View")
        .navigationBarTitleDisplayMode(.inline)

    }
}

struct JournalView_Previews: PreviewProvider {
    static var previews: some View {
        JournalView(journal: Journal.data[0])
    }
}
