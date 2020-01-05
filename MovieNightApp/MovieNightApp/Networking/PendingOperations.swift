//
//  PendingOperations.swift
//  MovieNightApp
//
//  Created by Raymond Choy on 1/5/20.
//  Copyright © 2020 thechoygroup. All rights reserved.
//


import Foundation

//----------------------------------------------------
// MANAGES PENDING OPERATIONS FOR THE IMAGE DOWNLOADER
//----------------------------------------------------

class PendingOperations {
    var downloadsInProgress = [IndexPath: Operation]()
    
    let downloadQueue = OperationQueue()
}
