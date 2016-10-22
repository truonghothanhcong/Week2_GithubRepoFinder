//
//  Business.swift
//  Yelp
//
//  Created by Chau Vo on 10/17/16.
//  Copyright © 2016 CoderSchool. All rights reserved.
//

import Foundation

class Business: NSObject {
    let name: String?
    let address: String?
    let imageURL: URL?
    let categories: String?
    let distance: String?
    let ratingImageURL: URL?
    let reviewCount: NSNumber?
    var latitude: NSNumber?
    var longitude: NSNumber?

    init(dictionary: NSDictionary) {
        name = dictionary["name"] as? String

        let imageURLString = dictionary["image_url"] as? String
        if imageURLString != nil {
            imageURL = URL(string: imageURLString!)!
        } else {
            imageURL = nil
        }

        let location = dictionary["location"] as? NSDictionary
        var address = ""
        latitude = nil; longitude = nil;
        if location != nil {
            let addressArray = location!["address"] as? NSArray
            if addressArray != nil && addressArray!.count > 0 {
                address = addressArray![0] as! String
            }

            let neighborhoods = location!["neighborhoods"] as? NSArray
            if neighborhoods != nil && neighborhoods!.count > 0 {
                if !address.isEmpty {
                    address += ", "
                }
                address += neighborhoods![0] as! String
            }
            
            let coordinate = location!["coordinate"] as? NSDictionary
            if coordinate != nil {
                latitude = coordinate!["latitude"] as? NSNumber
                longitude = coordinate!["longitude"] as? NSNumber
            }
        }
        self.address = address

        let categoriesArray = dictionary["categories"] as? [[String]]
        if categoriesArray != nil {
            var categoryNames = [String]()
            for category in categoriesArray! {
                let categoryName = category[0]
                categoryNames.append(categoryName)
            }
            categories = categoryNames.joined(separator: ", ")
        } else {
            categories = nil
        }

        let distanceMeters = dictionary["distance"] as? NSNumber
        if distanceMeters != nil {
            distance = String(format: "%.2f mi", Global.milesPerMeter * distanceMeters!.doubleValue)
        } else {
            distance = nil
        }

        let ratingImageURLString = dictionary["rating_img_url_large"] as? String
        if ratingImageURLString != nil {
            ratingImageURL = URL(string: ratingImageURLString!)
        } else {
            ratingImageURL = nil
        }

        reviewCount = dictionary["review_count"] as? NSNumber
    }

    class func businesses(array: [NSDictionary]) -> [Business] {
        var businesses = [Business]()
        for dictionary in array {
            let business = Business(dictionary: dictionary)
            businesses.append(business)
        }
        return businesses
    }

    class func search(with term: String, offset: Int?, completion: @escaping ([Business]?, Error?) -> ()) {
        YelpClient.shared().search(with: term, offset: offset, completion: completion)
    }

    class func search(with term: String, offset: Int?, sort: YelpSortMode?, categories: [String]?, deals: Bool?, radius: Int?, completion: @escaping ([Business]?, Error?) -> ()) -> () {
        YelpClient.shared().search(with: term, offset: offset, sort: sort, categories: categories, deals: deals, radius: radius, completion: completion)
    }
}
