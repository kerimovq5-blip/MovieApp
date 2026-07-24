//
//  ReviewCell.swift
//  MovieApp
//
//  Created by Kerimov Qehreman on 25.07.26.
//

import UIKit

final class ReviewTableviewCell: UITableViewCell {

    static let identifier: String = "ReviewTableviewCell"

    private lazy var reviewProfileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.backgroundColor = UIColor.white.withAlphaComponent(0.15)
        return imageView
    }()

    private lazy var reviewLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor.white.withAlphaComponent(0.75)
        return label
    }()

    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.numberOfLines = 1
        return label
    }()

    private lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemOrange
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        setup()
        setConstraintView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        reviewProfileImage.image = nil
        reviewLabel.text = nil
        ratingLabel.text = nil
        authorLabel.text = nil
    }

    private func setup() {
        contentView.addSubviews(reviewProfileImage, authorLabel, ratingLabel, reviewLabel)
    }

    private func setConstraintView() {
        reviewProfileImage
            .top(contentView.topAnchor, 12).0
            .leading(contentView.leadingAnchor, 16).0
            .width(40).0
            .height(40)

        authorLabel
            .top(contentView.topAnchor, 12).0
            .leading(reviewProfileImage.trailingAnchor, 10).0
            .trailing(contentView.trailingAnchor, -16)

        ratingLabel
            .top(authorLabel.bottomAnchor, 2).0
            .leading(reviewProfileImage.trailingAnchor, 10).0
            .trailing(contentView.trailingAnchor, -16)

        reviewLabel
            .top(reviewProfileImage.bottomAnchor, 10).0
            .leading(contentView.leadingAnchor, 16).0
            .trailing(contentView.trailingAnchor, -16).0
            .bottom(contentView.bottomAnchor, -12)
    }

    func configureModel(with member: ReviewCellDto) {
        reviewProfileImage.image = UIImage(systemName: "person.crop.circle.fill")
        reviewProfileImage.tintColor = UIColor.white.withAlphaComponent(0.3)
        reviewLabel.text = member.reviewText
        ratingLabel.text = member.ratingText
        ratingLabel.isHidden = member.ratingText == nil
        authorLabel.text = member.author

        guard let url = member.avatarUrl else { return }
        NetworkManager.shared.loadData(urlString: url.absoluteString) {
            [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.reviewProfileImage.image = UIImage(data: data)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
