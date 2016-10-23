//
//  FiltersViewController.swift
//  Yelp
//
//  Created by CongTruong on 10/19/16.
//  Copyright © 2016 CoderSchool. All rights reserved.
//

import UIKit

enum sectionOfFilter: Int {
    case sectionOfferingOfDeal = 0, distance, sortBy, category
}

@objc protocol FilterViewControllerDelegate {
    @objc optional func filterData(filtersViewController: FiltersViewController, didUpdate filters: [String], isDeal: Bool, sortBy: Int, radius: Int);
}

class FiltersViewController: UIViewController {
    
    let categoriesArray = Global.categoriesArray
    let sortByArray = Global.sortByArray
    let distanceArray = Global.distanceArray
    var isOfferingDeal = false
    var switchState = [Int : Bool] ()
    var selectedDistance = -1
    var sortBySelected = -1
    var isSwitchDistanceOn = false
    var isSwitchSortOn = false
    var isExpandCategory = false

    @IBOutlet weak var filtersTableView: UITableView!
    
    weak var delegate: FilterViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.filtersTableView.delegate = self
        self.filtersTableView.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelView(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func onFilterData(_ sender: AnyObject) {
        var filter = [String]()
        
        for (row, isSelected) in switchState {
            if isSelected {
                filter.append(categoriesArray[row]["code"]!)
            }
        }
        
        delegate?.filterData!(filtersViewController: self, didUpdate: filter, isDeal: isOfferingDeal, sortBy: sortBySelected, radius: selectedDistance)
        
        self.dismiss(animated: true, completion: nil)
    }
}

extension FiltersViewController: UITableViewDelegate, UITableViewDataSource, SwitchCellDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == sectionOfFilter.sectionOfferingOfDeal.rawValue {    // state for deal
            let cell = filtersTableView.dequeueReusableCell(withIdentifier: "switchCell", for: indexPath) as! SwitchCell
            
            cell.categoryLabel.text = "Offering a Deal"
            cell.switchButton.isOn = false
            
            cell.delegate = self
            
            return cell
        } else if indexPath.section == sectionOfFilter.distance.rawValue {          // state for distance
            if indexPath.row == 0 {
                let cell = filtersTableView.dequeueReusableCell(withIdentifier: "switchCell", for: indexPath) as! SwitchCell
                
                cell.categoryLabel.text = "Distance"
                cell.switchButton.isOn = isSwitchDistanceOn
                
                cell.delegate = self
                
                return cell
            } else {
                let cell = filtersTableView.dequeueReusableCell(withIdentifier: "checkCell", for: indexPath) as! CheckCell
                
                cell.ValueNameLabel.text = "\(distanceArray[indexPath.row - 1]) miles"
                cell.stateButton.isHidden = distanceArray[indexPath.row - 1] != selectedDistance
                
                return cell
            }
        } else if indexPath.section == sectionOfFilter.sortBy.rawValue {            // state for sort by
            if indexPath.row == 0 {
                let cell = filtersTableView.dequeueReusableCell(withIdentifier: "switchCell", for: indexPath) as! SwitchCell
                
                cell.categoryLabel.text = "Sort By"
                cell.switchButton.isOn = isSwitchSortOn
                
                cell.delegate = self
                
                return cell
            } else {
                let cell = filtersTableView.dequeueReusableCell(withIdentifier: "checkCell", for: indexPath) as! CheckCell
                
                cell.ValueNameLabel.text = sortByArray[indexPath.row - 1]
                cell.stateButton.isHidden = (indexPath.row - 1) != sortBySelected
                
                return cell
            }
        } else {                            // state for category
            if !isExpandCategory && indexPath.row == 3 {
                let cell = filtersTableView.dequeueReusableCell(withIdentifier: "seeAllCell", for: indexPath)
                
                return cell
            }
            let cell = filtersTableView.dequeueReusableCell(withIdentifier: "switchCell", for: indexPath) as! SwitchCell
            
            cell.categoryLabel.text = self.categoriesArray[indexPath.row]["name"]
            cell.switchButton.isOn = self.switchState[indexPath.row] ?? false
            
            cell.delegate = self
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case sectionOfFilter.sectionOfferingOfDeal.rawValue:
            return 1
        case sectionOfFilter.distance.rawValue:
            return distanceArray.count + 1
        case sectionOfFilter.sortBy.rawValue:
            return sortByArray.count + 1
        case sectionOfFilter.category.rawValue:
            if isExpandCategory {
                return categoriesArray.count
            } else {
                return 4
            }
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case sectionOfFilter.distance.rawValue:
            if isSwitchDistanceOn {
                return CGFloat(Global.rowHeightFilter)
            } else {
                return indexPath.row == 0 ? CGFloat(Global.rowHeightFilter) : 0
            }
        case sectionOfFilter.sortBy.rawValue:
            if isSwitchSortOn {
                return CGFloat(Global.rowHeightFilter)
            } else {
                return indexPath.row == 0 ? CGFloat(Global.rowHeightFilter) : 0
            }
        default:
            return CGFloat(Global.rowHeightFilter)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section != 0 {
            return 50
        }
        return 10
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case sectionOfFilter.distance.rawValue:
            return "Distance"
        case sectionOfFilter.sortBy.rawValue:
            return "Sort By"
        case sectionOfFilter.category.rawValue:
            return "Category"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case sectionOfFilter.distance.rawValue:
            if indexPath.row != 0 {
                selectedDistance = distanceArray[indexPath.row - 1]
                filtersTableView.reloadSections(IndexSet(integer: sectionOfFilter.distance.rawValue), with: .none)
            }
        case sectionOfFilter.sortBy.rawValue:
            if indexPath.row != 0 {
                sortBySelected = indexPath.row - 1
                filtersTableView.reloadSections(IndexSet(integer: sectionOfFilter.sortBy.rawValue), with: .none)
            }
        case sectionOfFilter.category.rawValue:
            if !isExpandCategory && indexPath.row == 3 {
                isExpandCategory = true
                filtersTableView.reloadSections(IndexSet(integer: sectionOfFilter.category.rawValue), with: .automatic)
            }
        default: break
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func switchCell(switchCell: SwitchCell, didChangeValue value: Bool) {
        let indexPath = filtersTableView.indexPath(for: switchCell)
        
        switch indexPath!.section {
        case sectionOfFilter.sectionOfferingOfDeal.rawValue:
            isOfferingDeal = value
        case sectionOfFilter.distance.rawValue:
            isSwitchDistanceOn = value
            
            if isSwitchDistanceOn {
                if selectedDistance == -1 {
                    selectedDistance = distanceArray[0]
                }
            } else {
                selectedDistance = -1
            }
            filtersTableView.reloadSections(IndexSet(integer: 1), with: .automatic)
        case sectionOfFilter.sortBy.rawValue:
            isSwitchSortOn = value
            
            if isSwitchSortOn {
                if sortBySelected == -1 {
                    sortBySelected = 0
                }
            } else {
                sortBySelected = -1
            }
            filtersTableView.reloadSections(IndexSet(integer: 2), with: .automatic)
        case sectionOfFilter.category.rawValue:
            switchState[indexPath!.row] = value
        default: break
        }
    }
}
