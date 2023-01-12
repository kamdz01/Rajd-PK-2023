//
//  ContactsView.swift
//  Rajd PK 2023
//
//  Created by Kamil Dziedzic on 15/12/2022.
//

import SwiftUI

struct ContactsView: View {
    var body: some View {
        NavigationView{
            ZStack {
                LinearGradient(colors: [Color("TabColor"), Color("BGBot")], startPoint: .top, endPoint: .bottom).ignoresSafeArea(.all)
                Text("Tu będą kontakty")
            }
            .navigationTitle("Kontakty")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ContactsView_Previews: PreviewProvider {
    static var previews: some View {
        ContactsView()
    }
}
