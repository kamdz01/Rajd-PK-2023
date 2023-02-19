//
//  Route.swift
//  Rajd PK 2023
//
//  Created by Kamil Dziedzic on 19/02/2023.
//

import Foundation
import SwiftUI

struct Route: Codable, Identifiable {
    var id: String?
    var title: String?
    var content: String?
    var link: String?
    var image: String?
    var hidden: Bool?
}
