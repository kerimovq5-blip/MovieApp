//
//  AccountEndPoint.swift
//  MovieApp
//
//  Created by Kerimov Qehreman on 01.07.26.
//
import Foundation

enum  AccountEndPoint: EndPoint {
    case addToWatchRequestList(encodable : Encodable)
    var basePath : String {
        return "/account/\(23258948)"
    }
    var path: String {
        switch self {
            case .addToWatchRequestList:
            return basePath+"/watchlist"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .addToWatchRequestList:
            return .post
        }
    }

    var queryItems: [URLQueryItem] {
        switch self {
        case . addToWatchRequestList:
            return []
        }
    }

    var requestBody: RequestBody? {
       switch self {
       case .addToWatchRequestList( let encodable):
           return .encodable(encodable)
        }
    }

}
