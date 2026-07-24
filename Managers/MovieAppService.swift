//
//  MovieAppService.swift
//  MovieApp
//
//  Created by Kerimov Qehreman on 28.06.26.
//

import Foundation

final class MovieAppService {
    
    static let shared = MovieAppService()
    func getNowPlayingMovies(
        page : Int ,
        completion: @escaping (Result<NowplayingDto, Error>)-> Void
    ){
        NetworkManager.shared.request(
            endPoint:MovieEndPoint
                .getNowPlayingMovies(page: page),
            completion: completion)
        
            
        }
    func getPopularMovies(
        page : Int ,
        completion: @escaping (Result<GetPopularDto, Error>)-> Void
    ){
        NetworkManager.shared.request(
            endPoint:MovieEndPoint
                .getPopularMovies(page: page),
            completion: completion)
    }
    func getTopRatedMovies(
        page : Int ,
        completion: @escaping (Result<TopRatedDto, Error>)-> Void
    ){
        NetworkManager.shared.request(
            endPoint:MovieEndPoint
                .getTopRatedMovies(page: page),
            completion: completion)
    }
    func getUpcomingMovies(
        page : Int ,
        completion: @escaping (Result<UpComingDto, Error>)-> Void
    ){
        NetworkManager.shared.request(
            endPoint:MovieEndPoint
                .getUpcomingMovies(page: page),
            completion: completion)
    }
    
    func trendingMovies(
        page : Int ,
        completion: @escaping (Result<TrendingDto, Error>)-> Void
    ){
        NetworkManager.shared.request(
            endPoint:MovieEndPoint
                .trendingMovies(page: page),
            completion: completion)
    }
    
    func getMovieDetail(
           id: Int,
           completion: @escaping (Result<MovieDetailDto, Error>) -> Void
       ) {
           NetworkManager.shared.request(
               endPoint: MovieEndPoint
                   .movieDetail(id: id),
               completion: completion)
       }
    func searchMovies(
          query: String,
          page: Int = 1,
          completion: @escaping (Result<SearchMovieDto, Error>) -> Void
      ) {
          NetworkManager.shared.request(
              endPoint: MovieEndPoint
                  .searchMovies(query: query, page: page),
              completion: completion)
      }
    
    func castMovies(
        id: Int,
        completion: @escaping (Result<CastProfilDto, Error>) -> Void
    ) {
        NetworkManager.shared.request(
            endPoint: MovieEndPoint
                .castMovies(id: id),
            completion: completion)
    }
    
    func accountStates(
        id: Int,
        completion: @escaping (Result<AccountStateDto, Error>) -> Void
    ) {
        NetworkManager.shared.request(
            endPoint: MovieEndPoint
                .accountStates(id: id),
            completion: completion)
    }
    
    func reviewsMovies(
        id: Int,
        completion: @escaping (Result<ReviewsDto, Error>) -> Void
    ) {
        NetworkManager.shared.request(
            endPoint: MovieEndPoint
                .reviewsMovies(id: id),
            completion: completion)
    }
}
