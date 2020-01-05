//
//  ImageDownloader.swift
//  MovieNightApp
//
//  Created by Raymond Choy on 1/5/20.
//  Copyright © 2020 thechoygroup. All rights reserved.
//


import Foundation
import UIKit

//---------------------------------
// DOWNLOADS IMAGES FOR RESULT PAGE
//---------------------------------

class ArtworkDownloader: Operation {
    
    let movie: Movie
    
    init(movie: Movie) {
        self.movie = movie
        super.init()
    }
    
    override func main() {
        if self.isCancelled {
            return
        }
        
        let urlString = "https://image.tmdb.org/t/p/w92\(movie.posterPath)"
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        let imageData = try! Data(contentsOf: url)
                
        if self.isCancelled {
            return
        }
        
        if imageData.count > 0 {
            movie.artwork = UIImage(data: imageData)
            movie.artworkState = .downloaded
        } else {
            movie.artworkState = .failed
        }
    }
}
