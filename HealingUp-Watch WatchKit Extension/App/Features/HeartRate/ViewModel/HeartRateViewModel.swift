//
//  HeartRateViewModel.swift
//  HealingUp-Watch WatchKit Extension
//
//  Created by Dicky Buwono on 24/05/22.
//

import Foundation
import HealthKit
import WatchConnectivity

public enum HRVDate {
  case today
  case week
  case month
}

struct HeartRateVariability {
  var heartRate: Double?
  var startDate: Date?
  var endDate: Date?
}

class HeartRateViewModel: NSObject, ObservableObject, WCSessionDelegate {

  let defaultSession = WCSession.default
  var currentHeartRateSample: [HKSample]?
  var currentHeartLastSample: HKSample?
  @Published var currentHeartRateBPM = Double()
  @Published var curr = String()

  var healthStore = HKHealthStore()

  // MARK: HRV
  @Published var todayHRV = [HeartRateVariability]()
  @Published var weekHRV = [HeartRateVariability]()
  @Published var monthHRV = [HeartRateVariability]()

  override init() {
    super.init()
    if WCSession.isSupported() {
      defaultSession.delegate = self
      defaultSession.activate()
    }
    if HKHealthStore.isHealthDataAvailable() {
      healthStore = HKHealthStore()
    } else {
      fatalError("Health data not available")
    }
    autorizeHealtKit()
  }

  func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    self.requestAuthorization { authorised in
      if authorised {
        self.getCurrentHeartRateData()
      }
    }
  }

  func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
    DispatchQueue.main.async {
      let loginMessage = message["Login"] as? String ?? "false"
      let ageMessage = message["Age"] as? String ?? ""
      let hrvNormal = message["Hrv"] as? String ?? ""

      print(ageMessage)
      print(hrvNormal)

      loginMessage == "true" ? SessionManager.setLoggedIn() : SessionManager.setNotLoggedIn()
      if ageMessage != "" {
        SessionManager.setUserAge(age: Int(ageMessage) ?? 0)
      }
      if hrvNormal != "" {
        SessionManager.setHrvNormal(hrv: Double(hrvNormal) ?? 0)
      }
    }
  }

  func requestAuthorization(completion: @escaping (Bool) -> Void) {
    let heartBeat = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!

    self.healthStore.requestAuthorization(toShare: [], read: [heartBeat]) { (success, _) in completion(success)
    }
  }

  func getCurrentHeartRateData() {
    let calendar = Calendar.current
    let components = calendar.dateComponents([.year, .month, .day], from: Date())
    let startDate: Date = calendar.date(from: components)!
    let endDate: Date = calendar.date(byAdding: Calendar.Component.day, value: 1, to: startDate as Date)!

    let sampleType: HKSampleType =  HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!
    let predicate: NSPredicate =  HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [])
    let anchor: HKQueryAnchor = HKQueryAnchor(fromValue: 0)

    let anchoredQuery = HKAnchoredObjectQuery(type: sampleType, predicate: predicate, anchor: anchor, limit: HKObjectQueryNoLimit) { (_, samples, deletedObjects, _, _ ) in

      if samples != nil {

        self.collectCurrentHeartRateSample(currentSampleTyple: samples!, deleted: deletedObjects!)

      }

    }

    anchoredQuery.updateHandler = { (_, samples, deletedObjects, _, _) -> Void in
      self.collectCurrentHeartRateSample(currentSampleTyple: samples!, deleted: deletedObjects!)
    }

    self.healthStore.execute(anchoredQuery)

  }

  // Retrived necessary parameter from HK Sample
  func collectCurrentHeartRateSample(currentSampleTyple: [HKSample]?, deleted: [HKDeletedObject]?) {

    self.currentHeartRateSample = currentSampleTyple

    // Get Last Sample of Heart Rate
    self.currentHeartLastSample = self.currentHeartRateSample?.last

    if self.currentHeartLastSample != nil {

      let lastHeartRateSample = self.currentHeartLastSample as! HKQuantitySample
      // Send Heart Rate Data Using Send Messge
      DispatchQueue.main.async {

        self.currentHeartRateBPM = lastHeartRateSample.quantity.doubleValue(for: HKUnit(from: "count/min"))
        let heartRateStartDate = lastHeartRateSample.startDate
        let heartRateEndDate = lastHeartRateSample.endDate

        let message = [
          "HeartRateBPM": "\(self.currentHeartRateBPM)",
          "HeartRateStartDate": "\(heartRateStartDate)",
          "HeartRateEndDate": "\(heartRateEndDate)"
        ]
        // Transfer data from watch to iPhone
        self.defaultSession.sendMessage(message, replyHandler: nil, errorHandler: { (error) in
          print("Error in send message : \(error)")
        })
      }
    }
  }

  // MARK: HRV
  func autorizeHealtKit() {
    let heartRate = HKObjectType.quantityType(forIdentifier: .heartRate)!
    let heartRateVariability = HKObjectType.quantityType(forIdentifier: .heartRateVariabilitySDNN)!
    let HKreadTypes: Set = [heartRate, heartRateVariability]

    healthStore.requestAuthorization(toShare: nil, read: HKreadTypes) { (chk, _) in
      if chk {
        self.getHeartRateVariability(type: .today)
        self.getHeartRateVariability(type: .week)
        self.getHeartRateVariability(type: .month)

      }
    }
  }

  func getHeartRateVariability(type: HRVDate) {
    let HKType = HKObjectType.quantityType(forIdentifier: .heartRateVariabilitySDNN)!
    let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)

    // MARK: Today
    var components = DateComponents()
    components.day = 1
    components.second = -1

    let startOfDay = Calendar.current.startOfDay(for: Date())
    let endOfDay = Calendar.current.date(byAdding: components, to: startOfDay)!
    let todayPredicate: NSPredicate? = HKQuery.predicateForSamples(withStart: startOfDay, end: endOfDay, options: HKQueryOptions.strictEndDate)

    // MARK: Week
    let startWeekDate =  Date() - 7 * 24 * 60 * 60
    let weekPredicate: NSPredicate? = HKQuery.predicateForSamples(withStart: startWeekDate, end: Date(), options: HKQueryOptions.strictEndDate)

    // MARK: Month
    let startMonthDate =  Date() - 30 * 24 * 60 * 60
    let monthPredicate: NSPredicate? = HKQuery.predicateForSamples(withStart: startMonthDate, end: Date(), options: HKQueryOptions.strictEndDate)

    let updateHandler: (HKSampleQuery, [HKSample]?, Error?) -> Void = {
      _, samples, _ in
      guard let samples = samples as? [HKQuantitySample] else {
        return
      }
      self.process(type: type, samples: samples)
    }

    switch type {
    case .today:
      let heartRateTodayQuery = HKSampleQuery(sampleType: HKType, predicate: todayPredicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: [sortDescriptor], resultsHandler: updateHandler)
      healthStore.execute(heartRateTodayQuery)
    case .week:
      let heartRateWeekQuery = HKSampleQuery(sampleType: HKType, predicate: weekPredicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: [sortDescriptor], resultsHandler: updateHandler)
      healthStore.execute(heartRateWeekQuery)
    case .month:
      let heartRateMonthQuery = HKSampleQuery(sampleType: HKType, predicate: monthPredicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: [sortDescriptor], resultsHandler: updateHandler)
      healthStore.execute(heartRateMonthQuery)
    }
  }

  private func process(type: HRVDate, samples: [HKQuantitySample]) {
    switch type {
    case .today:
      var results = [HeartRateVariability]()
      for sample in samples {
        DispatchQueue.main.async {
          let result = HeartRateVariability(heartRate: sample.quantity.doubleValue(for: HKUnit.secondUnit(with: .milli)), startDate: sample.startDate, endDate: sample.endDate)
          results.append(result)
          self.todayHRV = results
        }
      }
    case .week:
      var results = [HeartRateVariability]()
      for sample in samples {
        DispatchQueue.main.async {
          let result = HeartRateVariability(heartRate: sample.quantity.doubleValue(for: HKUnit.secondUnit(with: .milli)), startDate: sample.startDate, endDate: sample.endDate)
          results.append(result)
          self.weekHRV = results
        }
      }
    case .month:
      var results = [HeartRateVariability]()
      for sample in samples {
        DispatchQueue.main.async {
          let result = HeartRateVariability(heartRate: sample.quantity.doubleValue(for: HKUnit.secondUnit(with: .milli)), startDate: sample.startDate, endDate: sample.endDate)
          results.append(result)
          self.monthHRV = results
        }
      }
    }
  }

  func calculateAverage(datas: [HeartRateVariability]) -> Int {
    if !datas.isEmpty {
      var allHeartRate = [Double]()
      for data in datas {
        allHeartRate.append(data.heartRate ?? 0.0)
      }

      let sum = allHeartRate.reduce(0, +)

      return Int(sum.rounded())/datas.count
    }
    return 0
  }
}
