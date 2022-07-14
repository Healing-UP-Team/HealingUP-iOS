//
//  GetHeartRate.swift
//  HealingUP-iOS
//
//  Created by Dicky Buwono on 24/05/22.
//

import Foundation
import HealthKit
import WatchConnectivity
import SwiftUI
import SwiftUICharts

class HeartRateViewModel: NSObject, WCSessionDelegate, ObservableObject {
  let healthStore = HKHealthStore()

  // MARK: Real Time HeartRate
  let defaultSession = WCSession.default
  var currentHeartRateSample: [HKSample]?
  var currentHeartLastSample: HKSample?
  @Published var currentHeartRateBPM = Double()
  @Published var curr = String()
  @Published var startDate = String()
  @Published var endDate = String()

  // MARK: HRV
  @Published var todayHRV = [HeartRateVariability]()
  @Published var weekHRV = [HeartRateVariability]()
  @Published var monthHRV = [HeartRateVariability]()

  @Published var dataWeek: LineChartData?
  @Published var dataMonth: LineChartData?
  @Published var dataToday: LineChartData?

  override init() {
    super.init()
    autorizeHealtKit()
    if WCSession.isSupported() {
      defaultSession.delegate = self
      defaultSession.activate()
    }
  }

  // MARK: Real Time HeartRate
  func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    let age = SessionManager.getUserAge()
    let hrv = SessionManager.getHrvNormal()

    if !session.isReachable {
      print("please connect and run your iOS app")
    } else if !session.isWatchAppInstalled {
      print("please install watch App")
    } else if session.isReachable {
      if DefaultFirebaseManager.shared.firebaseAuth.currentUser != nil {
        sendMessageToWatch(LoginMessage: "true", age: "\(age)", hrv: "\(hrv)")
      } else {
        sendMessageToWatch(LoginMessage: "false", age: "\(age)", hrv: "\(hrv)")
      }
    }
  }

  func sessionDidBecomeInactive(_ session: WCSession) {

  }

  func sessionDidDeactivate(_ session: WCSession) {

  }

  func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
    DispatchQueue.main.async {
      self.curr = message["HeartRateBPM"] as? String ?? "Unknown"
      self.startDate = message["HeartRateStartDate"] as? String ?? "Unknown"
      self.endDate = message["HeartRateEndDate"] as? String ?? "Unknown"
    }
  }

  func sessionReachabilityDidChange(_ session: WCSession) {
    let age = SessionManager.getUserAge()
    let hrv = SessionManager.getHrvNormal()

    if session.isReachable {
      if DefaultFirebaseManager.shared.firebaseAuth.currentUser != nil {
        sendMessageToWatch(LoginMessage: "true", age: "\(age)", hrv: "\(hrv)")
      } else {
        sendMessageToWatch(LoginMessage: "false", age: "\(age)", hrv: "\(hrv)")
      }
    }
  }

  func sendMessageToWatch(LoginMessage: String, age: String, hrv: String) {
    DispatchQueue.main.async {
      let message = [
        "Login": LoginMessage,
        "Age": age,
        "Hrv": hrv
      ]
      self.defaultSession.sendMessage(message, replyHandler: nil, errorHandler: {
        (error) in
        print("Error in send message: \(error)")
      })
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
          self.dataToday = self.setupDayChartValue()
        }
      }
    case .week:
      var results = [HeartRateVariability]()
      for sample in samples {
        DispatchQueue.main.async {
          let result = HeartRateVariability(heartRate: sample.quantity.doubleValue(for: HKUnit.secondUnit(with: .milli)), startDate: sample.startDate, endDate: sample.endDate)
          results.append(result)
          self.weekHRV = results
          self.dataWeek = self.setupWeekChartValue()
        }
      }
    case .month:
      var results = [HeartRateVariability]()
      for sample in samples {
        DispatchQueue.main.async {
          let result = HeartRateVariability(heartRate: sample.quantity.doubleValue(for: HKUnit.secondUnit(with: .milli)), startDate: sample.startDate, endDate: sample.endDate)
          results.append(result)
          self.monthHRV = results
          self.dataMonth = self.setupMonthChartValue()
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

  func setupDayChartValue() -> LineChartData {
    var dataPoint = [LineChartDataPoint]()
    let datas = todayHRV
      .sorted(by: {
        $0.startDate?.compare($1.startDate ?? Date()) == .orderedAscending
      })

    for data in datas {
      let value = data.heartRate ?? 0.0
      let day = data.startDate?.toStringWith(format: "HH")
      dataPoint.append(LineChartDataPoint(value: value, xAxisLabel: day, description: day))
    }

    let dataset = LineDataSet(dataPoints: dataPoint, style: LineStyle(lineType: .line))

    return LineChartData(
      dataSets: dataset,
      metadata: ChartMetadata(title: "Some Data", subtitle: "A Day"),
      chartStyle: LineChartStyle(
        xAxisLabelPosition: .bottom,
        yAxisLabelPosition: .trailing,
        yAxisNumberOfLabels: 4,
        baseline: .minimumWithMaximum(of: 0),
        topLine: .maximum(of: 150)))
  }

  func setupWeekChartValue() -> LineChartData {
    var dataPoint = [LineChartDataPoint]()
    let datas = weekHRV

    let list = Dictionary(
      grouping: datas,
      by: {
        Calendar.current.startOfDay(for: $0.startDate ?? Date())
      })
      .compactMap { $0.value.first }
      .sorted(by: {
        $0.startDate?.compare($1.startDate ?? Date()) == .orderedAscending
      })

    for data in list {
      let arrayFilter = datas.filter {
        Calendar.current.isDate(data.startDate ?? Date(), equalTo: $0.startDate ?? Date(), toGranularity: .day)
      }
      let averageDay = calculateAverage(datas: arrayFilter)
      let day = data.startDate?.toStringWith(format: "E")
      dataPoint.append(LineChartDataPoint(value: Double(averageDay), xAxisLabel: day, description: day))
    }

    let dataset = LineDataSet(dataPoints: dataPoint, style: LineStyle(lineType: .line))

    return LineChartData(
      dataSets: dataset,
      metadata: ChartMetadata(title: "Some Data", subtitle: "A Week"),
      chartStyle: LineChartStyle(
        xAxisLabelPosition: .bottom,
        yAxisLabelPosition: .trailing,
        yAxisNumberOfLabels: 4,
        baseline: .minimumWithMaximum(of: 0),
        topLine: .maximum(of: 150)))
  }

  func setupMonthChartValue() -> LineChartData {
    var dataPoint = [LineChartDataPoint]()
    let datas = monthHRV

    let list = Dictionary(
      grouping: datas,
      by: {
        Calendar.current.startOfDay(for: $0.startDate ?? Date())
      })
      .compactMap { $0.value.first }
      .sorted(by: {
        $0.startDate?.compare($1.startDate ?? Date()) == .orderedAscending
      })

    for data in list {
      let arrayFilter = datas.filter {
        Calendar.current.isDate(data.startDate ?? Date(), equalTo: $0.startDate ?? Date(), toGranularity: .day)
      }
      let averageDay = calculateAverage(datas: arrayFilter)
      let day = data.startDate?.toStringWith(format: "dd")
      dataPoint.append(LineChartDataPoint(value: Double(averageDay), xAxisLabel: day, description: day))
    }

    let dataset = LineDataSet(dataPoints: dataPoint, style: LineStyle(lineType: .line))

    return LineChartData(
      dataSets: dataset,
      metadata: ChartMetadata(title: "Some Data", subtitle: "A Month"),
      chartStyle: LineChartStyle(
        xAxisLabelPosition: .bottom,
        yAxisLabelPosition: .trailing,
        yAxisNumberOfLabels: 4,
        baseline: .minimumWithMaximum(of: 0),
        topLine: .maximum(of: 150)))
  }
}
