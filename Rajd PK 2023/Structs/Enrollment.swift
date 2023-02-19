//
//  Enrollment.swift
//  Rajd PK 2023
//
//  Created by Kamil Dziedzic on 10/02/2023.
//

import Foundation
import SwiftUI

struct Enrollment: Codable, Identifiable {
    var id: String?
    var title: String?
    var content: String?
    var link: String?
    var date: String?
    var hidden: Bool?
}
