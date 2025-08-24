//
//  User.swift
//  Pagination_UIKit
//
//  Created by 김경훈 on 8/24/25.
//

import Foundation

struct User: Decodable, Hashable, Identifiable {
    let id: Int
    let login: String
    let avatar_url: String
    let html_url: String
}
