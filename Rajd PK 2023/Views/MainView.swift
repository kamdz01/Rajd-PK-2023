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
    @StateObject var viewModel = FirebaseViewModel()
    @State var selectedTab = 1
    
    @ObservedObject var activeAnnouncement = ActiveAnnouncement.shared
    @ObservedObject var activeEnrollment = ActiveEnrollment.shared
    
    var body: some View {
        TabView(selection: $selectedTab) {
            AnnouncementListView(loggedIn: $loggedIn)
                .tabItem {
                    //Image(systemName: "megaphone.fill")
                    Image("notifications-icon")
                    Text("Ogłoszenia")
                }
                .tag(1)
            EnrollmentListView(loggedIn: $loggedIn)
                .tabItem {
                    Image(systemName: "square.and.pencil")
                    //Image("notifications-icon")
                    Text("Zapisy")
                }
                .tag(2)
            
            FAQListView(loggedIn: $loggedIn)
                .tabItem {
                    Image(systemName: "questionmark.square")
                    //Image("schedule-icon")
                    Text("FAQ")
                }
                .tag(3)
            
            TimetablesListView(loggedIn: $loggedIn)
                .tabItem {
                    //Image(systemName: "mappin.circle.fill")
                    Image("schedule-icon")
                    Text("Harmonogram")
                }
                .tag(4)
            
            RoutesListView(loggedIn: $loggedIn)
                .tabItem {
                    Image(systemName: "map")
                    //Image("schedule-icon")
                    Text("Trasy")
                }
                .tag(5)

        }
        .onChange(of: activeAnnouncement.announcement.id){ change in
            if (activeAnnouncement.isActive){
                selectedTab = 1
            }
        }
        .onChange(of: activeEnrollment.enrollment.id){ change in
            if (activeEnrollment.isActive){
                selectedTab = 2
            }
        }
        .environmentObject(viewModel)
        .onAppear{
            if (loggedIn == true){
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
            }
            if (activeAnnouncement.isActive){
                selectedTab = 1
            }
            else if (activeEnrollment.isActive){
                selectedTab = 2
            }
        }
        
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(loggedIn: .constant(true), email: .constant("sample@email.com"), password: .constant("password"))
    }
}
