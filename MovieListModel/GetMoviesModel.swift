//
//  GetMoviesModel.swift
//  MovieApp
//
//  Created by Kerimov Qehreman on 20.07.26.
//
import UIKit
import Foundation

final class GetMoviesModel: MovieListViewModel {
    var callBack: ((MovieListViewState) -> Void)?

    private(set) var movies: [MovieDto] = []

    func getMovies() {
        callBack?(.loading)
        MovieAppService.shared.getNowPlayingMovies(page: 1) { [weak self] result in
            guard let self else { return }
            self.callBack?(.loaded)
            switch result {
            case .success(let dto):
                self.movies = dto.results ?? []
                self.callBack?(.reloadData)
            case .failure(let error):
                self.callBack?(.message(error.localizedDescription))
            }
        }
    }

    func didSelectMovie(at index: Int) {
        guard movies.indices.contains(index), let id = movies[index].id else { return }
        addWatchList(id: id)
    }

    private func addWatchList(id: Int) {
        AccountApiService.shared.addToWathchList(
            requestModel: .init(
                mediaType: "movie",
                mediaId: id,
                watchList: true
            )
        ) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let model):
                if model.success == true, let message = model.statusmessage, !message.isEmpty {
                    self.callBack?(.message(message))
                }
            case .failure(let error):
                self.callBack?(.message(error.localizedDescription))
            }
        }
    }
}
