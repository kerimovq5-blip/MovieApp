//
//  TrendingDto.swift
//  MovieApp
//
//  Created by Kerimov Qehreman on 05.07.26.
//

import Foundation

// MARK: - TrendingDto
struct TrendingDto: Decodable {
    let page: Int?
    let results: [TrendingMovieDto]?
    let totalPages: Int?
    let totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case page = "page"
        case results = "results"
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Result
struct TrendingMovieDto: Decodable {
    let adult: Bool?
    let backdropPath: String?
    let id: Int?
    let title: String?
    let originalLanguage: String?
    let originalTitle: String?
    let overview: String?
    let posterPath: String?
    let mediaType: String?
    let genreIds: [Int]?
    let popularity: Double?
    let releaseDate: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?
    let name: String?
    let originalName: String?
    let firstAirDate: String?
    let originCountry: [String]?

    enum CodingKeys: String, CodingKey {
        case adult = "adult"
        case backdropPath = "backdrop_path"
        case id = "id"
        case title = "title"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview = "overview"
        case posterPath = "poster_path"
        case mediaType = "media_type"
        case genreIds = "genre_ids"
        case popularity = "popularity"
        case releaseDate = "release_date"
        case video = "video"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case name = "name"
        case originalName = "original_name"
        case firstAirDate = "first_air_date"
        case originCountry = "origin_country"
    }
    var posterUrl: URL? {
        guard let posterPath = self.posterPath else { return nil }
        
        let cleanPath = posterPath.hasPrefix("/") ? String(posterPath.dropFirst()) : posterPath
        return URL(string: "https://image.tmdb.org/t/p/w500/\(cleanPath)")
    }
}
