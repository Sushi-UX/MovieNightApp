//
//  Endpoint.swift
//  MovieNightApp
//
//  Created by Raymond Choy on 1/5/20.
//  Copyright © 2020 thechoygroup. All rights reserved.
//

import Foundation

protocol Endpoint {
    var base: String { get }
    var path: String { get }
    var queryItems: [URLQueryItem] { get }
}

extension Endpoint {
    // Returns an instance of URLComponents containing the base URL, path and query items provided
    var urlComponents: URLComponents {
        var components = URLComponents(string: base)!
        components.path = path
        components.queryItems = queryItems
        
        return components
    }
    
    // Returns an instance of URLRequest encapsulating the endpoint URL. This URL is obtained through the `urlComponents` object.
    var request: URLRequest {
        let url = urlComponents.url!
        return URLRequest(url: url)
    }
}

enum MovieEndpoints {
    
    // Creates the different sorting types
    enum MovieSortType: CustomStringConvertible {
        case popularity, releaseDate, voteCount
        
        var description: String {
            switch self {
            case .popularity: return "popularity"
            case .releaseDate: return "release_date"
            case .voteCount: return "vote_count"
            }
        }
    }
    
    // Creates the endpoints useable for calling the API
    case discoverWithGenres(genres: [Int], year: String, sortBy: MovieSortType, apiKey: String)
    case discoverWithGenre(genre: Int, year: String, sortBy: MovieSortType, apiKey: String)
    case getGenres(apiKey: String)
}

// Makes movieendpoints comform with Endpoint
extension MovieEndpoints: Endpoint {
    var base: String {
        return "https://api.themoviedb.org"
    }
    
    var path: String {
        switch self {
        case .discoverWithGenres: return "/3/discover/movie"
        case .discoverWithGenre: return "/3/discover/movie"
        case .getGenres: return "/3/genre/movie/list"
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .discoverWithGenres(let genres, let year, let sortBy, let apiKey):
            
            var genreString = ""
            
            for id in genres {
                genreString.append("\(id)%2C")
            }
            genreString.removeLast(3)
            
            return [
                URLQueryItem(name: "api_key", value: apiKey),
                URLQueryItem(name: "with_genres", value: genreString),
                URLQueryItem(name: "sort_by", value: "\(sortBy.description).desc"),
                URLQueryItem(name: "year", value: year),

            ]
            
        case .discoverWithGenre(let genre, let year, let sortBy, let apiKey):
            return [
                URLQueryItem(name: "api_key", value: apiKey),
                URLQueryItem(name: "with_genres", value: "\(genre)"),
                URLQueryItem(name: "sort_by", value: "\(sortBy.description).desc"),
                URLQueryItem(name: "year", value: year),

            ]
            
        case .getGenres(let apiKey): return [ URLQueryItem(name: "api_key", value: apiKey) ]
        }
    }
}
