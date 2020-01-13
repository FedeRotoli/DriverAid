//
//  ModalView.swift
//  prova WatchKit Extension
//
//  Created by Federico Rotoli on 09/01/2020.
//  Copyright © 2020 Federico Rotoli. All rights reserved.
//

import SwiftUI

struct ModalView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Text("This is a modal")
        }
    }
}

struct ModalView_Previews: PreviewProvider {
    static var previews: some View {
        ModalView()
    }
}
