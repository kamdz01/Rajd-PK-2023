//
//  ContactViewModel.swift
//  Rajd PK 2023
//
//  Created by Kamil Dziedzic on 12/12/2022.
//

import Foundation
import FirebaseFirestore

class FirebaseViewModel: ObservableObject {
    
    @Published var announcements = [Announcement]()
    @Published var enrollments = [Enrollment]()
    var lastID = ""
    var db = Firestore.firestore()
    
    func fetchData() {
        db.collection("Enrollments").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No enrollments")
                return
            }
            
            self.enrollments = documents.map { (queryDocumentSnapshot) -> Enrollment in
                let data = queryDocumentSnapshot.data()
                let id = queryDocumentSnapshot.documentID
                let title = data["title"] as? String ?? ""
                let content = data["content"] as? String ?? ""
                let date = data["date"] as? String ?? ""
                let link = data["link"] as? String ?? ""
                return Enrollment(id: id, title: title, content: content, link: link, date: date)
            }
            self.enrollments.sort(by: {$0.date! > $1.date!})
        }
        
        db.collection("Announcements").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No announcements")
                return
            }
            
            self.announcements = documents.map { (queryDocumentSnapshot) -> Announcement in
                let data = queryDocumentSnapshot.data()
                let id = queryDocumentSnapshot.documentID
                let title = data["title"] as? String ?? ""
                let subTitle = data["subTitle"] as? String ?? ""
                let content = data["content"] as? String ?? ""
                let hidden = data["hidden"] as? Bool ?? true
                let date = data["date"] as? String ?? ""
                let isImage = data["isImage"] as? Bool ?? false
                let priority = data["priority"] as? Bool ?? false
                return Announcement(id: id, title: title, subTitle: subTitle, content: content, hidden: hidden, date: date, isImage: isImage, priority: priority)
            }
            self.announcements.sort(by: {$0.date! > $1.date!})
            self.announcements.sort{$0.priority! && !$1.priority!}
        }
    }
    
    func getKey(completion: @escaping (String) -> Void){
        let docRef = db.collection("Keys").document("SERVER_KEY")
        var key = String()
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                key = data?["key"] as? String ?? "-1"
            }
            completion(key)
        }
    }
    
    func hideAnnouncement(id: String) {
        db.collection("Announcements").document(id).setData([
            "hidden": true], merge: true) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            }
    }
    
    func addAnnouncement(title: String, subTitle: String, content: String, hidden: Bool, isImage: Bool, priority: Bool) async -> String {
        var ifOk = "1"
        var ref: DocumentReference? = nil
        if(!title.isEmpty && !subTitle.isEmpty && !content.isEmpty)
        {
            let now = Date()
            let formatter = DateFormatter()
            formatter.timeZone = TimeZone.current
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = formatter.string(from: now)
            ref = db.collection("Announcements").addDocument(data: ["title": title, "subTitle": subTitle, "content": content, "hidden": hidden, "date": date, "isImage": isImage, "priority": priority])
            { err in
                if let err = err {
                    print("Error adding document: \(err)")
                    ifOk = "-1"
                } else {
                    print("Document added with ID: \(ref!.documentID)")
                    if (ref?.documentID != nil && ifOk == "1"){
                        ifOk = ref!.documentID
                    }
                }
            }
            if (ref?.documentID != nil && ifOk == "1"){
                ifOk = ref!.documentID
            }
        }
        else{
            print("text field empty!")
            ifOk = "-1"
        }
        return ifOk
    }
}
