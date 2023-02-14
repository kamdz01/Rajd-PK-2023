//
//  EnrollmentDetailForm.swift
//  Rajd PK 2023
//
//  Created by Kamil Dziedzic on 13/02/2023.
//

import SwiftUI
import FirebaseStorage
import FirebaseMessaging
import Foundation
import Firebase

struct EnrollmentDetailForm: View {
    @State var ifAdded = 0
    @State var uploadProgressDoc = 0.0
    @EnvironmentObject var viewModel: FirebaseViewModel
    @Binding var showingAdvancedOptions: Bool
    @Binding var title: String
    @Binding var content: String
    @Binding var link: String
    @Binding var sendNotification: Bool
    
    var body: some View {
        ZStack{
            LinearGradient(colors: [Color("TabColor"), Color("BGBot")], startPoint: .top, endPoint: .bottom).ignoresSafeArea(.all)
            if ifAdded == 1{
                VStack {
                    Image(systemName: "checkmark.circle")
                        .resizable()
                        .foregroundColor(Color.green)
                        .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                        .frame(width: 150.0, height: 150.0)
                    Text("Poprawnie dodano twoje ogłoszenie")
                }
            }
            else if ifAdded == 0{
                ScrollView{
                    VStack{
                        Text("Czy na pewno chcesz opublikować te zapisy?")
                            .font(.title)
                            .padding(.bottom)
                        VStack(alignment: .leading){
                            Text("Tytuł: \n\(title)")
                                .multilineTextAlignment(.leading)
                                .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                            Text("Zawartość: \n\(content)")
                                .multilineTextAlignment(.leading)
                                .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                            Text("Link: \n\(link)")
                                .multilineTextAlignment(.leading)
                                .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                        }
                        .padding(/*@START_MENU_TOKEN@*/.all, 10.0/*@END_MENU_TOKEN@*/)
                        Button("Dodaj") {
                            Task{
                                let lastID = await self.viewModel.addEnrollment(title: title, content: content, link: link, hidden: false)
                                
                                if lastID != "-1"{
                                    uploadProgressDoc = 1

                                        if (sendNotification){
                                            let sender = PushNotificationSender()
                                            let title_l = title
                                            let content_l = content
                                            sender.sendToTopic(title: title_l, body: content_l, id: lastID, collection: "Enrollments", viewModel: viewModel)
                                        }
                                        ifAdded = 1
                                    
                                    
                                }
                                else {
                                    ifAdded = 3
                                }
                                title = ""
                                link = ""
                                content = ""
                                showingAdvancedOptions = false
                            }
                        }
                        .padding(.horizontal, 20.0)
                        .padding(.vertical, 10.0)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                    }
                    .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                    
                }
            }
            else{
                VStack{
                    Image(systemName: "xmark.circle")
                        .resizable()
                        .foregroundColor(Color.red)
                        .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                        .frame(width: 150.0, height: 150.0)
                    Text("Błąd podczas dodawania zapisów")
                        .font(.title2)
                        .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                }
            }
        }
    }
}

struct EnrollmentDetailForm_Previews: PreviewProvider {
    static let viewModel = FirebaseViewModel()
    static var previews: some View {
        EnrollmentDetailForm(showingAdvancedOptions: .constant(false), title: .constant("title"), content: .constant("content"), link: .constant("link"), sendNotification: .constant(true))
            .environmentObject(viewModel)
    }
}
