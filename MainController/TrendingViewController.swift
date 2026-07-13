//
//  TrendingViewController.swift
//  MovieApp
//
//  Created by Kerimov Qehreman on 06.07.26.
//
import UIKit
final class TrendingView: UIView {

    var movies: [(posterUrl: String, title: String, id: Int)] = [] {
        didSet { collectionView.reloadData() }
    }

    var onSelectMovie: ((Int) -> Void)?

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Trending"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .white
        return label
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal

        let controller = UICollectionView(frame: .zero, collectionViewLayout: layout)
        controller.backgroundColor = .clear
        controller.showsHorizontalScrollIndicator = false
        controller.dataSource = self
        controller.delegate = self
        controller.register(
            TrendingCell.self,
            forCellWithReuseIdentifier: "cell")
        return controller
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        addSubviews(titleLabel, collectionView)
    }

    private func setupConstraints() {
        titleLabel
            .top(topAnchor).0
            .leading(leadingAnchor, 16).0
            .trailing(trailingAnchor).0
            .height(24)

        collectionView
            .top(titleLabel.bottomAnchor, 12).0
            .leading(leadingAnchor).0
            .trailing(trailingAnchor).0
            .bottom(bottomAnchor)
    }
}

extension TrendingView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        movies.count
    }
   

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "cell",
            for: indexPath
        ) as? TrendingCell else { return UICollectionViewCell() }
        let movie = movies[indexPath.item]
        cell.configure(posterUrl: movie.posterUrl, title: movie.title)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        onSelectMovie?(movies[indexPath.item].id)
    }
}
extension TrendingView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth: CGFloat = 140
        
        return CGSize(width: itemWidth, height: itemWidth * 1.5)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) ->CGFloat {
        20
    }
func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        20
    }
}
