//
//  GithubViewModel.swift
//  Pagination_UIKit
//
//  Created by 김경훈 on 8/24/25.
//

import Foundation

class GithubViewModel {
    
    @Published var isLoading: Bool = false
    
    @Published var users: [User] = []
    @Published var error: Error?
    
    private let service: GithubService
    
    init(service: GithubService = GithubService()) {
        self.service = service
    }
    
    func fetchUsers(since: Int, page: Int) async throws {
        do {
            self.users = try await service.fetchUsers(since: since, page: page)
            self.error = nil
        } catch {
            self.users = []
            self.error = error
        }
    }
}
