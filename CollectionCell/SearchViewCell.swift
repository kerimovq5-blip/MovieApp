//
//  SearchViewCell.swift
//  MovieApp
//
//  Created by Kerimov Qehreman on 12.07.26.
//

import UIKit

final class SearchViewCell: UITableViewCell {
    
    
    private lazy var posterThumbnailView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.layer.borderColor = UIColor.mainBackground.cgColor
        imageView.backgroundColor = .gray
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var ratingBadgeView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [ratingLabel, ratingIcon])
        stack.axis = .horizontal
        stack.spacing = 2
        stack.alignment = .center
        return stack
    }()

    
    private lazy var ratingIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "star.fill"))
        imageView.tintColor = .systemOrange
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .white
        return label
    }()

   

    private lazy var yearItem = makeInfoItem(icon: "calendar")
    private lazy var durationItem = makeInfoItem(icon: "clock")
    private lazy var genreItem = makeInfoItem(icon: "theatermasks")

    private lazy var infoStackView: UIStackView = {
        let separator1 = makeSeparatorLabel()
        let separator2 = makeSeparatorLabel()
        let stack = UIStackView(arrangedSubviews: [
            yearItem.container,
            separator1,
            durationItem.container,
            separator2, genreItem.container
        ])
        stack.axis = .vertical
        stack.spacing = 10
        stack.alignment = .center
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style : style , reuseIdentifier: reuseIdentifier)
        configureView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configureView() {
        
        contentView.addSubviews(
            posterThumbnailView ,
            titleLabel,
            ratingBadgeView,
            infoStackView
        )
        
        posterThumbnailView
            .top(contentView.topAnchor, 20).0
            .leading(contentView.leadingAnchor, 20).0
            .width(95).0
            .height(120)
        titleLabel
            .leading(posterThumbnailView.trailingAnchor , 10).0
            .top(posterThumbnailView.topAnchor).0
            .trailing(contentView.trailingAnchor, -16)
        
        ratingBadgeView
            .top(titleLabel.bottomAnchor, 10).0
            .leading(posterThumbnailView.trailingAnchor)
        
        infoStackView
            .top(ratingBadgeView.bottomAnchor, 10).0
            .leading(posterThumbnailView.trailingAnchor)
            
        

    }
    
   
    
    private func makeInfoItem(icon: String) -> (container: UIView, iconView: UIImageView, label: UILabel) {
        let container = UIView()
        let iconView = UIImageView(image: UIImage(systemName: icon))
        iconView.tintColor = UIColor.white.withAlphaComponent(0.7)
        iconView.contentMode = .scaleAspectFit
        
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor.white.withAlphaComponent(0.7)
        
        container.addSubviews(iconView, label)
        iconView
            .top(container.topAnchor).0
            .bottom(container.bottomAnchor).0
            .leading(container.leadingAnchor).0
            .width(16).0
            .height(16)
        label
            .leading(iconView.trailingAnchor, 6).0
            .trailing(container.trailingAnchor).0
            .centerY(iconView.centerYAnchor)

        return (container, iconView, label)
    }
    private func makeSeparatorLabel() -> UILabel {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor.white.withAlphaComponent(0.7)
        return label
    }
}
