//
//  User.swift
//  Pagination_UIKit
//
//  Created by 김경훈 on 8/24/25.
//

import Foundation

struct User: Decodable {
    let imageURL: String
    let nickName: String
    let link: String
    
    enum Codingkeys: String, CodingKey {
        case imageURL = "avatar_url"
        case nickName = "login"
        case link = "html_url"
    }
}
