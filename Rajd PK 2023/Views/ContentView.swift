//
//  ContentView.swift
//  Rajd PK 2023
//
//  Created by Kamil Dziedzic on 08/12/2022.
//

import SwiftUI
import Firebase


struct ContentView: View {
    @AppStorage("loggedIn") var loggedIn = false
    @AppStorage("email") var email = ""
    @AppStorage("password") var password = ""
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor(Color("TabColor"))
        UITabBar.appearance().barTintColor = UIColor(Color("TabColor"))
        UINavigationBar.appearance().barTintColor = UIColor(Color("TabColor"))
        if #available(iOS 16.0, *) {}
        else{
            UITableView.appearance().backgroundColor = .clear
        }
        let tabBarAppearance = UITabBarAppearance()
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
    }
    
    
    var body: some View {
        MainView(loggedIn: $loggedIn, email: $email, password: $password)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
