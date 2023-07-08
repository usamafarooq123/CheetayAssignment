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
    let movies: [Movie]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page
        case movies = "results"
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct Movie: Codable {
    let backdropPath: String?
    let posterPath: String?
    let id: Int
    let title: String
    let releaseDate: String
    let overView: String
    
    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case posterPath = "poster_path"
        case id
        case releaseDate = "release_date"
        case title
        case overView = "overview"
    }
    
}
