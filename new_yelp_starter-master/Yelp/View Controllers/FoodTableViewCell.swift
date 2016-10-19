//
//  FoodTableViewCell.swift
//  Yelp
//
//  Created by CongTruong on 10/18/16.
//  Copyright © 2016 CoderSchool. All rights reserved.
//

import UIKit
import AFNetworking

class FoodTableViewCell: UITableViewCell {

    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var reviewImageView: UIImageView!
    @IBOutlet weak var reviewCountLabel: UILabel!
    
    var business: Business! {
        didSet {
            self.foodImageView.setImageWith(business.imageURL!)
            self.foodNameLabel.text = business.name
            self.distanceLabel.text = business.distance
            self.addressLabel.text = business.address
            self.categoriesLabel.text = business.categories
            self.reviewImageView.setImageWith(business.ratingImageURL!)
            self.reviewCountLabel.text = "\(business.reviewCount!) Reviews"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
