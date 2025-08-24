//
//  GithubViewModel.swift
//  Pagination_UIKit
//
//  Created by 김경훈 on 8/24/25.
//


import Foundation
import Combine

@MainActor
final class GithubViewModel: ObservableObject {
    
    @Published var isLoading: Bool = false
    @Published var users: [User] = []
    @Published var error: Error?
    
    private let service = GithubService()
    
    func fetchUsers(since: Int, page: Int) async {
        isLoading = true
        defer { isLoading = false }
        do {
            let result = try await service.fetchUsers(since: since, page: page)
            self.users = result
            self.error = nil
        } catch {
            self.error = error
        }
    }
}
