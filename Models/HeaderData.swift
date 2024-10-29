//
//  HeaderData.swift
//  Devis Facture
//
//  Created by Florian Ouilhon on 29/10/2024.
//

import Foundation

class HeaderData: ObservableObject {
    @Published var title1 = "DEVIS DE PLATRERIE"
    
    @Published var nom1 = ""
    @Published var add1 = ""
    @Published var code1 = ""
    @Published var city1 = ""
    @Published var phone1 = ""
    @Published var email1 = ""
    
    @Published var nom2 = ""
    @Published var add2 = ""
    @Published var code2 = ""
    @Published var city2 = ""
    @Published var phone2 = ""
    @Published var email2 = ""
    
    @Published var date = "\(Date().formatted(date: .numeric, time: .omitted))"
}
