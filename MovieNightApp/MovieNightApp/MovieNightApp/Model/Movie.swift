//
//  Movie.swift
//  MovieNightApp
//
//  Created by Raymond Choy on 1/5/20.
//  Copyright © 2020 thechoygroup. All rights reserved.
//

import Foundation
import UIKit

enum MovieArtworkState {
    case placeholder
    case downloaded
    case failed
}

class Movie: Decodable {
    let title: String
    let overview: String
    let releaseDate: String
    let id: Int
    let adult: Bool
    let popularity: Double
    let voteCount: Int
    let posterPath: String
    
    var artwork: UIImage? = nil
    var artworkState = MovieArtworkState.placeholder
    var dateFormatted = false
    var formattedReleaseDate: String? = ""
    
    enum CodingKeys: String, CodingKey {
        case title
        case overview
        case releaseDate
        case id
        case adult
        case popularity
        case voteCount
        case posterPath
    }
    
    
    func configureDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if !dateFormatted {
            
            guard let date = dateFormatter.date(from: releaseDate) else {
                fatalError("date was not compatable from API")
            }
            
            dateFormatter.dateStyle = .long
            formattedReleaseDate = dateFormatter.string(from: date)
            
            dateFormatted = true
        }
    }
}
