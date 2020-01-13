//
//  SettingsView.swift
//  prova WatchKit Extension
//
//  Created by Federico Rotoli on 13/01/2020.
//  Copyright © 2020 Federico Rotoli. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    
    var body: some View {
        VStack(spacing: 15){
            Button(action:{
                
            }){
                HStack{
                    Image(systemName: "timer")
                        .padding()
                    Text("Set Speed Limit")
                }

            }
            Button(action:{
                
            }){
                HStack{
                    Image(systemName: "speaker.2")
                        .padding()
                    Text("Choose Sound")
                }

            }
            Button(action:{
                
            }){
                HStack{
                    Image(systemName: "location")
                        .padding()
                    Text("Enable Helper")
                }

            }.background(Color.orange.opacity(0.7))
            .cornerRadius(10)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

