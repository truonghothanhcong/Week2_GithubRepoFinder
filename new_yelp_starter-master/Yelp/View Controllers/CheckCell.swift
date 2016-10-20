//
//  CheckCell.swift
//  Yelp
//
//  Created by CongTruong on 10/19/16.
//  Copyright © 2016 CoderSchool. All rights reserved.
//

import UIKit

//@objc protocol CheckCellProtocol {
//    @objc optional func changeStateOfferingDeal(checkCell: CheckCell, state: Bool)
//}

class CheckCell: UITableViewCell {

    @IBOutlet weak var ValueNameLabel: UILabel!
    @IBOutlet weak var stateButton: UIButton!
    
//    weak var delegate: CheckCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        stateButton.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func changeStateOfferingDeal(_ sender: UIButton) {
//        delegate?.changeStateOfferingDeal(checkCell: self, state: sender.imageView?.is)
//        if isOn {   // deal = true
//            // change isOn to false
//            isOn = false
//            // change image state to uncheck
//            sender.imageView?.image = UIImage(named: "error_icon")
//        } else {    // deal = false
//            // change isOn to true
//            isOn = false
//            // change image state to check
//            sender.imageView?.image = UIImage(named: "check_icon")
//        }
    }
}
