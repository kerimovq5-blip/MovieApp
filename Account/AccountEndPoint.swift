//
//  AccountEndPoint.swift
//  MovieApp
//
//  Created by Kerimov Qehreman on 01.07.26.
//
import Foundation

enum  AccountEndPoint: EndPoint {
    case addToWatchRequestList(encodable : Encodable)
    case getWatchlistMovies(page : Int)
    var basePath : String {
        return "/account/\(23258948)"
    }
    var path: String {
        switch self {
            case .addToWatchRequestList:
            return basePath+"/watchlist"
        case .getWatchlistMovies:
            return "\(basePath)/watchlist/movies"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .addToWatchRequestList:
            return .post
        case .getWatchlistMovies:
            return .get
        }
    }

    var queryItems: [URLQueryItem] {
        switch self {
        case . addToWatchRequestList:
            return []
        case .getWatchlistMovies(page: let page):
           return [URLQueryItem(name: "page", value: "\(page)")]
        }
    }

    var requestBody: RequestBody? {
       switch self {
       case .addToWatchRequestList( let encodable):
           return .encodable(encodable)
       case .getWatchlistMovies(page: _):
           return nil
       }
    }

}
