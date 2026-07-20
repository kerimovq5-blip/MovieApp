//
//  AddToWatchListCell.swift
//  MovieApp
//
//  Created by Kerimov Qehreman on 16.07.26.
//

import UIKit

final class AddToListViewCell: UICollectionViewCell {
    static let identifier = "AddToWatchListCell"
    
    private var movieDetail: MovieDetailDto?
    private var movieId: Int?
    private var lastLoadedImagePath: String?
    
    private lazy var posterThumbnailView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.backgroundColor = .gray
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var ratingBadgeView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [ratingIcon, ratingLabel])
        stack.axis = .horizontal
        stack.spacing = 4
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
        label.textColor = .systemOrange
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
            separator2,
            genreItem.container
        ])
        stack.axis = .vertical
        stack.spacing = 6
        stack.alignment = .leading
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterThumbnailView.image = nil
        titleLabel.text = nil
        ratingLabel.text = nil
        ratingBadgeView.isHidden = true
        yearItem.label.text = ""
        durationItem.label.text = ""
        genreItem.label.text = ""
        lastLoadedImagePath = nil
        movieDetail = nil
        movieId = nil
    }
    
    private func setupLayout() {
        contentView.addSubviews(
            posterThumbnailView,
            titleLabel,
            ratingBadgeView,
            infoStackView
        )
        
        posterThumbnailView
            .top(contentView.topAnchor, 10).0
            .leading(contentView.leadingAnchor).0
            .bottom(contentView.bottomAnchor, -10).0
            .width(100).0
            .height(130)
            
        titleLabel
            .leading(posterThumbnailView.trailingAnchor, 12).0
            .top(posterThumbnailView.topAnchor, 4).0
            .trailing(contentView.trailingAnchor, -16)
        
        ratingBadgeView
            .top(titleLabel.bottomAnchor, 8).0
            .leading(posterThumbnailView.trailingAnchor, 10)
        
        infoStackView
            .top(ratingBadgeView.bottomAnchor, 2).0
            .leading(posterThumbnailView.trailingAnchor , 10)
            
    }
    
    private func makeInfoItem(icon: String) -> (container: UIView, iconView: UIImageView, label: UILabel) {
        let container = UIView()
        let iconView = UIImageView(image: UIImage(systemName: icon))
        iconView.tintColor = UIColor.white.withAlphaComponent(0.6)
        iconView.contentMode = .scaleAspectFit
        
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor.white.withAlphaComponent(0.6)
        
        container.addSubviews(iconView, label)
        
        iconView
            .top(container.topAnchor).0
            .bottom(container.bottomAnchor).0
            .leading(container.leadingAnchor).0
            .width(14).0
            .height(14)
            
        label
            .leading(iconView.trailingAnchor, 4).0
            .trailing(container.trailingAnchor).0
            .centerY(iconView.centerYAnchor)

        return (container, iconView, label)
    }
    
    private func makeSeparatorLabel() -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.textColor = .white
        
        return label
    }
    
    
    func configure(movieId: Int, posterURL: String?, title: String, rating: Double) {
           self.movieId = movieId
           titleLabel.text = title
           ratingLabel.text = String(format: "%.1f", rating)
           ratingBadgeView.isHidden = false
           
           
           if let posterURL = posterURL {
               loadImage(from: posterURL, into: posterThumbnailView)
           }
           
           
           fetchDetail()
       }
       
       private func fetchDetail() {
           guard let movieId = movieId else { return }
           
           MovieAppService.shared.getMovieDetail(id: movieId) {
               [weak self] result in
               guard let self = self,
               self.movieId == movieId else { return }
               
               switch result {
               case .success(let detail):
                   DispatchQueue.main.async {
                       self.movieDetail = detail
                       self.applyDetail(detail)
                   }
               case .failure(let error):
                   print("Detail yüklənmə xətası: \(error.localizedDescription)")
               }
           }
       }
    
       private func applyDetail(_ detail: MovieDetailDto) {
           titleLabel.text = detail.title
           
           if let ratingText = detail.ratingText {
               ratingLabel.text = ratingText
           }
           
           yearItem.label.text = detail.releaseYear ?? "-"
           durationItem.label.text = detail.runtimeText ?? "-"
           genreItem.label.text = detail.primaryGenre ?? "-"
       }
       
       private func loadImage(from urlString: String, into imageView: UIImageView) {
           self.lastLoadedImagePath = urlString
           
           NetworkManager.shared.loadData(urlString: urlString) { [weak self] result in
               guard let self = self else { return }
               
               switch result {
               case .success(let data):
                   DispatchQueue.main.async {
                       if self.lastLoadedImagePath == urlString {
                           imageView.image = UIImage(data: data)
                       }
                   }
               case .failure(let error):
                   print("Şəkil yüklənmə xətası: \(error.localizedDescription)")
               }
           }
       }
   }
