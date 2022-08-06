//
//  WorkoutManager.swift
//  belajar-workout WatchKit Extension
//
//  Created by Muhammad Rifki Widadi on 03/08/22.
//

import Foundation
import HealthKit

class WorkoutManager: NSObject, ObservableObject {
  var selectedWorkout: HKWorkoutActivityType = .yoga

  let healthStore = HKHealthStore()
  var session: HKWorkoutSession?
  var builder: HKLiveWorkoutBuilder?

  func startWorkout(workoutType: HKWorkoutActivityType) {
    let configuration = HKWorkoutConfiguration()
    configuration.activityType = workoutType
    configuration.locationType = .outdoor

    do {
      session = try HKWorkoutSession(healthStore: healthStore, configuration: configuration)
      builder = session?.associatedWorkoutBuilder()
    } catch {
      return
    }

    builder?.dataSource = HKLiveWorkoutDataSource(healthStore: healthStore, workoutConfiguration: configuration)

    session?.delegate = self
    builder?.delegate = self

    let startdate = Date()
    session?.startActivity(with: startdate)
    builder?.beginCollection(withStart: startdate, completion: { _, _ in

    })
  }

  // Request authorization to access Healthkit.
  func requestAuthorization() {

    // The quantity type to write to the health store.
    let typesToShare: Set = [
      HKQuantityType.workoutType()
    ]

    // The quantity types to read from the health store.
    let typesToRead: Set = [
      HKQuantityType.quantityType(forIdentifier: .heartRate)!,
      HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!,
      HKObjectType.activitySummaryType()
    ]

    // Request authorization for those quantity types
    healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { _, _ in
      // Handle error.
    }

  }

  // MARK: - State Control

  @Published var running = false

  func endWorkout() {
    session?.end()
  }

  // MARK: - Workout Metrics

  @Published var avgHR: Double = 0
  @Published var heartRate: Double = 0

  @Published var workout: HKWorkout?

  func updateForStatistics(_ statistics: HKStatistics?) {

    guard let statistics = statistics else {
      return
    }

    DispatchQueue.main.async {
      let heartRateUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
      self.heartRate = statistics.mostRecentQuantity()?.doubleValue(for: heartRateUnit) ?? 0
      self.avgHR = statistics.averageQuantity()?.doubleValue(for: heartRateUnit) ?? 0
    }

  }

  func resetWorkout() {
//    selectedWorkout = nil
    builder = nil
    session = nil
    workout = nil
    avgHR = 0
    heartRate = 0
  }

}

extension WorkoutManager: HKWorkoutSessionDelegate {
  func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {

  }

  func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
    DispatchQueue.main.async {
      self.running = toState == .running
    }

    if toState == .ended {
      builder?.endCollection(withEnd: date) { _, _ in
        self.builder?.finishWorkout { workout, _ in
          DispatchQueue.main.async {
            self.workout = workout
          }
        }
      }
    }

  }
}

// MARK: - HKLiveWorkoutBuilderDelegate
extension WorkoutManager: HKLiveWorkoutBuilderDelegate {
  func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {

  }

  func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
    for type in collectedTypes {
      guard let quantityType = type as? HKQuantityType else { return }

      let statistic = workoutBuilder.statistics(for: quantityType)

      updateForStatistics(statistic)
    }
  }
}
