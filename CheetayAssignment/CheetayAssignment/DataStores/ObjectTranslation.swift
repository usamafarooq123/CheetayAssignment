//
//  ObjectTranslation.swift
//  CheetayAssignment
//
//  Created by usama farooq on 07/07/2023.
//

import Foundation
protocol ObjectTranslator {
    func decodeObject<T: Decodable>(data: Data) throws -> T
    func decodeObjects<T: Decodable>(data: Data) throws -> [T]
}

extension ObjectTranslator {
    func decodeObject<T: Decodable>(data: Data) throws -> T {
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    func decodeObjects<T: Decodable>(data: Data) throws -> [T] {
        return try JSONDecoder().decode([T].self, from: data)
    }
}

struct ObjectTranslation: ObjectTranslator { }
