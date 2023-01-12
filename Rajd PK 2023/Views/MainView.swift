//
//  MainView.swift
//  Rajd PK 2023
//
//  Created by Kamil Dziedzic on 14/12/2022.
//

import SwiftUI
import Firebase

struct MainView: View {
    @Binding var loggedIn: Bool
    @Binding var email: String
    @Binding var password: String
    @StateObject var viewModel = AnnouncementViewModel()
    
    var body: some View {
        TabView {
            AnnouncementListView(loggedIn: $loggedIn)
                .tabItem {
                    //Image(systemName: "megaphone.fill")
                    Image("notifications-icon")
                    Text("Ogłoszenia")
                }
            
            if loggedIn{
                AnnouncementFormContainer()
                    .tabItem {
                        //Image(systemName: "pencil")
                        Image("routes-icon")
                        Text("Napisz coś")
                    }
            }
            
            TimetableView()
                .tabItem {
                    //Image(systemName: "mappin.circle.fill")
                    Image("schedule-icon")
                    Text("Harmonogram")
                }
            
            ContactsView()
                .tabItem {
                    Image(systemName: "mappin.circle.fill")
                    //Image("Contact-icon")
                    Text("Kontakty")
                }
            
            SignInView(loggedIn: $loggedIn, email: $email, password: $password)
                .tabItem {
                    //Image(systemName: "person.circle.fill")
                    Image("FAQ-icon")
                    Text("Logowanie")
                }
        }
        .environmentObject(viewModel)
        .onAppear{
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                guard error == nil else {
                    print("Could not sign in user.")
                    loggedIn = false
                    return
                }
                switch authResult {
                case .none:
                    print("Could not sign in user.")
                    loggedIn = false
                case .some(_):
                    print("User signed in")
                    loggedIn = true
                }
                print("LoggedIn: \(loggedIn)")
            }
            
            UITabBar.appearance().backgroundColor = UIColor(Color("TabColor"))
            
//            let tabBarAppearance = UITabBarAppearance()
//            //tabBarAppearance.configureWithOpaqueBackground()
//            if #available(iOS 15.0, *) {
//                UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
//            } else {
//            }
//            let navigationBarAppearance = UINavigationBarAppearance()
//            navigationBarAppearance.configureWithOpaqueBackground()
//            UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
//            tabBarAppearance.backgroundColor = UIColor(Color("TabColor"))
            
        }
        //                .onAppear {
        //                    let tabBarAppearance = UITabBarAppearance()
        //                    tabBarAppearance.configureWithOpaqueBackground()
        //                    if #available(iOS 15.0, *) {
        //                        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        //                    } else {
        //                    }
        //                    let navigationBarAppearance = UINavigationBarAppearance()
        //                    navigationBarAppearance.configureWithOpaqueBackground()
        //                    UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        //                }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(loggedIn: .constant(true), email: .constant("sample@email.com"), password: .constant("password"))
    }
}
