//
//  KMAUIZooplaPropertyAnalysisTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 16.12.2019.
//  Copyright © 2019 Stanislav Rastvorov. All rights reserved.
//

import UIKit

public class KMAUIDashboardAnalysisTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet public weak var rentTitleLabel: KMAUITextLabel!
    @IBOutlet public weak var rentLabel: KMAUITitleLabel!
    @IBOutlet public weak var saleTitleLabel: KMAUITextLabel!
    @IBOutlet public weak var saleLabel: KMAUITitleLabel!
    @IBOutlet public weak var reviewButton: KMAUIButtonFilled!
    @IBOutlet public weak var reviewButtonHeight: NSLayoutConstraint!
    @IBOutlet public weak var reviewButtonTop: NSLayoutConstraint!
    @IBOutlet public weak var reviewButtonBottom: NSLayoutConstraint!
    @IBOutlet public weak var collectionView: KMAUICollectionView!
    @IBOutlet public weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet public weak var collectionViewTop: NSLayoutConstraint!
    @IBOutlet public weak var collectionViewLeft: NSLayoutConstraint!
    @IBOutlet public weak var collectionViewRight: NSLayoutConstraint!
    
    // 22 8 22 8
    
    // MARK: - Variables
    public var buttomPressedCallback: ((Bool) -> Void)?
    public var property = [KMAZooplaProperty]()
    public var venues = [KMAFoursquareVenue]()
    
    // MARK: - Cell methods
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Rounded corners for the collectionView
        collectionView.layer.cornerRadius = KMAUIConstants.shared.KMACornerRadius
        collectionView.clipsToBounds = true
        
        // No selection required
        selectionStyle = .none
    }
    
    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func showLabels() {
        // Show labels
        rentTitleLabel.alpha = 1
        rentLabel.alpha = 1
        saleTitleLabel.alpha = 1
        saleLabel.alpha = 1
    }
    
    func hideLabels() {
        // Top offset for collectionView
        collectionViewTop.constant = -60
        // Hide labels
        rentTitleLabel.alpha = 0
        rentLabel.alpha = 0
        saleTitleLabel.alpha = 0
        saleLabel.alpha = 0
    }
    
    func hideButton() {
        // Hide the review button
        reviewButton.alpha = 0
        reviewButtonHeight.constant = 0
        reviewButtonTop.constant = 0
        reviewButtonBottom.constant = 0
        // Hide collectionView sides
        collectionViewLeft.constant = 0
        collectionViewRight.constant = 0
        //
        collectionViewHeight.constant = 366
    }
    
    public func setupProperty() {
        // Top offset for collectionView
        collectionViewTop.constant = 8
        // Property rent and sale analysis
        let propertyAnalysis = KMAUIZoopla.shared.getAverage(propertyArray: property)
        rentLabel.text = propertyAnalysis.0
        saleLabel.text = propertyAnalysis.1
        showLabels()
    }
    
    public func setupVenues() {
        hideLabels()
    }
    
    public func setupCollection() {
        hideLabels()
        hideButton()
    }
    
    @IBAction public func reviewButtonPressed(_ sender: Any) {
        buttomPressedCallback?(true)
    }
}
