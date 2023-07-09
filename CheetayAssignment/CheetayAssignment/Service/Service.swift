//
//  Service.swift
//  CheetayAssignment
//
//  Created by usama farooq on 07/07/2023.
//

import Foundation

protocol Request {
    var urlRequest: URLRequest { get }
}

/// An abstract service type that can have multiple implementation for example - a NetworkService that gets a resource from the Network or a DiskService that gets a resource from Disk
protocol Service {
    func get(request: Request, completion: @escaping (Result<Data, Error>) -> Void)
}

/// A concrete implementation of Service class responsible for getting a Network resource
final class NetworkService: Service {
    func get(request: Request, completion: @escaping (Result<Data, Error>) -> Void) {
        var request = request.urlRequest
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(ServiceError.noData))
                return
            }
            completion(.success(data))
        }.resume()
    }
}
