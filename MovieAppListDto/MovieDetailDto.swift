//
//  MovieDetailDto.swift
//  MovieApp
//
//  Created by Kerimov Qehreman on 12.07.26.
//



import Foundation

// MARK: - MovieDetailDto
struct MovieDetailDto: Decodable {
    let id: Int?
    let title: String?
    let overview: String?
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: String?
    let runtime: Int?
    let voteAverage: Double?
    let genres: [DetailDto]?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case overview = "overview"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case releaseDate = "release_date"
        case runtime = "runtime"
        case voteAverage = "vote_average"
        case genres = "genres"
    }

    var posterUrl: URL? {
        guard let posterPath else { return nil }
        let cleanPath = posterPath.hasPrefix("/") ? String(posterPath.dropFirst()) : posterPath
        return URL(string: "https://image.tmdb.org/t/p/w500/\(cleanPath)")
    }

    var backdropUrl: URL? {
        guard let backdropPath else { return nil }
        let cleanPath = backdropPath.hasPrefix("/") ? String(backdropPath.dropFirst()) : backdropPath
        return URL(string: "https://image.tmdb.org/t/p/w780/\(cleanPath)")
    }

    var releaseYear: String? {
        guard let releaseDate, releaseDate.count >= 4 else { return nil }
        return String(releaseDate.prefix(4))
    }

    var runtimeText: String? {
        guard let runtime else { return nil }
        return "\(runtime) Minutes"
    }

    var ratingText: String? {
        guard let voteAverage else { return nil }
        return String(format: "%.1f", voteAverage)
    }

    var primaryGenre: String? {
        genres?.first?.name
    }
}

// MARK: - GenreDto
struct DetailDto: Decodable {
    let id: Int?
    let name: String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
    }
}
