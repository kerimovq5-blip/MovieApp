//
//  SearchViewController.swift
//  MovieApp
//
//  Created by Kerimov Qehreman on 27.06.26.
//

import UIKit

final class WatchListController: UIViewController {
    var viewModels: [(posterUrl: String, title: String, rating: Double, id: Int)] = [] {
        didSet {
            collectionView.reloadData()
        }
    }

    private var searchWorkItem: DispatchWorkItem?

   
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(
            AddToListViewCell.self,
            forCellWithReuseIdentifier: AddToListViewCell.identifier
        )
        return collectionView
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setUp()
        setConstraints()
        fetchWatchlist()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchWatchlist()
    }

    private func setupNavigationBar() {
        title = "WathcList"
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
    }

    private func setUp() {
        view.backgroundColor = .mainBackground
        view.addSubviews(collectionView)
    }

    private func setConstraints() {
        

        collectionView
            .top(view.safeAreaLayoutGuide.topAnchor, 16).0
            .leading(view.leadingAnchor).0
            .trailing(view.trailingAnchor).0
            .bottom(view.bottomAnchor)
    }


    private func fetchWatchlist() {
        AccountApiService.shared.getWatchList(page: 1) { [weak self] (result: Result<SearchMovieDto, Error>) in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let dto):
                    self.viewModels = dto.results?.compactMap {
                        movie -> (posterUrl: String, title: String, rating: Double, id: Int)? in
                        guard let id = movie.id else { return nil }
                        return (movie.posterUrl?.absoluteString ?? "", movie.title ?? "", movie.voteAverage ?? 0, id)
                    } ?? []
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}

extension WatchListController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width: CGFloat = collectionView.bounds.width - 40
        let height: CGFloat = 160
        
        return CGSize(width: width, height: height)
    }
}

extension WatchListController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModels.count
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
       10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: AddToListViewCell.identifier,
            for: indexPath
        ) as? AddToListViewCell else { return UICollectionViewCell() }
        let movie = viewModels[indexPath.row]
        cell.configure(
            movieId: movie.id,
            posterURL: movie.posterUrl,
            title: movie.title,
            rating: movie.rating)
        return cell
    }
}

extension WatchListController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let vc = DetailViewController(movieId: viewModels[indexPath.row].id)
        navigationController?.pushViewController(vc, animated: true)
    }
}
