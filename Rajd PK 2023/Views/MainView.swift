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
    @State var selectedTab = 1
    
    var body: some View {
        TabView(selection: $selectedTab) {
            AnnouncementListView(loggedIn: $loggedIn)
                .tabItem {
                    //Image(systemName: "megaphone.fill")
                    Image("notifications-icon")
                    Text("Ogłoszenia")
                }
                .tag(1)
            
            if loggedIn{
                AnnouncementFormContainer()
                    .tabItem {
                        //Image(systemName: "pencil")
                        Image("routes-icon")
                        Text("Napisz coś")
                    }
                    .tag(2)
            }
            
            TimetableView()
                .tabItem {
                    //Image(systemName: "mappin.circle.fill")
                    Image("schedule-icon")
                    Text("Harmonogram")
                }
                .tag(3)
            
            ContactsView()
                .tabItem {
                    Image(systemName: "mappin.circle.fill")
                    //Image("Contact-icon")
                    Text("Kontakty")
                }
                .tag(4)
            
            SignInView(loggedIn: $loggedIn, email: $email, password: $password)
                .tabItem {
                    //Image(systemName: "person.circle.fill")
                    Image("FAQ-icon")
                    Text("Logowanie")
                }
                .tag(5)
        }
        .onChange(of: ActiveAnnouncement.shared.isActive){ isActive in
            if (ActiveAnnouncement.shared.isActive){
                selectedTab = 1
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
            if (ActiveAnnouncement.shared.isActive){
                selectedTab = 1
            }
        }

    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(loggedIn: .constant(true), email: .constant("sample@email.com"), password: .constant("password"))
    }
}
