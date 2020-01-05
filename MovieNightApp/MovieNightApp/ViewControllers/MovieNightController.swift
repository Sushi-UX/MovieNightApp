//
//  MovieNightController.swift
//  MovieNightApp
//
//  Created by Raymond Choy on 1/5/20.
//  Copyright © 2020 thechoygroup. All rights reserved.
//

import UIKit

class MovieNightController: UIViewController {
    
    let movieApiClient = MovieClient()
    
    @IBOutlet weak var watcher1Button: UIButton!
    @IBOutlet weak var watcher1Check: UIImageView!
    @IBOutlet weak var watcher1StateDescription: UILabel!
    
    @IBOutlet weak var watcher2Button: UIButton!
    @IBOutlet weak var watcher2Check: UIImageView!
    @IBOutlet weak var watcher2StateDescription: UILabel!
    
    var watcher1Finished = false {
        didSet {
            refreshView()
        }
    }
    var watcher2Finished = false {
        didSet {
            refreshView()
        }
    }
    
    var watcher1Genres: [Genre] = []
    var watcher2Genres: [Genre] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.setHidesBackButton(true, animated: true)
        
        refreshView()
        
    }
    
    // Overriding method to check if the user has selected items for both watchers
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if identifier == "viewResults" {
            if watcher1Genres.count == 0 || watcher2Genres.count == 0 {
                showAlertView(withTitle: "Selection Invalid", andBody: "Please select genres for both watchers")
                return false
            } else {
                return true
            }
        } else {
            return true
        }
    }

    // MARK: PrepareForSeque Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "watcher1" {
            let selectGenresController = segue.destination as! SelectGenresController
            
            selectGenresController.currentWatcher = .watcher1
            selectGenresController.delegate = self
            
        } else if segue.identifier == "watcher2" {
            let selectGenresController = segue.destination as! SelectGenresController

            selectGenresController.currentWatcher = .watcher2
            selectGenresController.delegate = self
            
        } else if segue.identifier == "viewResults" {
            let resultsController = segue.destination as! ResultsController
            
            resultsController.delegate = self
            resultsController.watcher1Genres = watcher1Genres
            resultsController.watcher2Genres = watcher2Genres
            
        }
    }
    
    // MARK: Button Functions
    
    @IBAction func clearPressed(_ sender: Any) {
        watcher1Genres = []
        watcher2Genres = []
        watcher1Finished = false
        watcher2Finished = false
        
    }
    
    
    // MARK: Helper Functions
    
    func refreshView() {
        switch watcher1Finished {
        case true:
            watcher1Check.isHidden = false
            watcher1Button.isEnabled = false
            watcher1StateDescription.text = "Ready!"
            
        case false:
            watcher1Check.isHidden = true
            watcher1Button.isEnabled = true
            watcher1StateDescription.text = "Tap to enter preferences"

        }
        
        switch watcher2Finished {
        case true:
            watcher2Check.isHidden = false
            watcher2Button.isEnabled = false
            watcher2StateDescription.text = "Ready!"

        case false:
            watcher2Check.isHidden = true
            watcher2Button.isEnabled = true
            watcher2StateDescription.text = "Tap to enter preferences"

        }
        
        print("Views refreshed")
    }
    
    func showAlertView(withTitle title: String, andBody body: String) {
        let alert = UIAlertController(title: title, message: body, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
}


// Adding conformance to UpdateWatcherDelegate
// Allows us to transfer info from the SelectGenresController here after the user is done

extension MovieNightController: UpdateWatcherDelegate {
    
    func update(_ watcher: Watcher, with genres: [Genre]) {
        print("delegate called in extension")
        
        switch watcher {
        case .watcher1:
            self.watcher1Genres = genres
            self.watcher1Finished = true
        case .watcher2:
            self.watcher2Genres = genres
            self.watcher2Finished = true
        default:
            return
            
        }
        
        navigationController?.popViewController(animated: true)
    }
}

// Adding conformance to UpdateWatcherDelegate
// Allows us to clear the data when user returns from the Results controller

extension MovieNightController: FinishedDelegate {
    func clearData() {
        watcher1Genres = []
        watcher2Genres = []
        watcher1Finished = false
        watcher2Finished = false
        
        navigationController?.popViewController(animated: true)
    }
}
