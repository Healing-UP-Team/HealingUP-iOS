//
//  AppAssembler.swift
//  HealingUP-iOS
//
//  Created by Dicky Buwono on 23/05/22.
//

import Foundation

protocol Assembler: MembershipAssembler,
                    HomeAssembler,
                    ProfileAssembler,
                    KesslerAssembler{}

class AppAssembler: Assembler {
  static let shared = AppAssembler()
}
