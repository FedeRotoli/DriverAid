//
//  ContentView.swift
//  prova WatchKit Extension
//
//  Created by Federico Rotoli on 07/01/2020.
//  Copyright © 2020 Federico Rotoli. All rights reserved.
//

import SwiftUI
import HealthKit


struct PagerView<Content: View>: View {
    let pageCount: Int
    @Binding var currentIndex: Int
    let content: Content

    init(pageCount: Int, currentIndex: Binding<Int>, @ViewBuilder content: () -> Content) {
        self.pageCount = pageCount
        self._currentIndex = currentIndex
        self.content = content()
    }
    
    @GestureState private var translation: CGFloat = 0

    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                self.content.frame(width: geometry.size.width)
            }
            .frame(width: geometry.size.width, alignment: .leading)
            .offset(x: -CGFloat(self.currentIndex) * geometry.size.width)
            .offset(x: self.translation)
            .animation(.interactiveSpring())
            .gesture(
                DragGesture().updating(self.$translation) { value, state, _ in
                    state = value.translation.width
                }.onEnded { value in
                    let offset = value.translation.width / geometry.size.width
                    let newIndex = (CGFloat(self.currentIndex) - offset).rounded()
                    self.currentIndex = min(max(Int(newIndex), 0), self.pageCount - 1)
                }
            )
        }
    }
}


struct ContentView: View {
    @State private var currentPage = 0

    var body: some View {
        VStack{
            PagerView(pageCount: 2, currentIndex: $currentPage) {
                firstPage()
                SettingsView()
            }
            HStack{
                Circle()
                    .frame(width: 8, height: 8)
                    .foregroundColor(currentPage==1 ? Color.gray:Color.white)
                Circle()
                    .frame(width: 8, height: 8)
                    .foregroundColor(currentPage==1 ? Color.white:Color.gray)
            }
        }

    }
}

struct firstPage: View {
    @State private var showingSettings = false
    @State private var activeSecurity = false
    private var healthStore = HKHealthStore()
    private var timer: Timer?
    @State private var value = 0
    
    var body: some View {
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

    }
    
    func autorizeHealthKit() {
        let healthKitTypes: Set = [
        HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!,
        HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)!]

        healthStore.requestAuthorization(toShare: healthKitTypes, read: healthKitTypes) { _, _ in }

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
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

