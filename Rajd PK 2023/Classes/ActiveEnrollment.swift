//
//  ActiveEnrollment.swift
//  Rajd PK 2023
//
//  Created by Kamil Dziedzic on 18/01/2023.
//

import SwiftUI
import Foundation
import FirebaseFirestore

class ActiveEnrollment: ObservableObject {
    
    var db = Firestore.firestore()
    
    @State static var shared = ActiveEnrollment()
    @Published var isActive: Bool
    @Published var enrollment: Enrollment
    init() {
        isActive = false
        enrollment = Enrollment()
    }
    
    func getEnrollment(id: String, completion: @escaping (Enrollment) -> Void){
        let docRef = db.collection("Enrollments").document(id)
        var enrollment = Enrollment()
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                let id = id
                let title = data?["title"] as? String ?? ""
                let content = data?["content"] as? String ?? ""
                let link = data?["link"] as? String ?? ""
                let hidden = data?["hidden"] as? Bool ?? true
                let date = data?["date"] as? String ?? ""
                enrollment = Enrollment(id: id, title: title, content: content, link: link, date: date, hidden: hidden)
            }
            else {
                print("Document does not exist")
                enrollment = Enrollment(id: "-1")
            }
            completion(enrollment)
        }
    }
}
