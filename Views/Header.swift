//
//  Header.swift
//  Devis Facture
//
//  Created by Florian Ouilhon on 24/10/2024.
//

import SwiftUI

struct Header: View {
    @ObservedObject var data: HeaderData
    
    //@State private var date = "\(Date().formatted(date: .numeric, time: .omitted))"
    
    var body: some View {
        VStack {
            CustomTextField(text: $data.title1, placeholder: "Titre", size: 32)
                .multilineTextAlignment(.center)
            HStack {
                ContactInfo(contactName: $data.nom1, contactAddress: $data.add1, contactPCode: $data.code1, contactCity: $data.city1, contactPhone: $data.phone1, contactEmail: $data.email1)
                Spacer()
                ContactInfo(contactName: $data.nom2, contactAddress: $data.add2, contactPCode: $data.code2, contactCity: $data.city2, contactPhone: $data.phone2, contactEmail: $data.email2)
                    .multilineTextAlignment(.trailing)
            }
            .padding(.bottom)
            HStack {
                CustomTextField(text: $data.city1, placeholder: "Ville")
                Text(", le")
                CustomTextField(text: $data.date, placeholder: "Date")
            }
        }
    }
}

struct CustomTextField: View {
    @Binding var text: String
    @State var placeholder: String
    @State var size: CGFloat = 14
    var body: some View {
        VStack {
            TextField(placeholder, text: $text)
                .padding(6)
                .font(.system(size: size))
                .border(Color.gray.opacity(0.5), width: 1)
                .textFieldStyle(.plain)
                .padding(.bottom, 4)
        }
    }
}

struct ContactInfo: View {
    @Binding var contactName: String
    @Binding var contactAddress: String
    @Binding var contactPCode: String
    @Binding var contactCity: String
    @Binding var contactPhone: String
    @Binding var contactEmail: String
    //@State private var placeholder: String = ""
    var body: some View {
        VStack {
            CustomTextField(text: $contactName, placeholder: "Nom")
            CustomTextField(text: $contactAddress, placeholder: "Adresse")
            HStack {
                CustomTextField(text: $contactPCode, placeholder: "Code Postal")
                Text(",")
                CustomTextField(text: $contactCity, placeholder: "Ville")
            }
            CustomTextField(text: $contactPhone, placeholder: "Téléphone")
            CustomTextField(text: $contactEmail, placeholder: "Email")
        }
    }
}

#Preview {
    Header(data: HeaderData())
}
