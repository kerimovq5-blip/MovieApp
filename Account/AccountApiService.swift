//
//  AccountApiService.swift
//  MovieApp
//
//  Created by Kerimov Qehreman on 01.07.26.
//

final class AccountApiService {
    static let shared = AccountApiService()
    
    func addToWathchList(
        requestModel: AddToWatchListRequestDto,
        completion: @escaping (Result<ErrorModel, Error>) -> Void
    ) {
        NetworkManager.shared.request(endPoint: AccountEndPoint.addToWatchRequestList(
            encodable: requestModel),
            completion: completion)
            
        
    }
}
