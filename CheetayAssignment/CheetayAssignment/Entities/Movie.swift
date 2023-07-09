//
//  Movies.swift
//  CheetayAssignment
//
//  Created by usama farooq on 07/07/2023.
//

import Foundation
import UIKit



struct MoviesResponse: Codable {
    let page: Int
    let movies: [MovieModel]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page
        case movies = "results"
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct MovieModel: MovieProtocol {
    var backdropPath: String?
    var posterPath: String?
    var id: Int
    var title: String
    var releaseDate: String
    var overView: String
    var isLiked: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case posterPath = "poster_path"
        case id
        case releaseDate = "release_date"
        case title
        case overView = "overview"
    }
    
}
