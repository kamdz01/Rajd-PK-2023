//
//  AnnouncementsView.swift
//  Rajd PK 2023
//
//  Created by Kamil Dziedzic on 12/12/2022.
//

import SwiftUI

struct AnnouncementList: View{
    
    @Binding var loggedIn: Bool
    @EnvironmentObject var viewModel: AnnouncementViewModel
    
    var body: some View{
        List(viewModel.announcements) { announcement in
            if(!(announcement.content ?? "").isEmpty && !(announcement.title ?? "").isEmpty &&
               !(announcement.hidden ?? false)) {
                let dateArr = announcement.date?.components(separatedBy: " ")
                ZStack(alignment: .leading) {
                    HStack {
                        VStack(alignment: .leading) {
                            if (announcement.priority ?? false){
                                Group{
                                    HStack {
                                        VStack {
                                            Text(announcement.title!)
                                                .font(.title)
                                                .fontWeight(.semibold)
                                            Spacer()
                                        }
                                        Spacer()
                                        VStack {
                                            Text(dateArr?[0] ?? "")
                                                .font(.footnote)
                                                .foregroundColor(.secondary)
                                            Text(dateArr?[1] ?? "")
                                                .font(.footnote)
                                                .foregroundColor(.secondary)
                                            Spacer()
                                        }
                                        
                                    }
                                    Text(announcement.subTitle!).font(.title3)
                                        .fontWeight(.medium)
                                    Text(announcement.content!)
                                        .fontWeight(.medium)
                                        .lineLimit(2)
                                }
                            }
                            else {
                                Group{
                                    HStack {
                                        VStack {
                                            Text(announcement.title!)
                                                .font(.title)
                                            Spacer()
                                        }
                                        Spacer()
                                        VStack {
                                            Text(dateArr?[0] ?? "")
                                                .font(.footnote)
                                                .foregroundColor(.secondary)
                                            Text(dateArr?[1] ?? "")
                                                .font(.footnote)
                                                .foregroundColor(.secondary)
                                            Spacer()
                                        }
                                        
                                    }
                                    Text(announcement.subTitle!).font(.title3)
                                    Text(announcement.content!)
                                        .lineLimit(2)
                                }
                            }
                        }
                        Spacer()
                        //                                Image(systemName: "forward.frame.fill")
                    }
                    
                    NavigationLink(destination: AnnouncementDetailView(loggedIn: $loggedIn, announcement: announcement))
                    {
                        EmptyView()
                    }
                    .buttonStyle(PlainButtonStyle())
                    .opacity(0.0)
                    
                }
                .padding(.bottom)
                .listRowBackground(Color("FieldColor"))
            }
        }
    }
}


struct AnnouncementListView: View {
    
    @Binding var loggedIn: Bool
    @EnvironmentObject var viewModel: AnnouncementViewModel
    
    var body: some View {
        ZStack{
            LinearGradient(colors: [Color("TabColor"), Color("BGBot")], startPoint: .top, endPoint: .bottom).ignoresSafeArea(.all)
        NavigationView {
                VStack {
                    if #available(iOS 16.0, *) {
                        AnnouncementList(loggedIn: $loggedIn)
                            .onAppear() {
                                self.viewModel.fetchData()
                            }
                            .refreshable {
                                self.viewModel.fetchData()
                                print("ODSWIEŻONO")
                            }
                            .background(LinearGradient(colors: [Color("TabColor"), Color("BGBot")], startPoint: .top, endPoint: .bottom))
                            .scrollContentBackground(.hidden)
                    }
                    else if #available(iOS 15.0, *) {
                        AnnouncementList(loggedIn: $loggedIn)
                            .onAppear() {
                                self.viewModel.fetchData()
                            }
                            .refreshable {
                                self.viewModel.fetchData()
                                print("ODSWIEŻONO")
                            }
                            .background(LinearGradient(colors: [Color("TabColor"), Color("BGBot")], startPoint: .top, endPoint: .bottom))
                    } else {
                        AnnouncementList(loggedIn: $loggedIn)
                            .onAppear() {
                                self.viewModel.fetchData()
                            }
                            .background(LinearGradient(colors: [Color("TabColor"), Color("BGBot")], startPoint: .top, endPoint: .bottom))
                    }
                }
                .navigationTitle("Ogłoszenia")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

struct AnnouncementsView_Previews: PreviewProvider {
    static let viewModel = AnnouncementViewModel()
    static var previews: some View {
        AnnouncementListView(loggedIn: .constant(true))
            .environmentObject(viewModel)
        MainView(loggedIn: .constant(true), email: .constant("sample@email.com"), password: .constant("password"))
    }
}
