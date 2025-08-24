//
//  GithubViewModel.swift
//  Pagination_UIKit
//
//  Created by 김경훈 on 8/24/25.
//


import Foundation
import Combine

@MainActor
final class GithubViewModel {
    
    @Published private(set) var users: [User] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var isPaging: Bool = false
    
    @Published private(set) var error: Error?
    
    private let service: GithubService
    private var nextSince: Int? = nil                   // 마지막으로 받은 id
    private var hasMore = true
    private var currentTask: Task<Void, Never>?
    
    init(service: GithubService = GithubService()) {
        self.service = service
    }
    
    func loadInitial(perPage: Int = 30) {
        guard !isLoading else { return }
        currentTask?.cancel()
        isLoading = true
        error = nil
        nextSince = nil
        
        currentTask = Task { [weak self] in
            guard let self = self else { return }
            do {
                let first = try await service.fetchUsers(since: nil, perPage: perPage)
                self.users = first
                self.nextSince = first.last?.id
                self.hasMore = !first.isEmpty
            } catch {
                self.error = error
            }
            
            self.isLoading = false
        }
    }
    
    func load(currentIndex: Int, perPage: Int = 30, prefetchThreshold: Int = 5) {
        guard hasMore, !isPaging, !isLoading else { return }
        guard currentIndex >= users.count - prefetchThreshold else { return }
        
        isPaging = true
        currentTask?.cancel()
        currentTask = Task { [weak self] in
            guard let self = self else { return }
            do {
                let more = try await service.fetchUsers(since: self.nextSince, perPage: perPage)
                // 중복 방지
                let existing = Set(self.users.map(\.id))
                let filtered = more.filter { !existing.contains($0.id) }
                self.users.append(contentsOf: filtered)
                self.nextSince = self.users.last?.id
                self.hasMore = !filtered.isEmpty
            } catch {
                self.error = error
            }
            isPaging = false
        }
    }
    
    func refresh(perPage: Int = 30) {
        loadInitial(perPage: perPage)
    }
    
    func cancel() {
        currentTask?.cancel()
    }
}
