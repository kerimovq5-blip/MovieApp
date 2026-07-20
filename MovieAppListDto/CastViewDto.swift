//
//  CastViewDto.swift
//  MovieApp
//
//  Created by Kerimov Qehreman on 16.07.26.
//

import Foundation

// MARK: - Cast
struct CastProfilDto: Decodable {
    let id: Int?
    let cast: [CastDto]?
    let crew: [CastDto]?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case cast = "cast"
        case crew = "crew"
    }
}

// MARK: - CastDto
struct CastDto: Decodable {
    let adult: Bool?
    let gender: Int?
    let id: Int?
    let knownForDepartment: String?
    let name: String?
    let originalName: String?
    let popularity: Double?
    let profilePath: String?
    let castId: Int?
    let character: String?
    let creditId: String?
    let order: Int?
    let department: String?
    let job: String?

    enum CodingKeys: String, CodingKey {
        case adult = "adult"
        case gender = "gender"
        case id = "id"
        case knownForDepartment = "known_for_department"
        case name = "name"
        case originalName = "original_name"
        case popularity = "popularity"
        case profilePath = "profile_path"
        case castId = "cast_id"
        case character = "character"
        case creditId = "credit_id"
        case order = "order"
        case department = "department"
        case job = "job"
    }
    var profileUrl: URL? {
        guard let profilePath else { return nil }
        let cleanPath = profilePath.hasPrefix("/") ? String(profilePath.dropFirst()) : profilePath
        return URL(string: "https://image.tmdb.org/t/p/w200/\(cleanPath)")
    }
}
