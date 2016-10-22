//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Chau Vo on 10/17/16.
//  Copyright © 2016 CoderSchool. All rights reserved.
//

import UIKit
import MBProgressHUD

class BusinessesViewController: UIViewController {

    @IBOutlet weak var foodTableView: UITableView!
    var businesses: [Business]! = []
    
    let searchBar = UISearchBar()
    var isMoreDataLoading = false
    var currentOffset = 10
    
    var loadingMoreView: InfiniteScrollActivityView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.foodTableView.delegate = self;
        self.foodTableView.dataSource = self;
        self.foodTableView.rowHeight = UITableViewAutomaticDimension
        self.foodTableView.estimatedRowHeight = 100
        
        // Set up Infinite Scroll loading indicator
        let frame = CGRect(x: 0, y: foodTableView.contentSize.height, width: foodTableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.isHidden = true
        foodTableView.addSubview(loadingMoreView!)
        
        var insets = foodTableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        foodTableView.contentInset = insets
        
        addSearchBar()
        
        // show progress hub
        MBProgressHUD.showAdded(to: self.view, animated: true)

        Business.search(with: "Thai", offset: currentOffset) { (businesses: [Business]?, error: Error?) in
            if let businesses = businesses {
                self.businesses = businesses
                self.foodTableView.reloadData()
                
                // hide progress hub
                MBProgressHUD.hide(for: self.view, animated: true)
            }
        }
    }

    func addSearchBar() {
        self.searchBar.showsCancelButton = false
        self.searchBar.placeholder = "Restaurants"
        self.searchBar.delegate = self
        
        self.navigationItem.titleView = searchBar
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
        let filterVC = navigationController.topViewController as! FiltersViewController
        
        filterVC.delegate = self
    }
}

extension BusinessesViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    // called when text changes (including clear)
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        currentOffset = 10
        
        Business.search(with: searchText, offset: currentOffset) { (businesses: [Business]?, error: Error?) in
            if let businesses = businesses {
                self.businesses = businesses
            }
        }
        
        if searchText == "" {
            Business.search(with: "Thai", offset: currentOffset) { (businesses: [Business]?, error: Error?) in
                if let businesses = businesses {
                    self.businesses = businesses
                }
            }
        }
        
        self.foodTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
    
}

extension BusinessesViewController: UIScrollViewDelegate {
    
    func loadMoreData() {
        self.currentOffset += 10
        Business.search(with: "Thai", offset: currentOffset) { (businesses: [Business]?, error: Error?) in
            if let businesses = businesses {
                self.businesses = businesses
                self.isMoreDataLoading = false
                
                // Stop the loading indicator
                self.loadingMoreView!.stopAnimating()
                
                self.foodTableView.reloadData()
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = foodTableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - foodTableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && foodTableView.isDragging) {
                isMoreDataLoading = true
                
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRect(x: 0, y: foodTableView.contentSize.height, width: foodTableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                // Code to load more results
                loadMoreData()
            }
        }
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
    
    func filterData(filtersViewController: FiltersViewController, didUpdate filters: [String], isDeal: Bool, sortBy: Int, radius: Int) {
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Business.search(with: "Thai", offset: self.currentOffset, sort: YelpSortMode(rawValue: sortBy), categories: filters, deals: isDeal) { (business: [Business]?, error: Error?) in
            if let businesses = business {
                self.businesses = businesses
                self.foodTableView.reloadData()
                
                // hide progress hub
                MBProgressHUD.hide(for: self.view, animated: true)
            }
        }
    }
}
