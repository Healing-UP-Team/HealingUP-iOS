//
//  HealingUP_iOSUITests.swift
//  HealingUP-iOSUITests
//
//  Created by Dicky Buwono on 04/07/22.
//

import XCTest

class HealingUP_iOSUITests: XCTestCase {
  let app = XCUIApplication()
  
  override func setUpWithError() throws {
    continueAfterFailure = false
    XCUIApplication().launch()
  }
  
  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  //MARK: Test for stress level 1
  func test_StressLevelOne_ShouldbeTrue() {
    let pengukuranTab = app.tabBars["Tab Bar"].buttons["Pengukuran"]
    let mulaiButton = app.buttons["Mulai"]
    let jarangButton = app.buttons["Jarang"]
    let tidakPernahButton = app.buttons["Tidak pernah"]
    let tingkatStresKamuAlamiElement = app.scrollViews.otherElements.containing(.staticText, identifier:"Baik-baik saja").element
    
    pengukuranTab.tap()
    mulaiButton.tap()
    
    tidakPernahButton.tap()
    tidakPernahButton.tap()
    tidakPernahButton.tap()
    jarangButton.tap()
    jarangButton.tap()
    jarangButton.tap()
    jarangButton.tap()
    tidakPernahButton.tap()
    tidakPernahButton.tap()
    jarangButton.tap()
    
    XCTAssertTrue(tingkatStresKamuAlamiElement.exists)
  }
  
  func test_StressLevelOne_ShouldbeFalse() {
    let pengukuranTab = app.tabBars["Tab Bar"].buttons["Pengukuran"]
    let mulaiButton = app.buttons["Mulai"]
    let jarangButton = app.buttons["Jarang"]
    let seringButton =  app.buttons["Sering"]
    let tingkatStresKamuAlamiElement = app.scrollViews.otherElements.containing(.staticText, identifier:"Mengalami stres ringan").element
    
    pengukuranTab.tap()
    mulaiButton.tap()
    
    seringButton.tap()
    jarangButton.tap()
    jarangButton.tap()
    jarangButton.tap()
    jarangButton.tap()
    jarangButton.tap()
    seringButton.tap()
    seringButton.tap()
    seringButton.tap()
    jarangButton.tap()
    
    XCTAssertFalse(tingkatStresKamuAlamiElement.exists)
  }
  
  
  //MARK: Test for stress level 2
  func test_StressLevelTwo_ShouldbeTrue() {
    let pengukuranTab = app.tabBars["Tab Bar"].buttons["Pengukuran"]
    let mulaiButton = app.buttons["Mulai"]
    let jarangButton = app.buttons["Jarang"]
    let kadangKadangButton = app.buttons["Kadang-kadang"]
    let tidakPernahButton = app.buttons["Tidak pernah"]
    let seringButton =  app.buttons["Sering"]
    let tingkatStresKamuAlamiElement = app.scrollViews.otherElements.containing(.staticText, identifier:"Mengalami stres ringan").element
    
    pengukuranTab.tap()
    mulaiButton.tap()
    
    jarangButton.tap()
    jarangButton.tap()
    tidakPernahButton.tap()
    tidakPernahButton.tap()
    kadangKadangButton.tap()
    tidakPernahButton.tap()
    jarangButton.tap()
    kadangKadangButton.tap()
    kadangKadangButton.tap()
    seringButton.tap()
    
    XCTAssertTrue(tingkatStresKamuAlamiElement.exists)
  }
  
  func test_StressLevelTwo_ShouldbeFalse() {
    let pengukuranTab = app.tabBars["Tab Bar"].buttons["Pengukuran"]
    let mulaiButton = app.buttons["Mulai"]
    let jarangButton = app.buttons["Jarang"]
    let tidakPernahButton = app.buttons["Tidak pernah"]
    let tingkatStresKamuAlamiElement = app.scrollViews.otherElements.containing(.staticText, identifier:"Mengalami stres ringan").element
    
    pengukuranTab.tap()
    mulaiButton.tap()
    
    tidakPernahButton.tap()
    tidakPernahButton.tap()
    tidakPernahButton.tap()
    tidakPernahButton.tap()
    tidakPernahButton.tap()
    jarangButton.tap()
    tidakPernahButton.tap()
    tidakPernahButton.tap()
    tidakPernahButton.tap()
    tidakPernahButton.tap()
    
    XCTAssertFalse(tingkatStresKamuAlamiElement.exists)
  }
  
  //MARK: Test for stress level 3
  func test_StressLevelThree_ShouldbeTrue() {
    let pengukuranTab = app.tabBars["Tab Bar"].buttons["Pengukuran"]
    let mulaiButton = app.buttons["Mulai"]
    let jarangButton = app.buttons["Jarang"]
    let kadangKadangButton = app.buttons["Kadang-kadang"]
    let seringButton =  app.buttons["Sering"]
    let tingkatStresKamuAlamiElement = app.scrollViews.otherElements.containing(.staticText, identifier:"Mengalami stres sedang").element
    
    pengukuranTab.tap()
    mulaiButton.tap()
    
    jarangButton.tap()
    jarangButton.tap()
    jarangButton.tap()
    jarangButton.tap()
    jarangButton.tap()
    seringButton.tap()
    seringButton.tap()
    jarangButton.tap()
    jarangButton.tap()
    kadangKadangButton.tap()
    
    XCTAssertTrue(tingkatStresKamuAlamiElement.exists)
  }
  
  func test_StressLevelThree_ShouldbeFalse() {
    let pengukuranTab = app.tabBars["Tab Bar"].buttons["Pengukuran"]
    let mulaiButton = app.buttons["Mulai"]
    let jarangButton = app.buttons["Jarang"]
    let tidakPernahButton = app.buttons["Tidak pernah"]
    let kadangKadangButton = app.buttons["Kadang-kadang"]
    let tingkatStresKamuAlamiElement = app.scrollViews.otherElements.containing(.staticText, identifier:"Mengalami stres sedang").element
    
    pengukuranTab.tap()
    mulaiButton.tap()
    
    jarangButton.tap()
    jarangButton.tap()
    jarangButton.tap()
    jarangButton.tap()
    jarangButton.tap()
    jarangButton.tap()
    tidakPernahButton.tap()
    tidakPernahButton.tap()
    jarangButton.tap()
    kadangKadangButton.tap()
    
    XCTAssertFalse(tingkatStresKamuAlamiElement.exists)
  }
  
  //MARK: Test for stress level 4
  func test_StressLevelFour_ShouldbeTrue() {
    let pengukuranTab = app.tabBars["Tab Bar"].buttons["Pengukuran"]
    let mulaiButton = app.buttons["Mulai"]
    let kadangKadangButton = app.buttons["Kadang-kadang"]
    let seringButton =  app.buttons["Sering"]
    let tingkatStresKamuAlamiElement = app.scrollViews.otherElements.containing(.staticText, identifier:"Mengalami stres berat").element
    
    pengukuranTab.tap()
    mulaiButton.tap()
    
    seringButton.tap()
    seringButton.tap()
    seringButton.tap()
    seringButton.tap()
    seringButton.tap()
    kadangKadangButton.tap()
    seringButton.tap()
    kadangKadangButton.tap()
    seringButton.tap()
    seringButton.tap()
    
    XCTAssertTrue(tingkatStresKamuAlamiElement.exists)
  }
  
  func test_StressLevelFour_ShouldbeFalse() {
    let pengukuranTab = app.tabBars["Tab Bar"].buttons["Pengukuran"]
    let mulaiButton = app.buttons["Mulai"]
    let jarangButton = app.buttons["Jarang"]
    let tidakPernahButton = app.buttons["Tidak pernah"]
    let kadangKadangButton = app.buttons["Kadang-kadang"]
    let tingkatStresKamuAlamiElement = app.scrollViews.otherElements.containing(.staticText, identifier:"Mengalami stres sedang").element
    
    pengukuranTab.tap()
    mulaiButton.tap()
    
    jarangButton.tap()
    jarangButton.tap()
    jarangButton.tap()
    jarangButton.tap()
    jarangButton.tap()
    jarangButton.tap()
    tidakPernahButton.tap()
    tidakPernahButton.tap()
    jarangButton.tap()
    kadangKadangButton.tap()
    
    XCTAssertFalse(tingkatStresKamuAlamiElement.exists)
  }
  
}
