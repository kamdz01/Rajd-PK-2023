//
//  ContactsView.swift
//  Rajd PK 2023
//
//  Created by Kamil Dziedzic on 15/12/2022.
//

import SwiftUI

struct FAQView: View {
    var body: some View {
        NavigationView{
            ZStack {
                LinearGradient(colors: [Color("TabColor"), Color("BGBot")], startPoint: .top, endPoint: .bottom).ignoresSafeArea(.all)
                Text("Tu będzie FAQ")
            }
            .navigationTitle("FAQ")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading){
                    HStack {
                        Text("")
                        NavigationLink(destination: SignInView()){
                            Image(systemName: "person.crop.circle")
                        }
                    }
                }
            }
        }
    }
}

struct ContactsView_Previews: PreviewProvider {
    static var previews: some View {
        FAQView()
    }
}