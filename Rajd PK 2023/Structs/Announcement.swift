//
//  Contact.swift
//  Rajd PK 2023
//
//  Created by Kamil Dziedzic on 12/12/2022.
//

import Foundation

import SwiftUI
struct Announcement: Codable, Identifiable {
    var id: String?
    var title: String?
    var subTitle: String?
    var content: String?
    var hidden: Bool?
    var date: String?
    var isImage: Bool?
    var priority: Bool?
}
