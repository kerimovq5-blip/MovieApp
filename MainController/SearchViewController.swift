//
//  SearchViewController.swift
//  MovieApp
//
//  Created by Kerimov Qehreman on 27.06.26.
//

import UIKit

final class SearchViewController: UIViewController {
    var viewModels: [(posterUrl: String, title: String, rating: Double, id: Int)] = [] {
        didSet {
            collectionView.reloadData()
        }
    }

    private var searchWorkItem: DispatchWorkItem?

    private lazy var searchTextField: UITextField = {
        let textfield = UITextField()
        textfield.layer.cornerRadius = 12
        textfield.layer.masksToBounds = true
        textfield.backgroundColor = .searchBackground
        textfield.textColor = .black
        textfield.tintColor = .searchcolor
        textfield.attributedPlaceholder = NSAttributedString(
            string: "Search",
            attributes: [.foregroundColor: AssetColors.searchcolor.color]
        )

        let leftPadding = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 1))
        textfield.leftView = leftPadding
        textfield.leftViewMode = .always

        let iconView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        iconView.tintColor = .searchcolor
        iconView.contentMode = .scaleAspectFit
        iconView.frame = CGRect(x: 8, y: 10, width: 20, height: 20)

        let rightContainer = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        rightContainer.addSubview(iconView)
        textfield.rightView = rightContainer
        textfield.rightViewMode = .always
        textfield.addAction(UIAction(handler: { [weak self] _ in
            self?.searchDidChange()
        }), for: .editingChanged)
        return textfield
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(
            SearchViewCell.self,
            forCellWithReuseIdentifier: "cell"
        )
        return collectionView
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setUp()
        setConstraints()
        
    }

    private  func setupNavigationBar() {
        title = "Search"
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
    }

    private func setUp() {
        view.backgroundColor = .mainBackground
        view.addSubviews(searchTextField, collectionView)
    }

    private func setConstraints() {
        searchTextField
            .top(view.safeAreaLayoutGuide.topAnchor, 20).0
            .leading(view.leadingAnchor, 20).0
            .trailing(view.trailingAnchor, -20).0
            .height(50)

        collectionView
            .top(searchTextField.bottomAnchor, 16).0
            .leading(view.leadingAnchor).0
            .trailing(view.trailingAnchor).0
            .bottom(view.bottomAnchor)
    }


    private func searchDidChange() {
        searchWorkItem?.cancel()

        let text = searchTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        guard !text.isEmpty else {
            viewModels = []
            return
        }

        let workItem = DispatchWorkItem { [weak self] in
            self?.performSearch(query: text)
        }
        searchWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: workItem)
    }

    private func performSearch(query: String) {
        MovieAppService.shared.searchMovies(query: query) {
            [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let dto):
                self.viewModels = dto.results?.compactMap {
                    movie -> (posterUrl: String, title: String, rating: Double, id: Int)? in
                    guard let url = movie.posterUrl?.absoluteString, let id = movie.id else { return nil }
                    return (url, movie.title ?? "", movie.voteAverage ?? 0, id)
                } ?? []
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
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

extension SearchViewController: UICollectionViewDataSource {
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
            withReuseIdentifier: "cell",
            for: indexPath
        ) as? SearchViewCell else { return UICollectionViewCell() }
        let movie = viewModels[indexPath.row]
        cell.configure(
            movieId: movie.id,
            posterURL: movie.posterUrl,
            title: movie.title,
            rating: movie.rating)
        return cell
    }
}

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let vc = DetailViewController(movieId: viewModels[indexPath.row].id)
        navigationController?.pushViewController(vc, animated: true)
    }
}
