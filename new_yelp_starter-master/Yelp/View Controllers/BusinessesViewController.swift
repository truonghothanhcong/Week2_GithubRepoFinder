//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Chau Vo on 10/17/16.
//  Copyright © 2016 CoderSchool. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UISearchBarDelegate, UIScrollViewDelegate {

    @IBOutlet weak var foodTableView: UITableView!
    var businesses: [Business]! = []
    
    let searchBar = UISearchBar()
    var isMoreDataLoading = false

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
    
    // MARK: - implement search bar delegate
    
//    // called when text changes (including clear)
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
//        self.businessesSearchArray = businesses.filter({
//            ($0.originalTitle?.contains(searchText))!
//        })
//        
//        if searchText == "" {
//            self.businessesSearchArray = self.businesses
//        }
//        
//        self.foodTableView.reloadData()
//    }
    
    // MARK: - ScrollViewDelegate
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        // Calculate the position of one screen length before the bottom of the results
//        let scrollViewContentHeight = foodTableView.contentSize.height
//        let scrollOffsetThreshold = scrollViewContentHeight - foodTableView.bounds.size.height
//        
//        // When the user has scrolled past the threshold, start requesting
//        if(scrollView.contentOffset.y > scrollOffsetThreshold && foodTableView.isDragging) {
//            isMoreDataLoading = true
//            
//            // Code to load more results
//            loadMoreData()
//        }
//    }
//    
//    func loadMoreData() {
//        
//        // ... Create the NSURLRequest (myRequest) ...
//        
//        // Configure session so that completion handler is executed on main UI thread
//        let session = URLSession(
//            configuration: URLSessionConfiguration.default,
//            delegate:nil,
//            delegateQueue:OperationQueue.main
//        )
//        
//        let task : URLSessionDataTask = session.dataTaskWithRequest(myRequest, completionHandler: { (data, response, error) in
//            
//            // Update flag
//            self.isMoreDataLoading = false
//            
//            // Stop the loading indicator
//            self.loadingMoreView!.stopAnimating()
//            
//            // ... Use the new data to update the data source ...
//            
//            // Reload the tableView now that there is new data
//            self.myTableView.reloadData()
//        });
//        task.resume()
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
        let filterVC = navigationController.topViewController as! FiltersViewController
        
        filterVC.delegate = self
    }
}

extension BusinessesViewController: UITableViewDelegate, UITableViewDataSource, FilterViewControllerDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.businesses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = foodTableView.dequeueReusableCell(withIdentifier: "foodCell", for: indexPath) as! FoodTableViewCell
        
        cell.business = businesses[indexPath.row]
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func filterData(filtersViewController: FiltersViewController, didUpdate filters: [String], isDeal: Bool, sortBy: Int, radius: Int) {
        //print("aaa\(isDeal)")
        Business.search(with: "Thai", sort: YelpSortMode(rawValue: sortBy), categories: filters, deals: isDeal) { (business: [Business]?, error: Error?) in
            if let businesses = business {
                self.businesses = businesses
                
                self.foodTableView.reloadData()
            }
        }
    }
}
