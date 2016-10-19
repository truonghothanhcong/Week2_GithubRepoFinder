//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Chau Vo on 10/17/16.
//  Copyright © 2016 CoderSchool. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var foodTableView: UITableView!
    var businesses: [Business]! = []
    
    let searchBar = UISearchBar()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.foodTableView.delegate = self;
        self.foodTableView.dataSource = self;
        self.foodTableView.rowHeight = UITableViewAutomaticDimension
        self.foodTableView.estimatedRowHeight = 100
        
        addSearchBar()

        Business.search(with: "Thai") { (businesses: [Business]?, error: Error?) in
            if let businesses = businesses {
                self.businesses = businesses

                self.foodTableView.reloadData()
                
//                for business in businesses {
//                    print(business.name!)
//                    print(business.imageURL!)
//                }
            }
        }

        // Example of Yelp search with more search options specified
        /*
        Business.search(with: "Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]?, error: Error?) in
            if let businesses = businesses {
                self.businesses = businesses

                for business in businesses {
                    print(business.name!)
                    print(business.address!)
                }
            }
        }
        */
    }

    func addSearchBar() {
        self.searchBar.showsCancelButton = false
        self.searchBar.placeholder = "Restaurants"
        self.searchBar.delegate = self
        
        self.navigationItem.titleView = searchBar
    }
}

extension BusinessesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.businesses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = foodTableView.dequeueReusableCell(withIdentifier: "foodCell", for: indexPath) as! FoodTableViewCell
        
        cell.business = businesses[indexPath.row]
        
        return cell
    }
}
