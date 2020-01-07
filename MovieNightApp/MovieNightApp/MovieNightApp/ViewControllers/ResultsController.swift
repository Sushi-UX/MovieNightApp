//
//  ResultsController.swift
//  MovieNightApp
//
//  Created by Raymond Choy on 1/5/20.
//  Copyright © 2020 thechoygroup. All rights reserved.
//

import UIKit

class ResultsController: UITableViewController {

    var watcher1Genres: [Genre] = []
    var watcher2Genres: [Genre] = []
        
    var movies: [Movie] = [] {
        didSet {
            print("UPDATING MOVIES")
            tableView.reloadData()
        }
    }
    
    let client = MovieClient()
    let pendingOperations = PendingOperations()
    var delegate: FinishedDelegate?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 138
        getMovies()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return movies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! MovieCell
        
        let currentMovie = movies[indexPath.row]
        // Configure the cell...
        cell.movieTitle.text = currentMovie.title
        cell.movieImage.image = currentMovie.artwork
        
        if currentMovie.formattedReleaseDate != nil {
            cell.releaseYear.text = currentMovie.formattedReleaseDate

        } else {
            cell.releaseYear.text = currentMovie.releaseDate
        }

        if currentMovie.artworkState == .placeholder {
            downloadArtworkForMovies(currentMovie, atIndexPath: indexPath)
        }
        
        return cell
    }

    // MARK: Helper Functions
    
    func setUpTableView(withMovies movies: [Movie]) {
        self.movies.append(contentsOf: movies)
    }
    
    func prepareGenres() -> [Genre] {
        
        // getting the genres that the user selected together
        var relatedGenres = watcher1Genres.filter(watcher2Genres.contains)
        
        //printing it for clarity
        print("\n\nThere are \(relatedGenres.count) related genres")
        for genre in relatedGenres {
            print(genre.name)
        }
        
        if relatedGenres.isEmpty {
            relatedGenres.append(watcher1Genres.randomElement()!)
            relatedGenres.append(watcher2Genres.randomElement()!)
        }
        
        return relatedGenres
    }
    
    func getMovies() {
        
        let genres = prepareGenres()
        
        var genreIDs: [Int] = []
        for genre in genres {
            genreIDs.append(genre.id)
        }
        
        for genre in genres {
            client.discover(withGenre: genre.id, duringYear: "2019", sortedBy: .popularity) { [weak self] result in
                switch result {
                case .success(let movies):
                    print("there are \(movies.count) movies in this result")
                    
                    // Make the changes on the mainQueue
                    DispatchQueue.main.async {
                        self?.setUpTableView(withMovies: movies)

                    }
                    
                case .failure(let error):
                    print("Error getting genres in Results Controller: \(error)")
                    
                    if error == .responseUnsuccessful || error == .requestFailed {
                        self?.navigationController?.popViewController(animated: true)
                        self?.showAlertView(withTitle: "Responce Unsuccessfull", andBody: "Check your internet and try again.")

                    }
                }
            }
        }
    }
    
    func downloadArtworkForMovies(_ movie: Movie, atIndexPath indexPath: IndexPath) {
//        print("Downloading Movie Artwork... ")
        if let _ = pendingOperations.downloadsInProgress[indexPath] {
            return
        }
        
        let downloader = ArtworkDownloader(movie: movie)
        
        downloader.completionBlock = {
            if downloader.isCancelled {
                return
            }
            
            DispatchQueue.main.async {
//                print("Artwork download finished!")
                self.pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
        
        pendingOperations.downloadsInProgress[indexPath] = downloader
        pendingOperations.downloadQueue.addOperation(downloader)
    }
    
    @IBAction func donePressed(_ sender: Any) {
        delegate?.clearData()
    }
    
    // Show an alertview
    func showAlertView(withTitle title: String, andBody body: String) {
        let alert = UIAlertController(title: title, message: body, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
}
