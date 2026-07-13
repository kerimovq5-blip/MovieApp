//
//  Untitled.swift
//  MovieApp
//
//  Created by Kerimov Qehreman on 05.07.26.
//
import UIKit

final class TrendingCell: UICollectionViewCell {


    private lazy var posterImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 16
        return iv
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .white
        label.numberOfLines = 2
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.image = nil
        titleLabel.text = nil
    }

    private func setupView() {
        
        contentView.addSubviews(posterImageView, titleLabel)
    }

    private func setupConstraints() {
        posterImageView
            .top(contentView.topAnchor).0
            .leading(contentView.leadingAnchor).0
            .trailing(contentView.trailingAnchor).0
            .bottom(contentView.bottomAnchor)

        titleLabel
            .leading(contentView.leadingAnchor, 12).0
            .trailing(contentView.trailingAnchor, -12).0
            .bottom(contentView.bottomAnchor, -12)
    }

    func configure(posterUrl: String?, title: String?) {
        titleLabel.text = title
        guard let posterUrl else { return }
        NetworkManager.shared.loadData(urlString: posterUrl) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.posterImageView.image = UIImage(data: data)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
