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
    @Published var FAQs = [FAQ]()
    @Published var timetables = [Timetable]()
    @Published var routes = [Route]()
    
    var lastID = ""
    var db = Firestore.firestore()
    
    func fetchData() {
        db.collection("Routes").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No Routes")
                return
            }
            
            self.routes = documents.map { (queryDocumentSnapshot) -> Route in
                let data = queryDocumentSnapshot.data()
                let id = queryDocumentSnapshot.documentID
                let title = data["title"] as? String ?? ""
                let content = data["content"] as? String ?? ""
                let image = data["image"] as? String ?? ""
                let link = data["link"] as? String ?? ""
                let hidden = data["hidden"] as? Bool ?? true
                return Route(id: id, title: title, content: content, link: link, image: image, hidden: hidden)
            }
        }
        
        db.collection("Timetables").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No Timetables")
                return
            }
            
            self.timetables = documents.map { (queryDocumentSnapshot) -> Timetable in
                let data = queryDocumentSnapshot.data()
                let id = queryDocumentSnapshot.documentID
                let day = data["day"] as? String ?? ""
                let name1 = data["name1"] as? String ?? ""
                let content1 = data["content1"] as? String ?? ""
                let name2 = data["name2"] as? String ?? ""
                let content2 = data["content2"] as? String ?? ""
                let name3 = data["name3"] as? String ?? ""
                let content3 = data["content3"] as? String ?? ""
                return Timetable(id: id, day: day, name1: name1, content1: content1, name2: name2, content2: content2, name3: name3, content3: content3)
            }
        }
        
        db.collection("FAQs").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No FAQs")
                return
            }
            
            self.FAQs = documents.map { (queryDocumentSnapshot) -> FAQ in
                let data = queryDocumentSnapshot.data()
                let id = queryDocumentSnapshot.documentID
                let question = data["question"] as? String ?? ""
                let answer = data["answer"] as? String ?? ""
                return FAQ(id: id, question: question, answer: answer)
            }
        }
        
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
                let hidden = data["hidden"] as? Bool ?? true
                return Enrollment(id: id, title: title, content: content, link: link, date: date, hidden: hidden)
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
    
    func addEnrollment(title: String, content: String, link: String, hidden: Bool) async -> String {
        var ifOk = "1"
        var ref: DocumentReference? = nil
        if(!title.isEmpty && !link.isEmpty && !content.isEmpty)
        {
            let now = Date()
            let formatter = DateFormatter()
            formatter.timeZone = TimeZone.current
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = formatter.string(from: now)
            ref = db.collection("Enrollments").addDocument(data: ["title": title, "content": content, "link": link, "hidden": hidden, "date": date])
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
    
    func hideEnrollment(id: String) {
        db.collection("Enrollments").document(id).setData([
            "hidden": true], merge: true) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            }
    }
}
