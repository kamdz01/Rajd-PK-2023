//
//  InfoView.swift
//  Rajd PK 2023
//
//  Created by Kamil Dziedzic on 11/02/2023.
//

import SwiftUI

struct InfoView: View {
    
    @State private var choice = "Harmonogram"
    var tabs = ["Harmonogram", "FAQ"]
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("What is your favorite color?", selection: $choice) {
                    ForEach(tabs, id: \.self) {
                        Text($0)
                    }
                }
                .font(.title)
                .pickerStyle(.segmented)

                if(choice == "FAQ"){
                    FAQView()
                }
                else if(choice == "Harmonogram"){
                    TimetableView()
                }
            }
            .background(LinearGradient(colors: [Color("TabColor"), Color("BGBot")], startPoint: .top, endPoint: .bottom).ignoresSafeArea(.all))

        }
        .onAppear{
            UISegmentedControl.appearance().setTitleTextAttributes([.font : UIFont.preferredFont(forTextStyle: .title3)], for: .normal)
        }
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}
