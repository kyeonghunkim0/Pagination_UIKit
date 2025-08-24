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
        
        viewModel.$error
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                let alert = UIAlertController(title: "오류",
                                              message: error?.localizedDescription,
                                              preferredStyle: .alert)
                let ok = UIAlertAction(title: "확인", style: .default)
                alert.addAction(ok)
                
                self?.present(alert, animated: true)
            }
            .store(in: &cancellable)
        
        viewModel.$isPaging
            .receive(on: DispatchQueue.main)
            .sink { [weak self] paging in self?.setFooterLoading(paging) }
            .store(in: &cancellable)
        
        viewModel.loadInitial(perPage: 30)
    }
    
    func configureTableView() {
        tableView.register(GithubTableViewCell.self,
                           forCellReuseIdentifier: GithubTableViewCell.identifier)
        tableView.rowHeight = 110
        tableView.estimatedRowHeight = 110
        tableView.prefetchDataSource = self
        
        dataSource = UITableViewDiffableDataSource<Section, User>(tableView: tableView) {
            (tableView, indexPath, user) -> UITableViewCell in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: GithubTableViewCell.identifier, for: indexPath) as? GithubTableViewCell else { return UITableViewCell() }
            
            cell.configure(with: user)
            return cell
        }
    }
    
    private func setFooterLoading(_ loading: Bool) {
        if loading {
            let spinner = UIActivityIndicatorView(style: .medium)
            spinner.startAnimating()
            spinner.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 44)
            tableView.tableFooterView = spinner
        } else {
            tableView.tableFooterView = UIView(frame: .zero)
        }
    }
    
    private func applySnapshot(_ users: [User], animated: Bool = true) {
        var snapShot = NSDiffableDataSourceSnapshot<Section, User>()
        snapShot.appendSections([.user])
        
        snapShot.appendItems(viewModel.users, toSection: .user)
        dataSource.apply(snapShot, animatingDifferences: animated)
    }
}

extension GithubViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let maxIndex = indexPaths.map(\.row).max() ?? 0
        viewModel.load(currentIndex: maxIndex, perPage: 30)
    }
}
