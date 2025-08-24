//
//  GithubViewController.swift
//  Pagination_UIKit
//
//  Created by 김경훈 on 8/24/25.
//

import UIKit
import Combine

final class GithubViewController: UIViewController {
    
    private let tableView = UITableView()
    var dataSource: UITableViewDiffableDataSource<Section, User>!
    
    private var cancellable = Set<AnyCancellable>()
    
    let viewModel = GithubViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureTableView()
        bind()
    }
    
    func setupUI() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func bind() {
        viewModel.$users
            .receive(on: DispatchQueue.main)
            .sink { [weak self] users in
                self?.applySnapshot(users)
            }
            .store(in: &cancellable)
        
        Task { @MainActor in
            await viewModel.fetchUsers(since: 0, page: 10)
        }
    }
    
    func configureTableView() {
        tableView.register(GithubTableViewCell.self,
                           forCellReuseIdentifier: GithubTableViewCell.identifier)
        tableView.rowHeight = 110
        tableView.estimatedRowHeight = 110
        
        dataSource = UITableViewDiffableDataSource<Section, User>(tableView: tableView) {
            (tableView, indexPath, user) -> UITableViewCell in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: GithubTableViewCell.identifier, for: indexPath) as? GithubTableViewCell else { return UITableViewCell() }
            
            cell.configure(with: user)
            return cell
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, User>()
        snapshot.appendSections([.user])
        snapshot.appendItems(viewModel.users, toSection: .user)

        self.dataSource.apply(snapshot, animatingDifferences: true)
    }

    
    private func applySnapshot(_ users: [User], animated: Bool = true) {
        var snapShot = NSDiffableDataSourceSnapshot<Section, User>()
        snapShot.appendSections([.user])
        
        snapShot.appendItems(viewModel.users, toSection: .user)
        dataSource.apply(snapShot, animatingDifferences: animated)
    }
}
