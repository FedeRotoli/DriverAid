//
//  ContentView.swift
//  prova WatchKit Extension
//
//  Created by Federico Rotoli on 07/01/2020.
//  Copyright © 2020 Federico Rotoli. All rights reserved.
//

import SwiftUI
import HealthKit

struct ContentView: View {
    @State private var showingSettings = false
    @State private var activeSecurity = false
    private var healthStore = HKHealthStore()
    private var timer: Timer?
    @State private var value = 0

    var body: some View {
        HStack{
            
            VStack{
                Button(action:{
                    self.activeSecurity.toggle()
                    if self.activeSecurity{
                        self.autorizeHealthKit()
                        self.saveMockHeartData()
                    }

                }) {
                    Image(systemName: "checkmark.shield").frame(width: 40, height: 40)
                }
                    .background(activeSecurity ? Color.green:Color.black)
                    .animation(.easeInOut(duration: 0.5))
                    .cornerRadius(10)
                    .frame(width: 64, height: 64)
                    .padding(.horizontal)

                Text("Safety")
                Text("BPM:  \(value)")
            }.multilineTextAlignment(.center)

            
            VStack{
                NavigationLink(destination: SettingsView()) {
                    Image(systemName: "gear").frame(width: 40, height: 40)
                }
                .frame(width: 64, height: 64)
                .padding(.horizontal)
                
                Text("Settings")
        
            }.multilineTextAlignment(.center)
            
            

        }

        
    }
    
    func autorizeHealthKit() {
//        if HKHealthStore.isHealthDataAvailable() {
//
//
//            let healthKitTypesToRead: Set<HKObjectType> = [HKObjectType.quantityType(forIdentifier: .heartRate)!]
//            let healthKitTypesToWrite: Set<HKSampleType> = []
//
//            if !HKHealthStore.isHealthDataAvailable(){
//                print("Error occurred")
//                return
//            }
//
//            healthStore.requestAuthorization(toShare: healthKitTypesToWrite, read: healthKitTypesToRead) {(success, error) -> Void in
//                print("Read Write Authorization succeded")
//            }
//        }
        
          let healthKitTypes: Set = [
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!,
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)!
          ]

        healthStore.requestAuthorization(toShare: healthKitTypes,
                                         read: healthKitTypes) { _, _ in }
        
    }
    
    func saveMockHeartData() {

      // 1. Create a heart rate BPM Sample
        let heartRateType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!
        let heartRateQuantity = HKQuantity(unit: HKUnit(from: "count/min"),
        doubleValue: Double(arc4random_uniform(80) + 100))
      let heartSample = HKQuantitySample(type: heartRateType,
                                         quantity: heartRateQuantity, start: NSDate() as Date, end: NSDate() as Date)

      // 2. Save the sample in the store
        healthStore.save(heartSample, withCompletion: { (success, error) -> Void in
        if let error = error {
          print("Error saving heart sample: \(error.localizedDescription)")
        }
      })
    }
    
//    func startMockHeartData() {
//        timer = Timer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "saveMockHeartData", userInfo: nil, repeats: true)
//    }
//
//    func stopMockHeartData() {
//      self.timer?.invalidate()
//    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
