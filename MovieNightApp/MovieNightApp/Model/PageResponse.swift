//
//  PageResponse.swift
//  MovieNightApp
//
//  Created by Raymond Choy on 1/5/20.
//  Copyright © 2020 thechoygroup. All rights reserved.
//

import Foundation

struct PagedResponse<T: Decodable>: Decodable {
    let page: Int
    let totalResults: Int
    let totalPages: Int
    let results: [T]
}
