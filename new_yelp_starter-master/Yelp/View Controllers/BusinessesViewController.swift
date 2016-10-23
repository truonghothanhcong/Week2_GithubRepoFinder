//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Chau Vo on 10/17/16.
//  Copyright © 2016 CoderSchool. All rights reserved.
//

import UIKit
import MBProgressHUD
import MapKit

class BusinessesViewController: UIViewController {

    @IBOutlet weak var heightMapConstraint: NSLayoutConstraint!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var foodTableView: UITableView!
    var businesses: [Business]! = []
    
    let searchBar = UISearchBar()
    var isMoreDataLoading = false
    var currentOffset = Global.offsetPage
    
    var loadingMoreView: InfiniteScrollActivityView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.foodTableView.delegate = self;
        self.foodTableView.dataSource = self;
        self.foodTableView.rowHeight = UITableViewAutomaticDimension
        self.foodTableView.estimatedRowHeight = CGFloat(Global.rowHeight)
        
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
        
        // Initialize a UIRefreshControl
        let refreshControlCollection = UIRefreshControl()
        refreshControlCollection.addTarget(self, action: #selector(refreshControlAction(refreshControl:)), for: UIControlEvents.valueChanged)
        let refreshControlTable = UIRefreshControl()
        refreshControlTable.addTarget(self, action: #selector(refreshControlAction(refreshControl:)), for: UIControlEvents.valueChanged)
        
        // add refresh control to table view
        foodTableView.insertSubview(refreshControlTable, at: 0)

        // load data
        Business.search(with: Global.restaurentKeySearch, offset: currentOffset) { (businesses: [Business]?, error: Error?) in
            if let businesses = businesses {
                self.businesses = businesses
                self.foodTableView.reloadData()
                self.addListAnnotation(from: businesses, to: self.mapView)
                
                // hide progress hub
                MBProgressHUD.hide(for: self.view, animated: true)
            }
        }
    }

    func addSearchBar() {
        // init for search bar
        self.searchBar.showsCancelButton = false
        self.searchBar.placeholder = "Restaurants"
        self.searchBar.delegate = self
        
        // add search bar to navigation bar
        self.navigationItem.titleView = searchBar
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
        let filterVC = navigationController.topViewController as! FiltersViewController
        
        filterVC.delegate = self
    }
    
    // handle for change size of mapView and tableView
    @IBAction func handlePan(recognizer:UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.view)
        if let view = recognizer.view {
            // change y value of view
            view.center = CGPoint(x:view.center.x, y:view.center.y + translation.y)
            // change constrant height of map view
            heightMapConstraint.constant -= translation.y
        }
        recognizer.setTranslation(CGPoint.zero, in: self.view)
    }
    
    // MARK: - refreshControl
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        // reset offset page
        currentOffset = 10
        // reset movies array
        businesses = []
        
        // load data
        Business.search(with: Global.restaurentKeySearch, offset: currentOffset) { (businesses: [Business]?, error: Error?) in
            if let businesses = businesses {
                self.businesses = businesses
                self.foodTableView.reloadData()
                self.addListAnnotation(from: businesses, to: self.mapView)
                
                // Tell the refreshControl to stop spinning
                refreshControl.endRefreshing()
                // hide progress hub
                MBProgressHUD.hide(for: self.view, animated: true)
            }
        }
    }
}

extension BusinessesViewController {
    func createAnnotation(latitude: NSNumber, longitude: NSNumber, title: String, address: String) -> MKPointAnnotation {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(latitude), CLLocationDegrees(longitude))
        annotation.title = title
        annotation.subtitle = address
        
        return annotation
    }
    
    func moveView(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let location = CLLocationCoordinate2DMake(CLLocationDegrees(latitude), CLLocationDegrees(longitude))
        
        let span = MKCoordinateSpanMake(0.1, 0.1)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    func addListAnnotation(from businessArray: [Business], to mapView: MKMapView) {
        // clean map
        mapView.removeAnnotations(mapView.annotations)
        
        // get annotation array to show on map
        var annotationArray = [MKPointAnnotation]()
        for business in businessArray {
            guard let latitude = business.latitude else { continue }
            guard let longitude = business.longitude else { continue }
            guard let title = business.name else { continue }
            guard let address = business.address else { continue }
            
            annotationArray.append(createAnnotation(latitude: latitude, longitude: longitude, title: title, address: address))
        }
        
        // add annotation to map
        mapView.addAnnotations(annotationArray)
        // move view of map to the first annotation
        if annotationArray.count > 0 {
            let annotation = annotationArray[0]
            moveView(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
        }
    }
}

extension BusinessesViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    // called when text changes (including clear)
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        currentOffset = 10
        
        // change restaurent key search
        Global.restaurentKeySearch = searchText
        // search with search text input
        Business.search(with: searchText, offset: currentOffset) { (businesses: [Business]?, error: Error?) in
            if let businesses = businesses {
                self.businesses = businesses
            }
        }
        
        // if search text empty -> search with default restaurent
        if searchText == "" {
            Global.restaurentKeySearch = Global.restaurentKeySearchDefault
            Business.search(with: Global.restaurentKeySearch, offset: currentOffset) { (businesses: [Business]?, error: Error?) in
                if let businesses = businesses {
                    self.businesses = businesses
                }
            }
        }
        
        self.addListAnnotation(from: businesses, to: self.mapView)
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
        currentOffset += Global.offsetPage
        Business.search(with: Global.restaurentKeySearch, offset: currentOffset) { (businesses: [Business]?, error: Error?) in
            if let businesses = businesses {
                self.businesses = self.businesses + businesses
                self.isMoreDataLoading = false
                
                // Stop the loading indicator
                self.loadingMoreView!.stopAnimating()
                
                self.addListAnnotation(from: self.businesses, to: self.mapView)
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
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none;
        
        return cell
    }
    
    func filterData(filtersViewController: FiltersViewController, didUpdate filters: [String], isDeal: Bool, sortBy: Int, radius: Int) {
        var r: Int?, sBy: YelpSortMode?
        if radius != -1 {
            r = radius
        }
        if sortBy != -1 {
            sBy = YelpSortMode(rawValue: sortBy)
        }
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Business.search(with: Global.restaurentKeySearch, offset: self.currentOffset, sort: sBy, categories: filters, deals: isDeal, radius: r) { (business: [Business]?, error: Error?) in
            if let businesses = business {
                self.businesses = businesses
                self.foodTableView.reloadData()
                self.addListAnnotation(from: businesses, to: self.mapView)
                
                // hide progress hub
                MBProgressHUD.hide(for: self.view, animated: true)
            }
        }
    }
}
