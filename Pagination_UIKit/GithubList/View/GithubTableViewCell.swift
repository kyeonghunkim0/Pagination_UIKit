//
//  GithubTableViewCell.swift
//  Pagination_UIKit
//
//  Created by 김경훈 on 8/24/25.
//

import UIKit
import Combine

final class GithubTableViewCell: UITableViewCell {
    
    static let identifier: String = "GithubTableViewCell"
    
    private var cancellable = Set<AnyCancellable>()
    
    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        return label
    }()
    
    private let linkLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    func setupUI() {
        [thumbnailImageView, nameLabel, linkLabel].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        selectionStyle = .none
        
        let d: CGFloat = 8
        
        NSLayoutConstraint.activate([
            thumbnailImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: d),
            thumbnailImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: d),
            thumbnailImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -d),
            thumbnailImageView.widthAnchor.constraint(equalToConstant: 90),
            
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: d),
            nameLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: d * 2),
            nameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -d),
            
            linkLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: d / 2),
            linkLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: d * 2),
            linkLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -d)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cancellable.removeAll()
        thumbnailImageView.image = nil
        nameLabel.text = nil
        linkLabel.text = nil
    }
    
    func configure(with user: User, viewModel: GithubViewModel) {
        viewModel.imagePublisher(for: user)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                self?.thumbnailImageView.image = image
            }
            .store(in: &cancellable)

        nameLabel.text = user.login
        linkLabel.text = user.html_url
    }
}
