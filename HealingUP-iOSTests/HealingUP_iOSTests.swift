//
//  HealingUP_iOSTests.swift
//  HealingUP-iOSTests
//
//  Created by Dicky Buwono on 04/07/22.
//

import XCTest
@testable import Healing_UP

class HealingUP_iOSTests: XCTestCase {
  
  //MARK: Test for stress level 1
  func test_Calculate_StresLevelOne_ShouldBeTrue() {
    let answer = [0,0,0,1,1,1,1,0,0,1]
    var result = 0

    for i in answer {
      result += calculateScore(input: i)
    }
    
    XCTAssertTrue(result <= 19)
  }
  
  func test_Calculate_StresLevelOne_ShouldBeFalse() {
    let answer = [5,1,1,1,1,1,5,5,5,1]
    var result = 0

    for i in answer {
      result += calculateScore(input: i)
    }
    
    XCTAssertFalse(result <= 19)
  }
  
  //MARK: Test for stress level 2
  func test_Calculate_StresLevelTwo_ShouldBeTrue() {
    let answer = [0,0,0,4,0,0,1,2,2,2]
    var result = 0

    for i in answer {
      result += calculateScore(input: i)
    }
    
    XCTAssertTrue(result >= 20 && result <= 24)
  }
  
  func test_Calculate_StresLevelTwo_ShouldBeFalse() {
    let answer = [0,0,0,0,0,1,0,0,0,0]
    var result = 0

    for i in answer {
      result += calculateScore(input: i)
    }
    
    XCTAssertFalse(result >= 20 && result <= 24)
  }
  
  //MARK: Test for stress level 3
  func test_Calculate_StresLevelThree_ShouldBeTrue() {
    let answer = [1,1,1,1,1,3,3,1,1,2]
    var result = 0

    for i in answer {
      result += calculateScore(input: i)
    }
    
    XCTAssertTrue(result >= 24 && result <= 29)
  }
  
  func test_Calculate_StresLevelThree_ShouldBeFalse() {
    let answer = [1,1,1,1,1,1,0,0,1,2]
    var result = 0

    for i in answer {
      result += calculateScore(input: i)
    }
    
    XCTAssertFalse(result >= 24 && result <= 29)
  }
  
  //MARK: Test for stress level 4
  func test_Calculate_StresLevelFour_ShouldBeTrue() {
    let answer = [4,4,4,4,4,3,4,3,4,4]
    var result = 0

    for i in answer {
      result += calculateScore(input: i)
    }
    
    XCTAssertTrue(result > 29)
  }
  
  func test_Calculate_StresLevelFour_ShouldBeFalse() {
    let answer = [1,1,1,1,1,1,0,0,1,2]
    var result = 0

    for i in answer {
      result += calculateScore(input: i)
    }
    
    XCTAssertFalse(result > 29)
  }
  
  
  func calculateScore(input: Int) -> Int {
    if input == 0 {
      return 1
    } else if input == 1 {
      return 2
    } else if input == 2 {
      return 3
    } else if input == 3 {
      return 4
    } else {
      return 5
    }
  }

}
