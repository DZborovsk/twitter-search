//
//  TableViewCell.swift
//  twitter
//
//  Created by Danyil ZBOROVKYI on 6/29/19.
//  Copyright © 2019 Danyil ZBOROVKYI. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    func cellCinfigurate(tweet: Tweet) {
        nameLabel.text = tweet.name
        descriptionLabel.text = tweet.text
        dateLabel.text = tweet.date
    }
}
