//
//  RoutesView.swift
//  Rajd PK 2023
//
//  Created by Kamil Dziedzic on 17/02/2023.
//

import SwiftUI

struct RoutesView: View {
    var body: some View {
        NavigationView{
            ZStack {
                LinearGradient(colors: [Color("TabColor"), Color("BGBot")], startPoint: .top, endPoint: .bottom).ignoresSafeArea(.all)
                Text("Tu będą trasy")
            }
            .navigationTitle("Trasy")
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

struct RoutesView_Previews: PreviewProvider {
    static var previews: some View {
        RoutesView()
    }
}
