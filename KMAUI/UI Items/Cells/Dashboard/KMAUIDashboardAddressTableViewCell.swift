//
//  KMAUIDashboardAddressTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 23.12.2019.
//  Copyright © 2019 Stanislav Rastvorov. All rights reserved.
//

import UIKit
import MapKit

public class KMAUIDashboardAddressTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet public weak var mapView: MKMapView!
    @IBOutlet public weak var addressTitle: KMAUIInfoLabel!
    @IBOutlet public weak var addressLabel: KMAUITextLabel!
    @IBOutlet public weak var rightArrowImageView: UIImageView!
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Setup right arrow
        KMAUIUtilities.shared.setupArrow(imageView: rightArrowImageView)
        
        // No selection for mapView
        mapView.isUserInteractionEnabled = false
        
        // MapView UI
        mapView.layer.cornerRadius = KMAUIConstants.shared.KMACornerRadius
        mapView.clipsToBounds = true
        
        // No selection required
        selectionStyle = .none
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
