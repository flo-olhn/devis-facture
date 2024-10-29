//
//  ContentView.swift
//  Devis Facture
//
//  Created by Florian Ouilhon on 24/10/2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var headerData = HeaderData()
    
    @StateObject var itemStore = ItemStore()
    
    @State var mHT: Double = 0
    
    @State var pages: [Int] = [0, 1]
    
    var body: some View {
        ScrollView {
            ForEach(pages, id: \.self) { page in
                @StateObject var iS = ItemStore()
                VStack {
                    Header(data: headerData)
//                    pages.count == 1 ?
//                    SpreadSheet(itemStore: itemStore) : SpreadSheet(itemStore: ItemStore())
                    SpreadSheet(itemStore: iS)
                    Text("Montant HT: \(iS.montantHT(), specifier: "%.2f") €")
                    Spacer()
                    Text("\(page+1) / \(pages.count)")
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
