//
//  MovieEndPoint.swift
//  MovieApp
//
//  Created by Kerimov Qehreman on 28.06.26.
//

import Foundation

enum MovieEndPoint : EndPoint {
    case getNowPlayingMovies(page : Int)
    case getPopularMovies(page : Int)
    case getTopRatedMovies(page : Int)
    case getUpcomingMovies(page : Int)
    case trendingMovies(page : Int)
    case movieDetail(id : Int)
    
    
    var path: String {
        switch self {
            case .getNowPlayingMovies :
            return "/movie/now_playing"
        case .getPopularMovies:
            return "/movie/popular"
        case .getTopRatedMovies:
            return "/movie/top_rated"
        case .getUpcomingMovies:
            return "/movie/upcoming"
        case .trendingMovies:
            return "/trending/all/week"
        case .movieDetail(let id):
            return "/movie/\(id)"
        }
    }
    var method: HTTPMethod {
        switch self {
        case .getNowPlayingMovies,
                .getPopularMovies,
                .getTopRatedMovies,
                .getUpcomingMovies,
                .trendingMovies,
                .movieDetail:
            return .get
        }
       
    }
    var queryItems: [URLQueryItem] {
        switch self {
        case .getNowPlayingMovies(let page),
                .getPopularMovies( let page),
                .getTopRatedMovies(let page),
                .getUpcomingMovies(let page),
                .trendingMovies(let page):
            return [.init(name: "page", value: "\(page)")]
        case .movieDetail:
            return []
       
        }
       
    }

    var requestBody: RequestBody? {
        switch self {
        case .getNowPlayingMovies,
        .getPopularMovies,
        .getTopRatedMovies,
        .getUpcomingMovies,
        .trendingMovies,
        .movieDetail:
            return nil
        
        }
        
    }
}
