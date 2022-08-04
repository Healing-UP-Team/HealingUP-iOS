//
//  ScheduleCardComponentView.swift
//  HealingUP-iOS
//
//  Created by Dicky Buwono on 04/08/22.
//

import SwiftUI

struct ScheduleCardComponentView: View {
  @StateObject var viewModel: MembershipViewModel

  init(viewModel: MembershipViewModel) {
    _viewModel = StateObject(wrappedValue: viewModel)
  }

  var body: some View {
    HStack(alignment: .top) {
      VStack(alignment: .leading) {
        Text(viewModel.counselorName)
          .font(.system(size: 17, weight: .semibold))
          .foregroundColor(Color(uiColor: .accentPurple))
          .padding(.bottom, 5)
        Text(viewModel.schedule?.schedule.toStringWith(format: "EE, dd MMM yyyy") ?? "")
          .font(.system(size: 15, weight: .medium))
          .foregroundColor(Color(uiColor: .accentPurple))
      }
      Spacer()
      Text(viewModel.schedule?.status.rawValue ?? "")
        .font(.system(size: 13, weight: .semibold))
        .foregroundColor(Color(uiColor: .accentPurple))
        .padding(.vertical, 5)
        .padding(.horizontal, 10)
        .background(Color(uiColor: .softYellow))
        .cornerRadius(12)
    }
    .padding()
    .background(Color(uiColor: .softBlue))
    .cornerRadius(20)
    .onAppear {
      viewModel.viewOnListSchedule()
    }
  }
}
