//
//  Header.swift
//  Devis Facture
//
//  Created by Florian Ouilhon on 24/10/2024.
//

import SwiftUI

struct Header: View {
    @State private var title1 = "DEVIS DE PLATRERIE"
    @State private var nom1 = ""
    @State private var add1 = ""
    @State private var code1 = ""
    @State private var city1 = ""
    @State private var phone1 = ""
    @State private var email1 = ""
    
    @State private var nom2 = ""
    @State private var add2 = ""
    @State private var code2 = ""
    @State private var city2 = ""
    @State private var phone2 = ""
    @State private var email2 = ""
    
    @State private var date = "\(Date().formatted(date: .numeric, time: .omitted))"
    
    var body: some View {
        VStack {
            CustomTextField(text: $title1, placeholder: "Titre", size: 32)
                .multilineTextAlignment(.center)
            HStack {
                ContactInfo(contactName: $nom1, contactAddress: $add1, contactPCode: $code1, contactCity: $city1, contactPhone: $phone1, contactEmail: $email1)
                Spacer()
                ContactInfo(contactName: $nom2, contactAddress: $add2, contactPCode: $code2, contactCity: $city2, contactPhone: $phone2, contactEmail: $email2)
                    .multilineTextAlignment(.trailing)
            }
            .padding(.bottom)
            HStack {
                CustomTextField(text: $city1, placeholder: "Ville")
                Text(", le")
                CustomTextField(text: $date, placeholder: "Date")
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
    Header()
}
