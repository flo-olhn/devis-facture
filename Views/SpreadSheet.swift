//
//  Body.swift
//  Devis Facture
//
//  Created by Florian Ouilhon on 24/10/2024.
//

import SwiftUI

func w() -> Double {
    let maxW = 2480.0
    let mmaxW = maxW - (2480.0 - (2480/4) / 3)
    let mmmaxW = mmaxW - 59.53 / 2
    return mmmaxW
}

struct TableItem: Equatable {
    var description: String = ""
    var unitPrice: Double = 0.0
    var surface: Double = 0.0
    var total: Double {
        unitPrice * surface
    }
}

@MainActor
class ItemStore: ObservableObject {
    private var key: Int = 0
    @Published var items: [Int: TableItem] = [
        0: TableItem(description: "", unitPrice: 0.0, surface: 0.0)
    ]
    
    func addItem() {
        key += 1
        items[key] = TableItem()
    }
    
    func removeItem(_ id: Int) {
        items.removeValue(forKey: id)
    }
}

struct SpreadSheet: View {
    
    @State private var rowHeights: [Int: CGFloat] = [:]
    
    @FocusState private var focusedField: Field?
    
    @ObservedObject private var itemStore = ItemStore()
    
     var orderedItems: [Int] {
        itemStore.items.keys.sorted()
    }
    
    enum Field: Hashable {
        case description(Int)
        case unitPrice(Int)
        case surface(Int)
    }
    
    private var numFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        formatter.locale = Locale.current
        return formatter
    }
    
    let columns = [
        GridItem(.flexible(minimum: 2480/4 - 59.53 / 2), spacing: -1),
        GridItem(.flexible(minimum: (w())), spacing: -1),
        GridItem(.flexible(minimum: (w())), spacing: -1),
        GridItem(.flexible(minimum: (w())), spacing: -1),
        GridItem(.flexible(minimum: 40), spacing: -1)
    ]
    
    var body: some View {
        VStack {
            LazyVGrid(columns: columns, spacing: 0) {
                Rectangle().foregroundStyle(.clear).border(.black).frame(height: 60).overlay(
                    Text("Description").font(.headline)
                )
                Rectangle().foregroundStyle(.clear).border(.black).frame(height: 60).overlay(
                    Text("Prix U (€)").font(.headline)
                )
                Rectangle().foregroundStyle(.clear).border(.black).frame(height: 60).overlay(
                    Text("Surface (m²)").font(.headline)
                )
                Rectangle().foregroundStyle(.clear).border(.black).frame(height: 60).overlay(
                    Text("Total (€)").font(.headline)
                )
            }
            .padding(.bottom, -9).padding(.leading, 37)
            
            LazyVGrid(columns: columns, spacing: -1) {
                ForEach(orderedItems, id: \.self) { key in
                    let itemBinding = Binding<TableItem>(get: {
                        itemStore.items[key] ?? TableItem()
                    }, set: {
                        itemStore.items[key] = $0
                    })
                    
                    let id = key
                    
                    dataCell(id: id, focusField: .description(id)) {
                        DynamicHeightTextEditor(text: Binding(
                            get: { itemBinding.wrappedValue.description },
                            set: { itemBinding.wrappedValue.description = $0 }
                        ), font: .system(size: 12), rowHeight: $rowHeights[id])
                            .scrollContentBackground(.hidden)
                            .scrollDisabled(true)
                            .focused($focusedField, equals: .description(id))
                    }.padding(.bottom, -1)
                    
                    dataCell(id: id, focusField: .unitPrice(id), height: rowHeights[id]) {
                        TextField("Prix U", value: Binding(
                            get: { itemBinding.wrappedValue.unitPrice },
                            set: { itemBinding.wrappedValue.unitPrice = $0 }
                        ), formatter: numFormatter)
                            .textFieldStyle(PlainTextFieldStyle())
                            .multilineTextAlignment(.center)
                            .focused($focusedField, equals: .unitPrice(id))
                    }.padding(.bottom, -1)
                    
                    dataCell(id: id, focusField: .surface(id), height: rowHeights[id]) {
                        TextField("Surface", value: Binding(
                            get: { itemBinding.wrappedValue.surface },
                            set: { itemBinding.wrappedValue.surface = $0 }
                        ), formatter: numFormatter)
                            .textFieldStyle(.plain)
                            .multilineTextAlignment(.center)
                            .focused($focusedField, equals: .surface(id))
                    }.padding(.bottom, -1)
                    
                    dataCell(id: id, height: rowHeights[id]) {
                        Text("\(itemBinding.wrappedValue.total, specifier: "%.2f") €")
                            .font(.body)
                    }.padding(.bottom, -1)
                    
                    Button {
                        itemStore.removeItem(id)
                    } label: {
                        Text("\(Image(systemName: "trash"))")
                            .foregroundStyle(.white)
                            .padding(0)
                            .clipShape(Rectangle()).frame(maxWidth: 40, minHeight: rowHeights[id] ?? 40)
                            .background(.red)
                            .border(.black)
                    }.buttonStyle(PlainButtonStyle()).padding(-9)
                }
            }
            .padding(.leading, 37)
            
            Button {
                itemStore.addItem()
            } label: {
                Text("\(Image(systemName: "plus")) Nouvelle Ligne")
                    .padding(0)
                    .clipShape(Rectangle()).frame(maxWidth: 1118, maxHeight: 40)
                    .background(.blue.opacity(0.2))
                    .border(.black)
            }.buttonStyle(PlainButtonStyle()).padding(.top, -8).padding(.leading, -2)
            Spacer()
        }
    }
    
    func dataCell<Content: View>(id: Int, focusField: Field? = nil, height: CGFloat? = nil, @ViewBuilder content: () -> Content) -> some View {
        ZStack {
            if focusedField == focusField && focusedField != nil {
                Color.gray.opacity(0.2)
            } else {
                Color.clear
            }
            content()
                .frame(maxWidth: .infinity, minHeight: height ?? 40)
                .border(Color.black, width: 1)
                .contentShape(Rectangle())
        }
        .contentShape(Rectangle())
        .onTapGesture {
            focusedField = focusField
        }
    }
}

struct DynamicHeightTextEditor: View {
    @Binding var text: String
    var font: Font
    @Binding var rowHeight: CGFloat?
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Text(text)
                .font(font)
                .foregroundColor(.clear)
                .padding(8)
                .background(GeometryReader { proxy in
                    Color.clear.onAppear {
                        self.rowHeight = max(proxy.size.height, 40)
                    }
                    .onChange(of: text) { old, new in
                        self.rowHeight = max(proxy.size.height, 40)
                    }
                })
            
            TextEditor(text: $text)
                .padding(8)
                .font(font)
                .frame(height: rowHeight)
                .background(Color.clear)
                .onAppear {
                    if rowHeight == nil {
                        rowHeight = 40
                    }
                }
                .onChange(of: text) { old, new in
                    self.rowHeight = max(rowHeight ?? 40, 40)
                }
        }
    }
}


#Preview {
    SpreadSheet()
}
