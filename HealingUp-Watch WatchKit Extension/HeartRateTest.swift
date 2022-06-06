//
//  HeartRateTest.swift
//  HealingUp-Watch WatchKit Extension
//
//  Created by Dicky Buwono on 24/05/22.
//

import Foundation
import HealthKit
import WatchConnectivity

class HeartHistoryTest: NSObject, ObservableObject, WCSessionDelegate {
  
  let defaultSession = WCSession.default
  var currentHeartRateSample : [HKSample]?
  var currentHeartLastSample : HKSample?
  @Published var currentHeartRateBPM = Double()
  @Published var curr = String()
  
  var healthStore = HKHealthStore()
  
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
  }
  
  func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    self.requestAuthorization { authorised in
      if authorised {
        self.getCurrentHeartRateData()
      }
    }
  }
  
  func requestAuthorization(completion: @escaping (Bool) -> Void){
    let heartBeat = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!
    
    self.healthStore.requestAuthorization(toShare: [], read: [heartBeat]) { (success, error) in completion(success)
    }
  }
  
  func getCurrentHeartRateData(){
    
    let calendar = Calendar.current
    let components = calendar.dateComponents([.year, .month, .day], from: Date())
    let startDate : Date = calendar.date(from: components)!
    let endDate : Date = calendar.date(byAdding: Calendar.Component.day, value: 1, to: startDate as Date)!
    
    let sampleType : HKSampleType =  HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!
    let predicate : NSPredicate =  HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [])
    let anchor: HKQueryAnchor = HKQueryAnchor(fromValue: 0)
    
    let anchoredQuery = HKAnchoredObjectQuery(type: sampleType, predicate: predicate, anchor: anchor, limit: HKObjectQueryNoLimit) { (query, samples, deletedObjects, anchor, error ) in
      
      if samples != nil {
        
        self.collectCurrentHeartRateSample(currentSampleTyple: samples!, deleted: deletedObjects!)
        
      }
      
    }
    
    anchoredQuery.updateHandler = { (query, samples, deletedObjects, anchor, error) -> Void in
      self.collectCurrentHeartRateSample(currentSampleTyple: samples!, deleted: deletedObjects!)
    }
    
    self.healthStore.execute(anchoredQuery)
    
  }
  
  
  //Retrived necessary parameter from HK Sample
  func collectCurrentHeartRateSample(currentSampleTyple : [HKSample]?, deleted : [HKDeletedObject]?){
    
    self.currentHeartRateSample = currentSampleTyple
    
    //Get Last Sample of Heart Rate
    self.currentHeartLastSample = self.currentHeartRateSample?.last
    
    if self.currentHeartLastSample != nil {
      
      let lastHeartRateSample = self.currentHeartLastSample as! HKQuantitySample
      
      
      //Send Heart Rate Data Using Send Messge
      
      DispatchQueue.main.async {
        
        self.currentHeartRateBPM = lastHeartRateSample.quantity.doubleValue(for: HKUnit(from: "count/min"))
        let heartRateStartDate = lastHeartRateSample.startDate
        let heartRateEndDate = lastHeartRateSample.endDate
        
        let message = [
          "HeartRateBPM" : "\(self.currentHeartRateBPM)",
          "HeartRateStartDate" : "\(heartRateStartDate)",
          "HeartRateEndDate" : "\(heartRateEndDate)"
        ]
        
        
        //Transfer data from watch to iPhone
        self.defaultSession.sendMessage(message, replyHandler:nil, errorHandler: { (error) in
          print("Error in send message : \(error)")
        })
      }
    }
  }
}
