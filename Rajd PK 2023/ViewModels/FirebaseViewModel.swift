//
//  ContactViewModel.swift
//  Rajd PK 2023
//
//  Created by Kamil Dziedzic on 12/12/2022.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import SwiftUI

class FirebaseViewModel: ObservableObject {
    
    @Published var announcements = [Announcement]()
    @Published var enrollments = [Enrollment]()
    @Published var FAQs = [FAQ]()
    @Published var timetables = [Timetable]()
    @Published var routes = [Route]()
    private let fileManager = LocalFileManager.instance
    private var ifFetched = false
    
    var lastID = ""
    var db = Firestore.firestore()
    
    func fetchData() {
        @AppStorage("favRoutesStr") var favRoutesStr = ""
        
        if (ifFetched){
            print("Detected more than one execution of fetchData() func. Posiible snapshot leak!")
            return
        }
        
        print("___________________Adding Snapshots___________________")
        
        db.collection("Routes").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No Routes")
                return
            }
            
            self.routes = documents.map { (queryDocumentSnapshot) -> Route in
                let data = queryDocumentSnapshot.data()
                let id = queryDocumentSnapshot.documentID
                let title = (data["title"] as? String ?? "").replaceNl()
                let content = (data["content"] as? String ?? "").replaceNl()
                let image = data["image"] as? String ?? ""
                let link = data["link"] as? String ?? ""
                let hidden = data["hidden"] as? Bool ?? true
                return Route(id: id, title: title, content: content, link: link, image: image, hidden: hidden)
            }
            self.routes.sort(by: {$0.title! < $1.title!})
            let favRoutes = favRoutesStr.components(separatedBy: ";")
            self.routes.sort(by: {favRoutes.firstIndex(of: $0.id!) ?? -1 > favRoutes.firstIndex(of: $1.id!) ?? -1})
        }
        
        db.collection("Timetables").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No Timetables")
                return
            }
            
            self.timetables = documents.map { (queryDocumentSnapshot) -> Timetable in
                let data = queryDocumentSnapshot.data()
                let id = queryDocumentSnapshot.documentID
                let day = (data["day"] as? String ?? "").replaceNl()
                let no = data["no"] as? Int ?? -1
                let subTitle = (data["subTitle"] as? String ?? "").replaceNl()
                let name1 = (data["name1"] as? String ?? "").replaceNl()
                let content1 = (data["content1"] as? String ?? "").replaceNl()
                let name2 = (data["name2"] as? String ?? "").replaceNl()
                let content2 = (data["content2"] as? String ?? "").replaceNl()
                let name3 = (data["name3"] as? String ?? "").replaceNl()
                let content3 = (data["content3"] as? String ?? "").replaceNl()
                return Timetable(id: id, no: no, day: day, subTitle: subTitle, name1: name1, content1: content1, name2: name2, content2: content2, name3: name3, content3: content3)
            }
            self.timetables.sort(by: {$0.no! < $1.no!})
        }
        
        db.collection("FAQs").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No FAQs")
                return
            }
            
            self.FAQs = documents.map { (queryDocumentSnapshot) -> FAQ in
                let data = queryDocumentSnapshot.data()
                let id = queryDocumentSnapshot.documentID
                let no = data["no"] as? Int ?? -1
                let question = (data["question"] as? String ?? "").replaceNl()
                let answer = (data["answer"] as? String ?? "").replaceNl()
                return FAQ(id: id, no: no, question: question, answer: answer)
            }
            self.FAQs.sort(by: {$0.no! < $1.no!})
        }
        
        db.collection("Enrollments").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No enrollments")
                return
            }
            
            self.enrollments = documents.map { (queryDocumentSnapshot) -> Enrollment in
                let data = queryDocumentSnapshot.data()
                let id = queryDocumentSnapshot.documentID
                let title = (data["title"] as? String ?? "").replaceNl()
                let content = (data["content"] as? String ?? "").replaceNl()
                let date = data["date"] as? String ?? ""
                let link = (data["link"] as? String ?? "").replaceNl()
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
                let title = (data["title"] as? String ?? "").replaceNl()
                let subTitle = (data["subTitle"] as? String ?? "").replaceNl()
                let content = (data["content"] as? String ?? "").replaceNl()
                let hidden = data["hidden"] as? Bool ?? true
                let date = data["date"] as? String ?? ""
                let isImage = data["isImage"] as? Bool ?? false
                let priority = data["priority"] as? Bool ?? false
                return Announcement(id: id, title: title, subTitle: subTitle, content: content, hidden: hidden, date: date, isImage: isImage, priority: priority)
            }
            self.announcements.sort(by: {$0.date! > $1.date!})
            self.announcements.sort{$0.priority! && !$1.priority!}
        }
        
        db.collection("Images").addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            snapshot.documentChanges.forEach { diff in
                let data = diff.document.data()
                let idChanged = data["id"] as? String ?? "err"
                if (data["collection"] as? String == "Announcements"){
                    if (diff.type == .modified) {
                        print("Modified image: \(diff.document.data())")
                        self.loadImageToMem(imageName: "\(idChanged.trimmingCharacters(in: .whitespacesAndNewlines)).jpg", path: "images/")
                    }
                    if (diff.type == .removed) {
                        print("Removed image: \(diff.document.data())")
                        self.loadImageToMem(imageName: "\(idChanged.trimmingCharacters(in: .whitespacesAndNewlines)).jpg", path: "images/")
                    }
                }
                else if (data["collection"] as? String == "Routes"){
                    if let imgName = self.routes.first(where: {$0.id == idChanged}) {
                        if (diff.type == .modified) {
                            print("Modified image: \(diff.document.data())")
                            self.loadImageToMem(imageName: imgName.image ?? "err", path: "routes/")
                        }
                        if (diff.type == .removed) {
                            print("Removed image: \(diff.document.data())")
                            self.loadImageToMem(imageName: imgName.image ?? "err", path: "routes/")
                        }
                    }
                }
                else {
                    print("Błąd odczytu z bazy danych (img)")
                    return
                }
            }
        }
        ifFetched = true
    }
    
    func loadImageToMem(imageName: String, path: String){
        if self.fileManager.getImage(imageName: imageName, folderName: "temp") != nil{
            let storage = Storage.storage().reference(withPath: "\(path)\(imageName)")
            storage.getData(maxSize: ((2048 * 2048 * 5 * 5) as Int64) ) { data, error in
                if error != nil {
                    _ = self.fileManager.deleteImage(imageName: imageName , folderName: "temp")
                    print("Download fail")
                    return
                }
                if (data != nil){
                    _ = self.fileManager.deleteImage(imageName: imageName , folderName: "temp")
                    self.fileManager.saveImage(image: UIImage(data: data!)!, imageName: imageName, folderName: "temp")
                    print("Download success")
                    return
                }
                else{
                    _ = self.fileManager.deleteImage(imageName: imageName , folderName: "temp")
                    print("Download fail")
                    return
                }
            }
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
    
    func getLink(id: String, completion: @escaping (String) -> Void){
        let docRef = db.collection("Links").document(id)
        var link = String()
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                link = data?["link"] as? String ?? "-1"
            }
            completion(link)
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
                    ///Adding to Images collection
                    if(isImage){
                        var refImg: DocumentReference? = nil
                        refImg = self.db.collection("Images").addDocument(data: ["id": ref?.documentID ?? "err","collection": "Announcements","changed": false]) { err in
                            if let err = err {
                                print("Error adding document (Img): \(err)")
                            } else {
                                print("Document (Img) added with ID: \(refImg?.documentID ?? "err")")
                            }
                        }
                    }
                    ///___________________
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

extension String
{
    func replaceNl() -> String
    {
        return self.replacingOccurrences(of: "\\n", with: "\n", range: nil).replacingOccurrences(of: "\n ", with: "\n", range: nil).replacingOccurrences(of: " \n", with: "\n", range: nil)
    }
}
