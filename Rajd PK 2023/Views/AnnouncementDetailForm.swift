//
//  AnnouncementDetailForm.swift
//  Rajd PK 2023
//
//  Created by Kamil Dziedzic on 15/12/2022.
//

import SwiftUI
import FirebaseStorage
import FirebaseMessaging
import Foundation
import Firebase

struct AnnouncementDetailForm: View {
    @State var ifAdded = 0
    @State var uploadProgressImg = 0.0
    @State var uploadProgressDoc = 0.0
    @EnvironmentObject var viewModel: AnnouncementViewModel
    @Binding var showingAdvancedOptions: Bool
    @Binding var inputImage: UIImage?
    @Binding var title: String
    @Binding var subTitle: String
    @Binding var content: String
    @Binding var priority: Bool
    var body: some View {
        ZStack{
            LinearGradient(colors: [Color("TabColor"), Color("BGBot")], startPoint: .top, endPoint: .bottom).ignoresSafeArea(.all)
            if ifAdded == 2{
                VStack{
                    Text("Czekaj...")
                        .font(.title2)
                        .padding(20)
                    ProgressView("Wysyłanie ogłoszenia w toku…", value: uploadProgressDoc, total: 1.0)
                        .padding(10)
                    if (inputImage != nil){
                        ProgressView("Wysyłanie zdjęcia w toku…", value: uploadProgressImg, total: 1.0)
                            .padding(10)
                    }
                }
                .padding()
                
            }
            else if ifAdded == 1{
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
                        Text("Czy na pewno chcesz opublikować to ogłoszenie?")
                            .font(.title)
                            .padding(.bottom)
                        if priority{
                            Text("WYRÓŻNIONE")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(Color.red)
                        }
                        if(inputImage != nil){
                            Image(uiImage: inputImage!)
                                .resizable()
                                .scaledToFit()
                        }
                        VStack(alignment: .leading){
                            Text("Tytuł: \n\(title)")
                                .multilineTextAlignment(.leading)
                                .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                            Text("Podtytuł: \n\(subTitle)")
                                .multilineTextAlignment(.leading)
                                .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                            Text("Zawartość: \n\(content)")
                                .multilineTextAlignment(.leading)
                                .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                        }
                        .padding(/*@START_MENU_TOKEN@*/.all, 10.0/*@END_MENU_TOKEN@*/)
                        Button("Dodaj") {
                            Task{
                                let lastID = await self.viewModel.addData(title: title, subTitle: subTitle, content: content, hidden: false, isImage: (inputImage != nil), priority: priority)
                                
                                if lastID != "-1"{
                                    uploadProgressDoc = 1
                                    if inputImage != nil{
                                        uploadImage(imageId: lastID)
                                        let sender = PushNotificationSender()
                                        let title_l = title
                                        let content_l = content
                                        sender.sendToTopic(title: title_l, body: content_l, id: lastID, viewModel: viewModel)
                                        ifAdded = 2
                                    }
                                    else{
                                        let sender = PushNotificationSender()
                                        let title_l = title
                                        let content_l = content
                                        sender.sendToTopic(title: title_l, body: content_l, id: lastID, viewModel: viewModel)
                                        ifAdded = 1
                                    }
                                    
                                }
                                else {
                                    ifAdded = 3
                                }
                                title = ""
                                subTitle = ""
                                content = ""
                                showingAdvancedOptions = false
                                priority = false
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
                    Text("Błąd podczas dodawania ogłoszenia")
                        .font(.title2)
                        .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                }
            }
        }
    }
    
    class PushNotificationSender {
        func sendPushNotification(to token: String, title: String, body: String, viewModel: AnnouncementViewModel) {
            var serverKey = ""
            viewModel.getKey(){key in
                serverKey = key
                let urlString = "https://fcm.googleapis.com/fcm/send"
                let url = NSURL(string: urlString)!
                let paramString: [String : Any] = ["to" : token,
                                                   "notification" : ["title" : title, "body" : body, "sound": "default"],
                                                   "data" : ["user" : "test_id"]
                ]
                let request = NSMutableURLRequest(url: url as URL)
                request.httpMethod = "POST"
                request.httpBody = try? JSONSerialization.data(withJSONObject:paramString, options: [.prettyPrinted])
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.setValue("key=\(serverKey)", forHTTPHeaderField: "Authorization")
                let task =  URLSession.shared.dataTask(with: request as URLRequest)  { (data, response, error) in
                    do {
                        if let jsonData = data {
                            if let jsonDataDict  = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] {
                                NSLog("Received data:\n\(jsonDataDict))")
                            }
                        }
                    } catch let err as NSError {
                        print(err.debugDescription)
                    }
                }
                task.resume()
            }
        }
        
        
        
        func sendToTopic(title: String, body: String, id: String, viewModel: AnnouncementViewModel) {
            var serverKey = ""
            viewModel.getKey(){key in
                serverKey = key
                let urlString = "https://fcm.googleapis.com/fcm/send"
                let url = NSURL(string: urlString)!
                let paramString: [String : Any] = ["to" : "/topics/test_topic",
                                                   "notification" : ["title" : title, "body" : body,"announcementID": id , "sound": "default"],
                                                   "data" : ["user" : "test_id"],
                ]
                let request = NSMutableURLRequest(url: url as URL)
                request.httpMethod = "POST"
                request.httpBody = try? JSONSerialization.data(withJSONObject:paramString, options: [.prettyPrinted])
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.setValue("key=\(serverKey)", forHTTPHeaderField: "Authorization")
                let task =  URLSession.shared.dataTask(with: request as URLRequest)  { (data, response, error) in
                    do {
                        if let jsonData = data {
                            if let jsonDataDict  = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] {
                                NSLog("Received data:\n\(jsonDataDict))")
                            }
                        }
                    } catch let err as NSError {
                        print(err.debugDescription)
                    }
                }
                task.resume()
            }
        }
    }
    
    func sendtoDevices(vievModel: AnnouncementViewModel){
        let title_l = title
        let content_l = content
        
        let sender = PushNotificationSender()
        let devRef = viewModel.db.collection("Devices")
        devRef.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    sender.sendPushNotification(to: document.documentID, title: "\(title_l)", body: "\(content_l)", viewModel: viewModel)
                    print(document.documentID)
                }
            }
        }
    }

    
    func uploadImage(imageId: String){
        let imageData = inputImage?.jpegData(compressionQuality: 0.8)
        let storageRef = Storage.storage().reference()
        let riversRef = storageRef.child("images/\(imageId).jpg")
        let uploadTask = riversRef.putData(imageData!, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                return
            }
            _ = metadata.size
            riversRef.downloadURL { (url, error) in
                guard url != nil else {
                    return
                }
            }
        }
        uploadTask.observe(.progress) { snapshot in
            uploadProgressImg = snapshot.progress?.fractionCompleted ?? 0
        }
        uploadTask.observe(.resume) { snapshot in
            print("Upload resumed")
        }
        uploadTask.observe(.success) { snapshot in
            print("Upload finished successfully")
            ifAdded = 1
            uploadProgressImg = 0.0
            inputImage = nil
        }
        uploadTask.observe(.failure) { snapshot in
            print("Upload error")
            ifAdded = 3
            uploadProgressImg = 0.0
            uploadProgressDoc = 0
            inputImage = nil
            self.viewModel.hideData(id: imageId )
        }
    }
}

struct AnnouncementDetailForm_Previews: PreviewProvider {
    static let viewModel = AnnouncementViewModel()
    static var previews: some View {
        AnnouncementDetailForm(showingAdvancedOptions: .constant(false), inputImage: .constant(UIImage()), title: .constant("title"), subTitle: .constant("subTitle"), content: .constant("content"), priority: .constant(true))
            .environmentObject(viewModel)
    }
}
