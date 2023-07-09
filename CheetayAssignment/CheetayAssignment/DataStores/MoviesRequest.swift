//
//  MoviesRequest.swift
//  CheetayAssignment
//
//  Created by usama farooq on 07/07/2023.
//

import Foundation

struct MoviesRequest: Request {
    
    let page: Int
    var urlRequest: URLRequest {
        URLRequest(url: URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=e5ea3092880f4f3c25fbc537e9b37dc1&page=\(page)")!)
    }
}
