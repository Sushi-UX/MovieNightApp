//
//  GenreCell.swift
//  MovieNightApp
//
//  Created by Raymond Choy on 1/5/20.
//  Copyright © 2020 thechoygroup. All rights reserved.
//

import UIKit

class GenreCell: UITableViewCell {
    
    
    @IBOutlet weak var genreCheckImage: UIImageView!
    @IBOutlet weak var genreLabel: UILabel!
    
    var isChecked = false
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
       
    }
    
    // returns true or false depending on if it toggled
    func toggleState() -> Bool {
        
        switch isChecked {
        case true:
            genreCheckImage.image = #imageLiteral(resourceName: "unchecked_mark")
            isChecked = false
            return true
            
        case false:
            genreCheckImage.image = #imageLiteral(resourceName: "checked_mark")
            isChecked = true
            return false
            
        }
    }
}
