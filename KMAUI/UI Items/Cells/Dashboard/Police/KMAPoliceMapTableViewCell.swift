//
//  KMAPoliceMapTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 30.12.2019.
//  Copyright © 2019 Stanislav Rastvorov. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

public class KMAPoliceMapTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Variables
    public var neighbourhood = KMAPoliceNeighbourhood()
//    public var crimeNearby = [KMACrimeObject]()
//    public var crimeArray = [KMACrimeObject]()
    
    // MARK: - Cell methods
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Rounded corners for mapView
        mapView.layer.cornerRadius = KMAUIConstants.shared.KMACornerRadius
        mapView.clipsToBounds = true
        mapView.delegate = self
        
        // No selection required
        selectionStyle = .none
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setupCell() {
        print("Nearby crime: \(neighbourhood.crimeNearby.count), crime: \(neighbourhood.crimeArray.count)")
        
        let polygon = KMAUIUtilities.shared.getPolygon(bounds: <#T##[CLLocationCoordinate2D]#>)
    }
}

// MARK: - MapView extension

extension KMAPoliceMapTableViewCell: MKMapViewDelegate {
    
    public func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        <#code#>
    }
}
