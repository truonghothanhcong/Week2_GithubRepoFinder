//
//  CheckCell.swift
//  Yelp
//
//  Created by CongTruong on 10/19/16.
//  Copyright © 2016 CoderSchool. All rights reserved.
//

import UIKit

class CheckCell: UITableViewCell {

    @IBOutlet weak var ValueNameLabel: UILabel!
    @IBOutlet weak var stateButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        stateButton.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
