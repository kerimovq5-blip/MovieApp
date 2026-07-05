//
//  UpComingDto.swift
//  MovieApp
//
//  Created by Kerimov Qehreman on 04.07.26.
//


import Foundation

// MARK: - UpComingDto
struct UpComingDto: Decodable {
    let dates: Dates?
    let page: Int?
    let results: [UpComingMovieDto]?
    let totalPages: Int?
    let totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case dates = "dates"
        case page = "page"
        case results = "results"
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Dates
struct Dates: Decodable {
    let maximum: String?
    let minimum: String?

    enum CodingKeys: String, CodingKey {
        case maximum = "maximum"
        case minimum = "minimum"
    }
}

// MARK: - Result
struct UpComingMovieDto : Decodable {
    let adult: Bool?
    let backdropPath: String?
    let genreIds: [Int]?
    let id: Int?
    let originalLanguage: String?
    let originalTitle: String?
    let overview: String?
    let popularity: Double?
    let posterPath: String?
    let releaseDate: String?
    let title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?

    enum CodingKeys: String, CodingKey {
        case adult = "adult"
        case backdropPath = "backdrop_path"
        case genreIds = "genre_ids"
        case id = "id"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview = "overview"
        case popularity = "popularity"
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title = "title"
        case video = "video"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
    var posterUrl: URL? {
        guard let posterPath = self.posterPath else { return nil }
        
        let cleanPath = posterPath.hasPrefix("/") ? String(posterPath.dropFirst()) : posterPath
        return URL(string: "https://image.tmdb.org/t/p/w500/\(cleanPath)")
    }
}
