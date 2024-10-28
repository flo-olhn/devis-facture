//
//  ContentView.swift
//  Devis Facture
//
//  Created by Florian Ouilhon on 24/10/2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ScrollView {
            VStack {
                Header()
                SpreadSheet()
                Spacer()
            }
            .padding([.top, .bottom], 76.54)
            .padding([.leading, .trailing], 59.53)
            .frame(width: 2480/2, height: 3508/2)
            .border(.gray.opacity(0.5))
            .padding(40)
        }
    }
}

#Preview {
    ContentView()
}
