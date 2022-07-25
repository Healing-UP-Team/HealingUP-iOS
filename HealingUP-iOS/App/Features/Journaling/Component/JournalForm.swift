//
//  CustomUIPicker.swift
//  Semhas
//
//  Created by Muhammad Rifki Widadi on 06/07/22.
//

import SwiftUI

struct JournalForm: View {
    @ObservedObject var jvm = JournalViewModel()

    @State var title: String = ""
    @State var notes: String = ""
    @Environment(\.presentationMode) var presentationMode

    private let emotions = Emotion.data

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.softPinkSecond
            HStack {
                Spacer()
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label : {
                    Image(systemName: "xmark")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.white)
                        .padding()
                        .background(
                            Circle()
                                .fill(Color.accentPurple)
                                .frame(width: 30, height: 30)
                        )
                }
            }
            VStack(alignment: .leading, spacing: 30) {
                HStack {
                    Text(jvm.emoji.emoji)
                        .font(.system(size: 45))
                        .frame(width: 55, height: 49)
                        .padding()
                        .background(
                            Rectangle()
                                .fill(Color.softPinkFirst)
                                .cornerRadius(16)
                        )
                        .contextMenu {
                            ForEach(emotions) { item in
                                Button {
                                    jvm.emoji = item
                                } label: {
                                    HStack {
                                        Text(item.desc)
                                    }.tag(item)
                                }


                            }
                        }
                }


                TextField("What is it about?", text: $title)
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(Color.accentPurple)

                    TextEditor(text: $notes)
                        .cornerRadius(12)
                        .opacity(0.5)


                HStack {
                    Spacer()
                    Button {
                        //                        vm.date = Date.now.formatted()

                    } label: {
                        Text("Save")
                            .padding()
                            .foregroundColor(.white)
                    }
                    Spacer()
                }
                .background(Color.accentPurple)
                .cornerRadius(12)
                .padding(.bottom, 50)

            }.padding([.leading, .trailing])
                .padding(.top, 50)
        }
        .ignoresSafeArea()
    }
}


struct CustomUIPicker_Previews: PreviewProvider {
    static var previews: some View {
        JournalForm()
            .previewLayout(.sizeThatFits)
    }
}
