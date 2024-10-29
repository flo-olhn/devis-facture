//
//  ContentView.swift
//  Devis Facture
//
//  Created by Florian Ouilhon on 24/10/2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var headerData = HeaderData()
    
    var body: some View {
        @State var pages: [Int] = [0]
        ScrollView {
            ForEach(pages, id: \.self) { page in
                VStack {
                    Header(data: headerData)
                    SpreadSheet()
                    Spacer()
                    Text("\(page) / \(pages.count)")
                }
                .padding([.top, .bottom], 76.54)
                .padding([.leading, .trailing], 59.53)
                .frame(width: 2480 / 2, height: 3508 / 2)
                .border(Color.gray.opacity(0.5))
                .padding(40)
            }
        }
    }
}

#Preview {
    ContentView()
}
