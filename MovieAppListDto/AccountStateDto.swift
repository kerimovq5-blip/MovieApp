//
//  AccountStateDto.swift
//  MovieApp
//
//  Created by Kerimov Qehreman on 24.07.26.
//

import Foundation

// MARK: - AccountStateDto
struct AccountStateDto: Decodable {
    let id: Int?
    let favorite: Bool?
    let rated: Rating?
    let watchlist: Bool?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case favorite = "favorite"
        case rated = "rated"
        case watchlist = "watchlist"
    }
    
    init(from decoder : any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        self.favorite = try container
            .decodeIfPresent(Bool.self, forKey: .favorite)
        if let value = try? container.decodeIfPresent(Rated.self, forKey: .rated)?.value {
            self.rated = .rated(value: value)
            
        } else {
            rated = .unrated
        }
        self.watchlist = try container.decodeIfPresent(Bool.self, forKey: .watchlist)
    }
}
enum Rating : Decodable {
    case rated (value : Int)
    case unrated
}
// MARK: - Rated
struct Rated: Decodable {
    let value: Int?

    enum CodingKeys: String, CodingKey {
        case value = "value"
    }
}
