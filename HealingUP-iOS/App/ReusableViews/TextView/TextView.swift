//
//  TextView.swift
//  HealingUP-iOS
//
//  Created by Dicky Buwono on 19/07/22.
//

import SwiftUI

struct TextView: UIViewRepresentable {
  @Binding var text: String

  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }

  func makeUIView(context: Context) -> UITextView {
    let myTextView = UITextView()
    let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: myTextView.frame.size.width, height: 44))
    let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
    let doneButton = UIBarButtonItem(title: "Done", image: nil, primaryAction: context.coordinator.doneAction)

    myTextView.delegate = context.coordinator
    myTextView.font = UIFont.systemFont(ofSize: 15)
    myTextView.isScrollEnabled = true
    myTextView.isEditable = true
    myTextView.isUserInteractionEnabled = true
    myTextView.backgroundColor = UIColor.softYellow

    toolBar.setItems([flexibleSpace, doneButton], animated: true)
    myTextView.inputAccessoryView = toolBar

    return myTextView
  }

  func updateUIView(_ uiView: UITextView, context: Context) {
    uiView.text = text
  }

  class Coordinator: NSObject, UITextViewDelegate {
    var parent: TextView
    lazy var doneAction = UIAction(handler: doneButtonTapped(action:))

    init(_ uiTextView: TextView) {
      self.parent = uiTextView
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
      return true
    }

    func textViewDidChange(_ textView: UITextView) {
      self.parent.text = textView.text
    }

    private func doneButtonTapped(action: UIAction) {
      UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
  }
}
