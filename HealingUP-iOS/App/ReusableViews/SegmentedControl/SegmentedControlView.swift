//
//  SegmentedControlView.swift
//  HealingUP-iOS
//
//  Created by Dicky Buwono on 04/08/22.
//

import SwiftUI

struct SegmentedControlView: View {
  @Binding private var selectedIndex: Int
  @State private var frames: [CGRect]
  @State private var backgroundFrame = CGRect.zero
  @State private var isScrollable = true

  private let titles: [String]

  init(selectedIndex: Binding<Int>, titles: [String]) {
    self._selectedIndex = selectedIndex
    self.titles = titles
    frames = [CGRect](repeating: .zero, count: titles.count)
  }

  var body: some View {
    VStack {
      if isScrollable {
        ScrollView(.horizontal, showsIndicators: false) {
          SegmentedControlButtonView(selectedIndex: $selectedIndex, frames: $frames, backgroundFrame: $backgroundFrame, isScrollable: $isScrollable, checkIsScrollable: checkIsScrollable, titles: titles)
        }
      } else {
        SegmentedControlButtonView(selectedIndex: $selectedIndex, frames: $frames, backgroundFrame: $backgroundFrame, isScrollable: $isScrollable, checkIsScrollable: checkIsScrollable, titles: titles)
      }
    }
    .background(
      GeometryReader { geoReader in
        Color.clear.preference(key: RectPreferenceKey.self, value: geoReader.frame(in: .global))
          .onPreferenceChange(RectPreferenceKey.self) {
            self.setBackgroundFrame(frame: $0)
          }
      }
    )
  }

  private func setBackgroundFrame(frame: CGRect) {
    backgroundFrame = frame
    checkIsScrollable()
  }

  private func checkIsScrollable() {
    if frames[frames.count - 1].width > .zero {
      var width = CGFloat.zero

      for frame in frames {
        width += frame.width
      }

      if isScrollable && width <= backgroundFrame.width {
        isScrollable = false
      } else if !isScrollable && width > backgroundFrame.width {
        isScrollable = true
      }
    }
  }
}

private struct SegmentedControlButtonView: View {
  @Binding private var selectedIndex: Int
  @Binding private var frames: [CGRect]
  @Binding private var backgroundFrame: CGRect
  @Binding private var isScrollable: Bool

  private let titles: [String]
  let checkIsScrollable: (() -> Void)

  init(selectedIndex: Binding<Int>, frames: Binding<[CGRect]>, backgroundFrame: Binding<CGRect>, isScrollable: Binding<Bool>, checkIsScrollable: (@escaping () -> Void), titles: [String]) {
    _selectedIndex = selectedIndex
    _frames = frames
    _backgroundFrame = backgroundFrame
    _isScrollable = isScrollable

    self.checkIsScrollable = checkIsScrollable
    self.titles = titles
  }

  var body: some View {
    HStack(spacing: 0) {
      ForEach(titles.indices, id: \.self) { index in
        Button(action: {
          withAnimation(.default) {
            selectedIndex = index
          }
        }) {
          HStack {
            Text(titles[index])
              .frame(height: 42)
              .font(.system(size: 15, weight: .semibold))
              .foregroundColor(Color(uiColor: .accentPurple))
          }
        }
        .buttonStyle(CustomSegmentButtonStyle())
        .background(
          GeometryReader { geoReader in
            Color.clear.preference(key: RectPreferenceKey.self, value: geoReader.frame(in: .global))
              .onPreferenceChange(RectPreferenceKey.self) {
                self.setFrame(index: index, frame: $0)
              }
          }
        )
      }
    }
    .modifier(UnderlineModifier(selectedIndex: selectedIndex, frames: frames))
  }

  private func setFrame(index: Int, frame: CGRect) {
    DispatchQueue.main.async {
      self.frames[index] = frame

      checkIsScrollable()
    }
  }
}

private struct CustomSegmentButtonStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration
      .label
      .padding(EdgeInsets(top: 0, leading: 0, bottom: 2, trailing: 10))
  }
}

struct RectPreferenceKey: PreferenceKey {
  typealias Value = CGRect

  static var defaultValue = CGRect.zero

  static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
    value = nextValue()
  }
}

struct UnderlineModifier: ViewModifier {
  var selectedIndex: Int
  let frames: [CGRect]

  func body(content: Content) -> some View {
    content
      .background(
        Rectangle()
          .fill(Color(uiColor: .accentPurple))
          .frame(width: frames[selectedIndex].width, height: 2)
          .offset(x: frames[selectedIndex].minX - frames[0].minX), alignment: .bottomLeading
      )
      .background(
        Rectangle()
          .fill(Color.clear)
          .frame(height: 1), alignment: .bottomLeading
      )
  }
}
