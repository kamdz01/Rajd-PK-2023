//
//  AnnouncementView.swift
//  Rajd PK 2023
//
//  Created by Kamil Dziedzic on 12/12/2022.
//

import SwiftUI
import UserNotifications

struct AnnouncementDetailView: View {
    
    @State private var showingAdvancedOptions = false
    @State private var chosenDelete = false
    @State private var deleted = 0
    @Binding var loggedIn: Bool
    @ObservedObject private var viewModel = AnnouncementViewModel()
    
    @State var announcement: Announcement
    var body: some View {
        ZStack{
            LinearGradient(colors: [Color("TabColor"), Color("BGBot")], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea(.all)
            if deleted == 1{
                Text("Poprawnie usunięto ogłoszenie")
            }
            else
            {
                ScrollView{
                    VStack {
                        if (announcement.isImage ?? false){
                            FirebaseImage(imageID: "\(announcement.id!).jpg")
                        }
                        VStack(alignment: .leading) {
                            Text(announcement.title!).font(.title)
                            Text(announcement.subTitle!).font(.title3)
                            Text(announcement.content!)
                        }
                        .padding()
                        
                    }
                    .toolbar {
                        if loggedIn{
                            Button("Usuń") {
                                chosenDelete.toggle()
                            }

                        }
                    }
                }
                .actionSheet(isPresented: $chosenDelete) {
                    ActionSheet(
                        title: Text("Czy na pewno chcesz usunąć to ogłoszenie?"),
                        buttons: [
                            .destructive(Text("Usuń")) {
                                self.viewModel.hideData(id: announcement.id ?? "ERROR")
                                chosenDelete = false
                                deleted = 1
                            },
                            .default(Text("Anuluj")) {
                                showingAdvancedOptions = false
                            },
                        ]
                    )
                }
            }
        }
    }
}

struct AnnouncementView_Previews: PreviewProvider {
    static var previews: some View {
        let announcement_prev = Announcement(title: "Title", subTitle: "subTitle", content: "content")
        AnnouncementDetailView(loggedIn: .constant(true), announcement: announcement_prev)
    }
}
