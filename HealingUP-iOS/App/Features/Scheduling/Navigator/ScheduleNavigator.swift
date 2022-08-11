//
//  ScheduleNavigator.swift
//  HealingUP-iOS
//
//  Created by Dicky Buwono on 19/07/22.
//

import Foundation
import UIKit

struct ScheduleNavigator {
  private let assembler: Assembler

  init(assembler: Assembler) {
    self.assembler = assembler
  }

  func naviageteToCounsellorChoice() -> CounsellorChoiceView {
    return CounsellorChoiceView(membershipViewModel: assembler.resolve(), navigator: assembler.resolve())
  }

  func navigateToChooseTime(counsellor: User) -> ChooseTimeView {
    return ChooseTimeView(viewModel: assembler.resolve(), membershipViewModel: assembler.resolve(), counsellor: counsellor, navigator: assembler.resolve())
  }

  func navigateToResult(title: String, icon: UIImage, message: String, buttonTitle: String) -> ResultView {
    return ResultView(title: title, icon: icon, message: message, buttonTitle: buttonTitle, buttonAction: {})
  }

  func navigateToScheduleConfirm(isConfirm: Bool, schedule: Schedule) -> CounsellorConfirmScheduleView {
    return CounsellorConfirmScheduleView(isConfirm: isConfirm, schedule: schedule, membershipViewModel: assembler.resolve(), scheduleViewModel: assembler.resolve(), kesslerViewModel: assembler.resolve(), navigator: assembler.resolve())
  }

  func navigateToScheduleDetail(schedule: Schedule) -> SchedulingDetailView {
    return SchedulingDetailView(schedule: schedule, membershipViewModel: assembler.resolve(), scheduleViewModel: assembler.resolve())
  }
}
