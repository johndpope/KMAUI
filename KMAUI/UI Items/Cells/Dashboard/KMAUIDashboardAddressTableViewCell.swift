//
//  KMAUIDashboardAddressTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 23.12.2019.
//  Copyright © 2019 Stanislav Rastvorov. All rights reserved.
//

import UIKit
import MapKit

class KMAUIDashboardAddressTableViewCell: UITableViewCell {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressTitle: KMAUIInfoLabel!
    @IBOutlet weak var addressLabel: KMAUITextLabel!
    @IBOutlet weak var rightArrowImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Setup right arrow
        KMAUIUtilities.shared.setupArrow(imageView: rightArrowImageView)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
