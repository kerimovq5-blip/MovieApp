//
//  DetailViewController.swift
//  MovieApp
//
//  Created by Kerimov Qehreman on 09.07.26.
//

import UIKit

final class DetailViewController: UIViewController {
    
    
    private enum DetailTab: Int , CaseIterable {
        case about, reviews, cast
        
        var title: String {
            switch self {
            case .about: return "About Movie"
            case .reviews: return "Reviews"
            case .cast: return "Cast"
            }
        }
    }
    
    private let movieId: Int
    private var selectedTab: DetailTab = .about

    init(movieId: Int) {
        self.movieId = movieId
        super.init(nibName: nil, bundle: nil)
    }
    
    private var isBookmarked = false
    private var movieDetail: MovieDetailDto?
    
    private var castMembers: [CastDto] = []
    
    private var tabUnderlineLeading: NSLayoutConstraint?
    private var tabButtons: [UIButton] = []
    
    private var contentBottomConstraint: NSLayoutConstraint?
    private var castCollectionHeight: NSLayoutConstraint?
    
    
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = false
        return scroll
    }()
    
    private lazy var contentView = UIView()
    
    private lazy var backdropImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.backgroundColor = .darkGray
        return imageView
    }()
    
    private lazy var posterThumbnailView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.layer.borderColor = UIColor.mainBackground.cgColor
        imageView.backgroundColor = .gray
        return imageView
    }()
    
    private lazy var ratingBadgeView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [ratingIcon , ratingLabel])
        stack.backgroundColor = .mainBackground
        stack.layer.cornerRadius = 12
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
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 2
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
        stack.axis = .horizontal
        stack.spacing = 10
        stack.alignment = .center
        return stack
    }()
    
    private lazy var tabStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.alignment = .fill
        return stack
    }()
    
    private lazy var tabUnderlineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.75)
        return view
    }()
    
    private lazy var tabSeparatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = UIColor.white.withAlphaComponent(0.75)
        label.numberOfLines = 0
        return label
    }()
    
    
    
    private lazy var castCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .clear
        collection.showsHorizontalScrollIndicator = false
        collection.isScrollEnabled = false
        collection.isHidden = true
        collection.dataSource = self
        collection.delegate = self
        collection
            .register(
                CastViewCell.self,
                forCellWithReuseIdentifier: CastViewCell.Identifier
            )
        return collection
    }()
    
    private lazy var castEmptyLabel: UILabel = {
        let label = UILabel()
        label.text = "Don't have any cast."
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor.white.withAlphaComponent(0.5)
        label.isHidden = true
        return label
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainBackground
        setupNavigationBar()
        setupTabs()
        setupHierarchy()
        setupLayout()
        fetchDetail()
        fetchCredits()
    }
    
    
    
    private func setupNavigationBar() {
        title = "Detail"
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        let bookmarkButton = UIBarButtonItem(
            image: UIImage(systemName: "bookmark"),
            style: .plain,
            target: self,
            action: #selector(bookmarkTapped)
        )
        navigationItem.rightBarButtonItem = bookmarkButton
    }
    
    private func setupTabs() {
        DetailTab.allCases.forEach { tab in
            let button = UIButton(type: .system)
            button.setTitle(tab.title, for: .normal)
            button.tag = tab.rawValue
            button.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
            button.addTarget(self, action: #selector(tabTapped(_:)), for: .touchUpInside)
            tabButtons.append(button)
            tabStackView.addArrangedSubview(button)
        }
        updateTabAppearance()
    }
    
    private func setupHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubviews(
            backdropImageView,
            posterThumbnailView,
            ratingBadgeView,
            titleLabel,
            infoStackView,
            tabStackView,
            tabSeparatorLine,
            descriptionLabel,
            castCollectionView,
            castEmptyLabel
        )
        tabSeparatorLine.addSubview(tabUnderlineView)
    }
    
    private func setupLayout() {
        scrollView
            .top(view.safeAreaLayoutGuide.topAnchor).0
            .leading(view.leadingAnchor).0
            .trailing(view.trailingAnchor).0
            .bottom(view.bottomAnchor)
        
        contentView
            .top(scrollView.topAnchor).0
            .leading(scrollView.leadingAnchor).0
            .trailing(scrollView.trailingAnchor).0
            .bottom(scrollView.bottomAnchor).0
            .width(scrollView.widthAnchor)
        
        backdropImageView
            .top(contentView.topAnchor, 16).0
            .leading(contentView.leadingAnchor).0
            .trailing(contentView.trailingAnchor).0
            .height(210)
        
        posterThumbnailView
            .leading(contentView.leadingAnchor, 20).0
            .centerY(backdropImageView.bottomAnchor).0
            .width(95).0
            .height(120)
        
        ratingBadgeView
            .bottom(backdropImageView.bottomAnchor, -12).0
            .trailing(backdropImageView.trailingAnchor, -12).0
            .height(24).0
            .width(54)
        
        ratingIcon
            .leading(ratingBadgeView.leadingAnchor, 10).0
            .centerY(ratingBadgeView.centerYAnchor).0
            .width(14).0
            .height(14)
        
        ratingLabel
            .leading(ratingIcon.trailingAnchor, 4).0
            .trailing(ratingBadgeView.trailingAnchor, -10).0
            .centerY(ratingBadgeView.centerYAnchor)
        
        titleLabel
            .top(backdropImageView.bottomAnchor, 16).0
            .leading(posterThumbnailView.trailingAnchor, 16).0
            .trailing(contentView.trailingAnchor, -16)
        
        infoStackView
            .top(posterThumbnailView.bottomAnchor, 16).0
            .leading(contentView.leadingAnchor, 16).0
            .height(20)
        
        tabStackView
            .top(infoStackView.bottomAnchor, 28).0
            .leading(contentView.leadingAnchor, 16).0
            .trailing(contentView.trailingAnchor, -16).0
            .height(30)
        
        tabSeparatorLine
            .top(tabStackView.bottomAnchor, 8).0
            .leading(contentView.leadingAnchor, 16).0
            .trailing(contentView.trailingAnchor, -16).0
            .height(2)
        
        
        tabUnderlineLeading = tabUnderlineView
            .top(tabSeparatorLine.topAnchor).0
            .height(2).0
            .leading(tabStackView.leadingAnchor).1
        
        tabUnderlineView
            .width( tabStackView.widthAnchor , multiplier: 1.0 / CGFloat(
                DetailTab.allCases.count))
        
        
        descriptionLabel
            .top(tabSeparatorLine.bottomAnchor, 20).0
            .leading(contentView.leadingAnchor, 16).0
            .trailing(contentView.trailingAnchor, -16)
        
        let castHeight = castCollectionView
            .top(tabSeparatorLine.bottomAnchor, 20).0
            .leading(contentView.leadingAnchor).0
            .trailing(contentView.trailingAnchor).0
            .height(0).1
        castCollectionHeight = castHeight
        
        
        
        castEmptyLabel
            .top(tabSeparatorLine.bottomAnchor, 20).0
            .leading(contentView.leadingAnchor, 16)
        
        
        let initialBottom = descriptionLabel
            .bottom(contentView.bottomAnchor, -32).1
        contentBottomConstraint = initialBottom
    }
    
    
    private func fetchDetail() {
        MovieAppService.shared.getMovieDetail(id: movieId) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let detail):
                DispatchQueue.main.async {
                    self.movieDetail = detail
                    self.applyDetail(detail)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
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
        label.text = "|"
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor.white.withAlphaComponent(0.3)
        return label
    }
    
    
    

    private func fetchCredits() {
        MovieAppService.shared.castMovies(id: movieId) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let dto):
                DispatchQueue.main.async {
                    self.castMembers = dto.cast ?? []
                    self.castEmptyLabel.isHidden = !self.castMembers.isEmpty
                    self.castCollectionView.reloadData()
                    self.updateCastCollectionHeight()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    
    private func updateCastCollectionHeight() {
        let columns: CGFloat = 3
        let itemHeight: CGFloat = 140
        let lineSpacing: CGFloat = 20
        let topBottomInset: CGFloat = 20

        let rows = ceil(CGFloat(castMembers.count) / columns)
        let height = rows > 0
            ? rows * itemHeight + max(rows - 1, 0) * lineSpacing + topBottomInset
            : 0

        castCollectionHeight?.constant = height
        view.layoutIfNeeded()
    }

    private func applyDetail(_ detail: MovieDetailDto) {
        titleLabel.text = detail.title
        ratingLabel.text = detail.ratingText ?? "-"
        yearItem.label.text = detail.releaseYear ?? "-"
        durationItem.label.text = detail.runtimeText ?? "-"
        genreItem.label.text = detail.primaryGenre ?? "-"
        descriptionLabel.text = detail.overview

        if let backdropUrl = detail.backdropUrl ?? detail.posterUrl {
            loadImage(from: backdropUrl.absoluteString, into: backdropImageView)
        }
        if let posterUrl = detail.posterUrl {
            loadImage(from: posterUrl.absoluteString, into: posterThumbnailView)
        }
    }

    private func loadImage(from urlString: String, into imageView: UIImageView) {
        NetworkManager.shared.loadData(urlString: urlString) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    imageView.image = UIImage(data: data)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }


    @objc private func bookmarkTapped() {
        let newState = !isBookmarked
        setBookmarkUI(isBookmarked: newState)

        let requestModel = AddToWatchListRequestDto(
            mediaType: "movie",
            mediaId: movieId,
            watchList: newState
        )
        AccountApiService.shared.addToWathchList(requestModel: requestModel) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    if model.success != true {
                        // Server rejected it — roll the icon back to what it was before the tap.
                        self.setBookmarkUI(isBookmarked: !newState)
                        print(model.localizedDescription)
                    }
                case .failure(let error):
                    self.setBookmarkUI(isBookmarked: !newState)
                    print(error.localizedDescription)
                }
            }
        }
    }

    private func setBookmarkUI(isBookmarked: Bool) {
        self.isBookmarked = isBookmarked
        let imageName = isBookmarked ? "bookmark.fill" : "bookmark"
        navigationItem.rightBarButtonItem?.image = UIImage(systemName: imageName)
    }
       
    @objc private func tabTapped(_ sender: UIButton) {
        guard let tab = DetailTab(rawValue: sender.tag) else { return }
        selectedTab = tab
        updateTabAppearance()
        updateDescriptionForSelectedTab()
        UIView.animate(withDuration: 0.25) {
            
        
        self.tabUnderlineLeading?.isActive = false
        let leading = self.tabUnderlineView
            .leadingAnchor.constraint(equalTo: sender.leadingAnchor)
        leading.isActive = true
        self.tabUnderlineLeading = leading
            self.tabUnderlineLeading?.constant = self.tabStackView.frame.width / 3 * CGFloat(sender.tag)
            self.view.layoutIfNeeded()
        }

      
        let topOffset = CGPoint(x: 0, y: -scrollView.adjustedContentInset.top)
        scrollView.setContentOffset(topOffset, animated: true)
    }

    private func updateTabAppearance() {
        tabButtons.forEach { button in
            let isSelected = button.tag == selectedTab.rawValue
            button.setTitleColor(isSelected ? .white : UIColor.white.withAlphaComponent(0.4), for: .normal)
        }
    }

    private func updateDescriptionForSelectedTab() {
        
        contentBottomConstraint?.isActive = false

        switch selectedTab {
        case .about:
            descriptionLabel.isHidden = false
            castCollectionView.isHidden = true
            castEmptyLabel.isHidden = true
            descriptionLabel.text = movieDetail?.overview
            contentBottomConstraint = descriptionLabel
            
                .bottom(contentView.bottomAnchor, -32).1

        case .reviews:
            descriptionLabel.isHidden = false
            castCollectionView.isHidden = true
            castEmptyLabel.isHidden = true
            descriptionLabel.text = "Reviews bu ekranda hələ mövcud deyil — TMDB-nin /movie/{id}/reviews endpoint-i əlavə edilməlidir."
            contentBottomConstraint = descriptionLabel
            
                .bottom(contentView.bottomAnchor,  -32).1

        case .cast:
            descriptionLabel.isHidden = true
            castCollectionView.isHidden = false
            castEmptyLabel.isHidden = !castMembers.isEmpty
            
            castCollectionView.reloadData()
            castCollectionView.collectionViewLayout.invalidateLayout()
            updateCastCollectionHeight()
            contentBottomConstraint = castCollectionView
            
                .bottom( contentView.bottomAnchor,  -32).1
        }
        view.layoutIfNeeded()

    }
}


extension DetailViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let columns: CGFloat = 3
        let interitemSpacing: CGFloat = 20
        let sectionInsetLeftRight: CGFloat = 40
        let availableWidth = collectionView.bounds.width - sectionInsetLeftRight - (columns - 1) * interitemSpacing
        let width = availableWidth / columns
        let height: CGFloat = 140
        return CGSizeMake(width,  height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(
            top: 10,
            left: 10,
            bottom: 10,
            right: 10
        )
    }
}
extension DetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        castMembers.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CastViewCell.Identifier,
            for: indexPath
        ) as? CastViewCell else { return UICollectionViewCell() }
        cell.configure(with: castMembers[indexPath.item])
        return cell
    }
}
