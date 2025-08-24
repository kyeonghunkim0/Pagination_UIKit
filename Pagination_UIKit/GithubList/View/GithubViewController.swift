//
//  GithubViewController.swift
//  Pagination_UIKit
//
//  Created by 김경훈 on 8/24/25.
//

import UIKit

final class GithubViewController: UIViewController {
    
    private let tableView = UITableView()
    
    let viewModel = GithubViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(GithubTableViewCell.self,
                           forCellReuseIdentifier: GithubTableViewCell.identifier)
        tableView.rowHeight = 110
        tableView.estimatedRowHeight = 110
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        Task {
            do {
                try await viewModel.fetchUsers(since: 0, page: 10)
                self.tableView.reloadData()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

extension GithubViewController: UITableViewDelegate {
}

extension GithubViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GithubTableViewCell.identifier, for: indexPath) as? GithubTableViewCell else { return UITableViewCell() }
        
        let user: User = viewModel.users[indexPath.row]
        cell.configure(with: user)
        
        return cell
    }
}
