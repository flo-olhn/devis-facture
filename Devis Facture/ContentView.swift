//
//  ContentView.swift
//  Devis Facture
//
//  Created by Florian Ouilhon on 24/10/2024.
//

import SwiftUI
import Combine

struct ContentView: View {
    @StateObject private var headerData = HeaderData()
    
    @State private var totalHT: Double = 0.0
    @State private var itemStores: [ItemStore] = [ItemStore(), ItemStore()] // Array to hold ItemStore instances per page
    @State private var pages: [Int] = [0, 1]
    
    var body: some View {
        ScrollView {
            ForEach(pages.indices, id: \.self) { pageIndex in
                let iS = itemStores[pageIndex]
                
                VStack {
                    Header(data: headerData)
                    SpreadSheet(itemStore: iS)
                    Text("Montant HT: \(iS.totalHT, specifier: "%.2f") €")
                    Spacer()
                    Text("\(pageIndex + 1) / \(pages.count)")
                }
                .onAppear {
                    setupObservers(for: iS)
                }
                .onChange(of: iS.totalHT) {
                    setupItemStores()
                }
                .padding([.top, .bottom], 76.54)
                .padding([.leading, .trailing], 59.53)
                .frame(width: 2480 / 2, height: 3508 / 2)
                .border(Color.gray.opacity(0.5))
                .padding(40)
            }
            
            // Display combined total at the bottom
            Text("Total HT for All Pages: \(totalHT, specifier: "%.2f") €")
                .font(.headline)
                .padding()
        }
        .onAppear {
            setupItemStores()
        }
    }
    
    private func setupItemStores() {
        if itemStores.count != pages.count {
            itemStores = pages.map { _ in ItemStore() }
            updateTotalHT()
        }
    }
    
    private func updateTotalHT() {
        totalHT = itemStores.reduce(0) { $0 + $1.totalHT }
    }
    
    private func setupObservers(for itemStore: ItemStore) {
        itemStore.$items
            .sink { _ in
                self.updateTotalHT()
            }
            .store(in: &cancellables)
    }
    
    @State private var cancellables = Set<AnyCancellable>()
}


#Preview {
    ContentView()
}
