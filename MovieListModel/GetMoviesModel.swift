//
//  GetMoviesModel.swift
//  MovieApp
//
//  Created by Kerimov Qehreman on 20.07.26.
//
import UIKit
import Foundation
final class GetMoviesModel : MovieListViewModel {
    var callBack: ((MovieListViewState) -> Void)?
    
    let movies: [MovieDto] = []
    
    func getMovies() {
    }
    
    func didSelectMovie(at index: Int) {
        <#code#>
    }
    
}
