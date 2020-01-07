//
//  UpdateWatcherDelegate.swift
//  MovieNightApp
//
//  Created by Raymond Choy on 1/5/20.
//  Copyright © 2020 thechoygroup. All rights reserved.
//

import Foundation

protocol UpdateWatcherDelegate {
    func update(_ watcher: Watcher, with genres: [Genre])
}
