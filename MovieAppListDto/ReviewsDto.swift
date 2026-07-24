//
//  ReviewsDto.swift
//  MovieApp
//
//  Created by Kerimov Qehreman on 25.07.26.
//

import Foundation

// MARK: - ReviewsDto
struct ReviewsDto: Decodable {
    let id: Int?
    let page: Int?
    let results: [ReviewCellDto]?
    let totalPages: Int?
    let totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case page = "page"
        case results = "results"
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Result
struct ReviewCellDto: Decodable {
    let author: String?
    let authorDetails: AuthorDetails?
    let content: String?
    let createdAt: String?
    let id: String?
    let updatedAt: String?
    let url: String?

    enum CodingKeys: String, CodingKey {
        case author = "author"
        case authorDetails = "author_details"
        case content = "content"
        case createdAt = "created_at"
        case id = "id"
        case updatedAt = "updated_at"
        case url = "url"
    }

    var reviewText: String? { content }

    var ratingText: String? {
        guard let rating = authorDetails?.rating else { return nil }
        return "\(rating)/10"
    }

    var avatarUrl: URL? { authorDetails?.avatarUrl }
}

// MARK: - AuthorDetails
struct AuthorDetails: Decodable {
    let name: String?
    let username: String?
    let avatarPath: String?
    let rating: Int?

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case username = "username"
        case avatarPath = "avatar_path"
        case rating = "rating"
    }

    var avatarUrl: URL? {
        guard let avatarPath, !avatarPath.isEmpty else { return nil }

        if avatarPath.hasPrefix("/http") {
            return URL(string: String(avatarPath.dropFirst()))
        }

        let cleanPath = avatarPath.hasPrefix("/") ? String(avatarPath.dropFirst()) : avatarPath
        return URL(string: "https://image.tmdb.org/t/p/w200/\(cleanPath)")
    }
}
