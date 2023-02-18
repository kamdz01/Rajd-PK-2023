//
//  AnnouncementsView.swift
//  Rajd PK 2023
//
//  Created by Kamil Dziedzic on 12/12/2022.
//

import SwiftUI

struct AnnouncementList: View{
    
    @Binding var loggedIn: Bool
    @EnvironmentObject var viewModel: FirebaseViewModel
    @State private var chosenDelete = false
    @State private var announcementToDeleteID = ""
    
    var body: some View{
        List(viewModel.announcements) { announcement in
            if(!(announcement.content ?? "").isEmpty && !(announcement.title ?? "").isEmpty &&
               !(announcement.hidden ?? false)) {
                let dateArr = announcement.date?.components(separatedBy: " ")
                if #available(iOS 15.0, *) {
                    AnnouncementViewItem(loggedIn: $loggedIn, announcement: announcement, dateArr: dateArr)
                        .contextMenu {
                            if (loggedIn){
                                Button(role: .destructive) {
                                    chosenDelete = true
                                    announcementToDeleteID = announcement.id ?? ""
                                } label: {
                                    Label("Usuń", systemImage: "trash.fill")
                                }
                            }
                        }
                        .listRowSeparator(.hidden)
                } else {
                    AnnouncementViewItem(loggedIn: $loggedIn, announcement: announcement, dateArr: dateArr)
                        .contextMenu {
                            if (loggedIn){
                                Button() {
                                    chosenDelete = true
                                    announcementToDeleteID = announcement.id ?? ""
                                } label: {
                                    Label("Usuń", systemImage: "trash.fill")
                                }
                                .foregroundColor(/*@START_MENU_TOKEN@*/.red/*@END_MENU_TOKEN@*/)
                            }
                        }
                        .listRowBackground(RoundedRectangle(cornerRadius: 10).fill(Color("FieldColor")).padding(7.0))
                }
            }
        }
        .actionSheet(isPresented: $chosenDelete) {
            ActionSheet(
                title: Text("Czy na pewno chcesz usunąć to ogłoszenie?"),
                buttons: [
                    .destructive(Text("Usuń")) {
                        self.viewModel.hideAnnouncement(id: announcementToDeleteID)
                        chosenDelete = false
                    },
                    .default(Text("Anuluj")) {
                        chosenDelete = false
                    },
                ]
            )
        }
    }
}


struct AnnouncementListView: View {
    
    @Binding var loggedIn: Bool
    @EnvironmentObject var viewModel: FirebaseViewModel
    @ObservedObject var activeAnnouncement = ActiveAnnouncement.shared
    @State var ifAdding = false
    
    var body: some View {
        ZStack{
            LinearGradient(colors: [Color("TabColor"), Color("BGBot")], startPoint: .top, endPoint: .bottom).ignoresSafeArea(.all)
            NavigationView {
                VStack {
                    if (activeAnnouncement.isActive){
                        NavigationLink(destination: AnnouncementDetailView(announcement: activeAnnouncement.announcement), isActive: $activeAnnouncement.isActive) { EmptyView() }
                    }
                    NavigationLink(destination: AnnouncementFormContainer(ifAdding: $ifAdding), isActive: $ifAdding) {
                        EmptyView()
                    }
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
                                UITableView.appearance().backgroundColor = UIColor.clear
                                UITableViewCell.appearance().backgroundColor = UIColor.clear
                                self.viewModel.fetchData()
                            }
                            .background(LinearGradient(colors: [Color("TabColor"), Color("BGBot")], startPoint: .top, endPoint: .bottom))
                    }
                }
                .navigationTitle("Ogłoszenia")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar{
                    ToolbarItem(placement: .navigationBarTrailing){
                        if (loggedIn){
                            Button("Dodaj"){
                                ifAdding = true
                            }
                        }
                    }
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
}


struct AnnouncementViewItem: View {
    
    @Binding var loggedIn: Bool
    let announcement: Announcement
    let dateArr: [String]?
    var body: some View {
        ZStack(alignment: .leading) {
            HStack {
                if (announcement.priority ?? true){
                    Rectangle()
                        .fill(.red)
                        .frame(width: 4)
                        .cornerRadius(/*@START_MENU_TOKEN@*/10.0/*@END_MENU_TOKEN@*/)
                }
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
                //Image(systemName: "forward.frame.fill")
            }
            
            
            NavigationLink(destination: AnnouncementDetailView(announcement: announcement))
            {
                EmptyView()
            }
            .buttonStyle(PlainButtonStyle())
            .opacity(0.0)
            
        }
        .padding(.vertical, 5.0)
        .padding(.horizontal, -7.0)
        .padding(7.0)
        .listRowBackground(RoundedRectangle(cornerRadius: 10).fill(Color("FieldColor")).padding(7.0))
    }
}

struct AnnouncementsView_Previews: PreviewProvider {
    static let viewModel = FirebaseViewModel()
    static var previews: some View {
        AnnouncementListView(loggedIn: .constant(true))
            .environmentObject(viewModel)
        MainView(loggedIn: .constant(true), email: .constant("sample@email.com"), password: .constant("password"))
            .previewDisplayName("MainView")
    }
}
