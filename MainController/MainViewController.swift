import UIKit

final class ViewController: UIViewController {


    private var currentMovies: [String] = []

    private enum Segment: Int {
        case nowPlaying
        case topRated
        case upcoming
        case popular
    }


    private lazy var watchLabel: UILabel = {
        let label = UILabel()
        label.text = "What do you want to watch?"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        return label
    }()

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

        return textfield
    }()

    private lazy var segmentControl: UISegmentedControl = {
        let control = UISegmentedControl(items: [
            "Now Playing", "Top Rated", "Upcoming", "Popular"
        ])
        control.selectedSegmentIndex = 0
        control.setTitleTextAttributes(
            [.foregroundColor: UIColor.gray],
            for: .normal
        )
        control.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        return control
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical

        let controllerView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        controllerView.register(
            ImageViewCollectionCell.self,
            forCellWithReuseIdentifier: "cell"
        )
        controllerView.backgroundColor = .clear
        controllerView.delegate = self
        controllerView.dataSource = self
        return controllerView
    }()

    private lazy var trendingView = TrendingView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainBackground
        setupHierarchy()
        setupLayout()
        fetchMovies(for: .nowPlaying)
    }

    

    private func setupHierarchy() {
        view.addSubviews(
            watchLabel,
            searchTextField,
            segmentControl,
            collectionView ,
            trendingView
        )
    }

    private func setupLayout() {
        watchLabel
            .top(view.safeAreaLayoutGuide.topAnchor).0
            .leading(view.safeAreaLayoutGuide.leadingAnchor, 20).0
            .trailing(view.safeAreaLayoutGuide.trailingAnchor).0
            .height(20)
        
            
        searchTextField
            .top(watchLabel.bottomAnchor, 20).0
            .leading(view.safeAreaLayoutGuide.leadingAnchor, 20).0
            .trailing(view.safeAreaLayoutGuide.trailingAnchor, -20).0
            .height(45)
        trendingView
            .top(searchTextField .bottomAnchor , 20).0
            .leading(view.safeAreaLayoutGuide.leadingAnchor, 20).0
            .trailing(view.safeAreaLayoutGuide.trailingAnchor, -20).0
            .height(240)
         
        segmentControl
            .top(trendingView.bottomAnchor, 20).0
            .leading(view.safeAreaLayoutGuide.leadingAnchor, 20).0
            .trailing(view.safeAreaLayoutGuide.trailingAnchor, -20).0
            .height(40)

        collectionView
            .top(segmentControl.bottomAnchor, 20).0
            .leading(view.leadingAnchor, 16).0
            .trailing(view.trailingAnchor, -16).0
            .bottom(view.safeAreaLayoutGuide.bottomAnchor)
    }


    private func fetchMovies(for segment: Segment) {
        switch segment {
        case .nowPlaying:
            MovieAppService.shared.getNowPlayingMovies(page: 1) {
                [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let dto):
                    self.currentMovies = dto.results?.compactMap { $0.posterUrl?.absoluteString } ?? []
                    self.collectionView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            MovieAppService.shared.trendingMovies(page: 1) { [weak self] result in
                    guard let self else { return }
                    switch result {
                    case .success(let dto):
                        let movies = dto.results?.compactMap { movie -> (String, String)? in
                            guard let url = movie.posterUrl?.absoluteString else { return nil }
                            return (url, movie.title ?? "")
                        } ?? []
                        DispatchQueue.main.async {
                            self.trendingView.movies = movies
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }

        case .topRated:
            MovieAppService.shared.getTopRatedMovies(page: 1) {
                [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let dto):
                    self.currentMovies = dto.results?.compactMap { $0.posterUrl?.absoluteString } ?? []
                    self.collectionView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }

        case .upcoming:
            MovieAppService.shared.getUpcomingMovies(page: 1) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let dto):
                    self.currentMovies = dto.results?.compactMap { $0.posterUrl?.absoluteString } ?? []
                    self.collectionView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }

        case .popular:
            MovieAppService.shared.getPopularMovies(page: 1) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let dto):
                    self.currentMovies = dto.results?.compactMap { $0.posterUrl?.absoluteString } ?? []
                    self.collectionView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }

    @objc private func segmentChanged(_ sender: UISegmentedControl) {
        guard let segment = Segment(rawValue: sender.selectedSegmentIndex) else { return }
        currentMovies = []
        collectionView.reloadData()
        fetchMovies(for: segment)
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        currentMovies.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "cell",
            for: indexPath
        ) as? ImageViewCollectionCell else {
            return UICollectionViewCell()
        }
        cell.configure(data: currentMovies[indexPath.item])
        return cell
    }
}


extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = (collectionView.bounds.width - 24) / 3
        return CGSize(width: itemWidth, height: itemWidth * 1.46)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat { 12 }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat { 16 }
}
