//
//  NetworkManager.swift
//  Pagination_UIKit
//
//  Created by 김경훈 on 8/24/25.
//

import Foundation

protocol URLSessionProtocol {
    func data(for: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol { }

final class GithubService {
    let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func fetchUsers(since: Int?, perPage: Int) async throws -> [User] {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.github.com"
        components.path = "/users"
        
        var queryItems: [URLQueryItem] = []
        if let since = since {
            queryItems.append(URLQueryItem(name: "since", value: String(since)))
        }
        queryItems.append(URLQueryItem(name: "per_page", value: String(perPage)))
        components.queryItems = queryItems
        
        guard let url = components.url else { throw URLError(.badURL) }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
        
        let (data, response) = try await session.data(for: request)
        
        guard let http = response as? HTTPURLResponse,
                (200..<300).contains(http.statusCode) else { throw URLError(.badServerResponse) }
        
        return try JSONDecoder().decode([User].self, from: data)
    }
}
