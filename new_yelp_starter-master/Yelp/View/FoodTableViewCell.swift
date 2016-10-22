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
            if let imageURL = business.imageURL {
                self.foodImageView.setImageWith(imageURL)
            }
            if let name = business.name {
                self.foodNameLabel.text = name
            }
            if let distance = business.distance {
                self.distanceLabel.text = distance
            }
            if let address = business.address {
                self.addressLabel.text = address
            }
            if let categories = business.categories {
                self.categoriesLabel.text = categories
            }
            if let imageURL = business.ratingImageURL {
                self.reviewImageView.setImageWith(imageURL)
            }
            if let reviewCount = business.reviewCount {
                self.reviewCountLabel.text = "\(reviewCount) Reviews"
            }
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
