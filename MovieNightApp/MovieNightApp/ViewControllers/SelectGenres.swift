//
//  SelectGenres.swift
//  MovieNightApp
//
//  Created by Raymond Choy on 1/5/20.
//  Copyright © 2020 thechoygroup. All rights reserved.
//

import UIKit

class SelectGenresController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var genreSelectionButton: UIButton!
    @IBOutlet weak var nextButton: UIBarButtonItem!
    let client = MovieClient()
    var currentWatcher: Watcher = .noWatcher
    var watcher1Finished = false
    var watcher2Finished = false
    
    var delegate: UpdateWatcherDelegate?
    
    var genres: [Genre] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var selectedGenres: [Genre] = [] {
        didSet {
            genreSelectionButton.setTitle("\(self.selectedGenres.count) of 5 selected", for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        getGenres()

    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        genres.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "genreCell", for: indexPath) as! GenreCell
        cell.genreLabel?.text = genres[indexPath.row].name
                
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cell = tableView.cellForRow(at: indexPath) as! GenreCell
        let didUncheck = cell.toggleState()
        
        if didUncheck {
            print("unchecked")
            if selectedGenres.count == 0 {
                print("Setting to empty")
                selectedGenres = []
                
            } else {
                
                let genreToBeRemoved = genres[indexPath.row]
                let indexOfGenreToBeRemoved = selectedGenres.firstIndex() { genre in
                    genre.name == genreToBeRemoved.name
                }
                
                if let indexOfGenreToBeRemoved = indexOfGenreToBeRemoved {
                    selectedGenres.remove(at: indexOfGenreToBeRemoved)
                    
                    print("Remaining genres: \(selectedGenres)")

                } else {
                    // this should never happen
                    return
                }
            }
            
        } else {
            print("checked")
            selectedGenres.append(genres[indexPath.row])
            print("appended \(genres[indexPath.row].name) to \(selectedGenres)")
        }
    }
    
    func setupTableview(with genres: [Genre]) {
        self.genres = genres
    }
    
    
    // MARK: Button Pressing Functions
    @IBAction func nextButtonPressed(_ sender: Any) {
        
        if selectedGenres.count >= 5 {
            delegate?.update(currentWatcher, with: selectedGenres)

        } else {
            showAlertView(withTitle: "Insufficent Selection", andBody: "Please select 5 or more genres from the list")
        }
    }
    
    @IBAction func genreSelectionButtonPressed(_ sender: Any) {
        if selectedGenres.count >= 5 {
            delegate?.update(currentWatcher, with: selectedGenres)

        } else {
            showAlertView(withTitle: "Insufficent Selection", andBody: "Please select 5 or more genres from the list")
        }
    }
    
    
    // MARK: Data Gathering Functions
    func getGenres() {
        client.getGenres() { [weak self] result in
            switch result {
            case .success(let genres):
                DispatchQueue.main.async {
                    self?.setupTableview(with: genres)

                }
                
            case .failure(let error):
                print("Error getting genres in SelectGamesController: \(error)")
                
                if error == .responseUnsuccessful || error == .requestFailed {
                    self?.navigationController?.popViewController(animated: true)
                    self?.showAlertView(withTitle: "Responce Unsuccessfull", andBody: "Check your internet and try again.")
                }
            }
        }
    }
    
    // MARK: Helper Functions
    
    // Show an alertview
    func showAlertView(withTitle title: String, andBody body: String) {
        let alert = UIAlertController(title: title, message: body, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
}
