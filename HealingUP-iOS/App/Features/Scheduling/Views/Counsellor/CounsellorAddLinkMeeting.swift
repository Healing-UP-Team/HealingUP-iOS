//
//  CounsellorAddLinkMeeting.swift
//  HealingUP-iOS
//
//  Created by Muhammad Rifki Widadi on 07/08/22.
//

import SwiftUI
import SwiftUICharts

struct CounsellorAddLinkMeeting: View {
  var action: () -> Void
  @Binding var link: String
  var isAdd: Bool

  @State private var isLinkFilled = false
  @Environment(\.presentationMode) private var presentationMode
  var body: some View {
    VStack(spacing: 5) {
      HStack {
        Text(isAdd ? "Tambah tautan" : "Ubah tautan")
        .font(.system(size: 30))
        .fontWeight(.bold)
        .padding(.horizontal)
        .foregroundColor(.accentPurple)
        Spacer()
        Button {
          presentationMode.wrappedValue.dismiss()
        } label: {
          Image(systemName: "xmark")
            .font(.system(size: 20, weight: .bold))
            .frame(width: 20, height: 20)
            .padding()
            .foregroundColor(Color.accentPurple)
            .background(
              Circle()
                .fill(Color.accentPurple.opacity(0.1))
            ).padding()
        }

      }
      VStack(alignment: .leading) {
          TextEditor(text: $link)
            .padding()
            .background(
              RoundedRectangle(cornerRadius: 16)
                .stroke(Color.accentPurple, lineWidth: 4)
            )
            .padding()
          HStack {
            Spacer()
            Button("Tambahkan Tautan") {
              if link.isEmpty {
                isLinkFilled.toggle()
              } else {
                action()
                presentationMode.wrappedValue.dismiss()
              }
            }.foregroundColor(.white)
            Spacer()
          }
          .padding()
          .background(Color.accentPurple)
          .cornerRadius(12)
          .padding(.horizontal)
          Spacer()

        .alert(isPresented: $isLinkFilled) {
          Alert(title: Text("Link belum diisi"), message: Text("Apakah kamu yakin sudah mengisi link?"), dismissButton: .default(Text("Ok, Saya mengerti")))
        }
      }
    }
  }
}

struct CounsellorAddLinkMeeting_Previews: PreviewProvider {
  static var previews: some View {
    CounsellorAddLinkMeeting(action: {}, link: .constant(""), isAdd: true)
  }
}
