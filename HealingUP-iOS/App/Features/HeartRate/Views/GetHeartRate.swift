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

struct HeartRateEntry: Hashable, Identifiable {
  var heartRate: Double
  var date: Date
  var id = UUID()
}

class HeartHistoryModel: NSObject, WCSessionDelegate, ObservableObject {
  
  let defaultSession = WCSession.default
  var currentHeartRateSample : [HKSample]?
  var currentHeartLastSample : HKSample?
  @Published var currentHeartRateBPM = Double()
  @Published var curr = String()
  @Published var startDate = String()
  @Published var endDate = String()
  
  var healthStore = HKHealthStore()
  
  override init() {
   
    super.init()
    defaultSession.delegate = self
    defaultSession.activate()

  }
  
  
  func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    
  }
  
  func sessionDidBecomeInactive(_ session: WCSession) {
    
  }
  
  func sessionDidDeactivate(_ session: WCSession) {
    
  }
  
  func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
    DispatchQueue.main.async {
      self.curr = message["HeartRateBPM"] as? String ?? "Unknown"
      self.startDate = message["HeartRateStartDate"] as? String ?? "Unknown"
      self.endDate = message["HeartRateEndDate"] as? String ?? "Unknown"
    }
  }
}
