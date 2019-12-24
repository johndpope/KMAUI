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
    @IBOutlet public weak var bgView: KMAUIRoundedCornersView!
    @IBOutlet public weak var mapView: MKMapView!
    @IBOutlet public weak var addressLabel: KMAUITextLabel!
    @IBOutlet public weak var rightArrowImageView: UIImageView!
    
    // MARK: - Variables
    public var venue = KMAFoursquareVenue()
    public var property = KMAZooplaProperty()
    
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
        
        setupColors(highlight: selected)
    }
    
    override public func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        setupColors(highlight: highlighted)
    }
    
    public func setupColors(highlight: Bool) {
        if highlight {
            bgView.backgroundColor = KMAUIConstants.shared.KMABrightBlueColor
            addressLabel.textColor = UIColor.white
            rightArrowImageView.tintColor = UIColor.white
        } else {
            bgView.backgroundColor = KMAUIConstants.shared.KMABackColor
            addressLabel.textColor = KMAUIConstants.shared.KMATextColor
            rightArrowImageView.tintColor = KMAUIConstants.shared.KMATextGrayColor
        }
    }
    
    public func setupProperty() {
        if property.address.isEmpty {
            addressLabel.text = "Address not available."
        } else {
            addressLabel.text = property.address
        }
        
        setupPin(latitude: property.latitude, longitude: property.longitude)
    }
    
    public func setupVenue() {
        if venue.detailsLoaded {
            if venue.address.isEmpty {
                addressLabel.text = "Address not available."
            } else {
                addressLabel.text = venue.address
            }
        } else {
            addressLabel.text = "Loading address..."
        }
        
        setupPin(latitude: venue.latitude, longitude: venue.longitude)
    }
    
    public func setupPin(latitude: Double, longitude: Double) {
        // Show user location
        mapView.showsUserLocation = true
        // Remove annotations
        mapView.removeAnnotations(mapView.annotations)
        // Add an annotation.
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        mapView.addAnnotation(annotation)
        // Highlight annotation
//        mapView.selectAnnotation(annotation, animated: true)
//        mapView.setCenter(annotation.coordinate, animated: true)
        mapView.setRegion(MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 150, longitudinalMeters: 150), animated: true)
    }
}
