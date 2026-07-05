//
//  AddToWatchListDto.swift
//  MovieApp
//
//  Created by Kerimov Qehreman on 01.07.26.
//

struct AddToWatchListRequestDto : Codable {
    let mediaType : String
    let mediaId : Int
    let watchList : Bool
    
    enum CodingKeys: String, CodingKey {
        case mediaType = "media_type"
        case mediaId = "media_id"
        case watchList = "watchlist"
    }
}
