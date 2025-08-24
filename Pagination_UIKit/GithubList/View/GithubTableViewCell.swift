//
//  GithubTableViewCell.swift
//  Pagination_UIKit
//
//  Created by 김경훈 on 8/24/25.
//

import UIKit

final class GithubTableViewCell: UITableViewCell {
    
    static let identifier: String = "GithubTableViewCell"
    
    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "person")
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.text = "mojombo"
        return label
    }()
    
    private let linkLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .secondaryLabel
        label.text = "https://github.com/mojombo"
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
    
    func configure(with user: User) {
        //TODO: 이미지 작업 필요
//        thumbnailImageView.image = UIImage(data: user.imageURL)
        nameLabel.text = user.nickName
        linkLabel.text = user.link
    }
}
