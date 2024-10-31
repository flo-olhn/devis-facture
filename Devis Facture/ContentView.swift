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
    @State private var itemStores: [ItemStore] = [ItemStore()] // Array to hold ItemStore instances per page
    @State private var pages: [Int] = [0]
    
    @State private var yPos: CGFloat = 0
    
    private func addNewPage() {
        if itemStores[pages.last!].yPos > 1100 {
            yPos = itemStores[pages.last!].yPos
            pages.append(pages.last! + 1)
            itemStores.append(ItemStore())
        }
        setupItemStores()
    }
    
    private func removePage() {
        if pages.count > 1 && itemStores[pages.last! - 1].yPos <= 1100 {
            print("removed", itemStores[pages.last! - 1].yPos)
            pages.removeLast()
            itemStores.removeLast()
            setupItemStores()
            updateTotalHT()
        }
    }
    
    var body: some View {
        List {
            ForEach(pages, id: \.self) { pageIndex in
                let iS = pageIndex <= pages.last! ? itemStores[pageIndex] : itemStores[pageIndex - 1]
                VStack {
                    Header(data: headerData)
                    SpreadSheet(itemStore: iS) {
                        addNewPage()
                    } onUnexceedPageHeight: {
                        removePage()
                    }
                    pageIndex == pages.last ?
                    HStack {
                        Spacer()
                        Text("Montant HT: \(totalHT, specifier: "%.2f") €")
                            .font(.system(size: 16, weight: .medium))
                            .padding()
                    } : nil
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
            
            // Display combined total at the bottom: to be removed
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
