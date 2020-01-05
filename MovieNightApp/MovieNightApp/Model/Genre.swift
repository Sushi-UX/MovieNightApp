//
//  Genre.swift
//  MovieNightApp
//
//  Created by Raymond Choy on 1/5/20.
//  Copyright © 2020 thechoygroup. All rights reserved.
//

import Foundation

class Genre: Decodable {
    let id: Int
    let name: String
    
    init() {
        id = 0
        name = ""
    }
}

// Adding conformance to equatable

extension Genre: Equatable {
    static func == (lhs: Genre, rhs: Genre) -> Bool {
        if lhs.name == rhs.name && lhs.id == rhs.id {
            return true
        } else {
            return false
        }
    }
}
