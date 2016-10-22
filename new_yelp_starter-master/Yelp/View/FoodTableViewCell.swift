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
                //self.foodImageView.setImageWith(imageURL)
                let imageRequest = URLRequest(
                    url: imageURL,
                    cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData,
                    timeoutInterval: 10)
                foodImageView.setImageWith(
                    imageRequest,
                    placeholderImage: nil,
                    success: { (imageRequest, imageResponse, image) -> Void in
                        
                        // imageResponse will be nil if the image is cached
                        if imageResponse != nil {
                            self.foodImageView.alpha = 0.0
                            self.foodImageView.image = image
                            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                                self.foodImageView.alpha = 1.0
                            })
                        } else {
                            self.foodImageView.image = image
                        }
                    },
                    failure: { (imageRequest, imageResponse, error) -> Void in
                        // do something for the failure condition
                })
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
