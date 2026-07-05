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
    
    
    var path: String {
        var path = "/movie"
        switch self {
            case .getNowPlayingMovies :
            path += "/now_playing"
            return path
        case .getPopularMovies:
            path += "/popular"
            return path
        case .getTopRatedMovies:
           path += "/top_rated"
            return path
        case .getUpcomingMovies:
           path += "/upcoming"
            return path
        case .trendingMovies:
            path += "/trending/all/week"
            return path
        }
        
       
    }
    var method: HTTPMethod {
        switch self {
        case .getNowPlayingMovies,
                .getPopularMovies,
                .getTopRatedMovies,
                .getUpcomingMovies,
                .trendingMovies:
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
       
        }
       
    }

    var requestBody: RequestBody? {
        switch self {
        case .getNowPlayingMovies,
        .getPopularMovies,
        .getTopRatedMovies,
        .getUpcomingMovies,
        .trendingMovies:
            return nil
        
        }
        
    }
}
