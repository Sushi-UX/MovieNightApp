//
//  GenreResponse.swift
//  MovieNightApp
//
//  Created by Raymond Choy on 1/5/20.
//  Copyright © 2020 thechoygroup. All rights reserved.
//

import Foundation

struct GenreResponse: Decodable {
    let genres: [Genre]
}
