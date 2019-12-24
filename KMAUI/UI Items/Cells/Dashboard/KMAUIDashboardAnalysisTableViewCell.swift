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
    @IBOutlet public weak var collectionView: KMAUICollectionView!
    @IBOutlet public weak var collectionViewTop: NSLayoutConstraint!
    
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
    
    public func setupProperty() {
        // Top offset for collectionView
        collectionViewTop.constant = 8
        // Property rent and sale analysis
        let propertyAnalysis = KMAUIZoopla.shared.getAverage(propertyArray: property)
        rentLabel.text = propertyAnalysis.0
        saleLabel.text = propertyAnalysis.1
        // Show labels
        rentTitleLabel.alpha = 1
        rentLabel.alpha = 1
        saleTitleLabel.alpha = 1
        saleLabel.alpha = 1
    }
    
    public func setupVenues() {
        // Top offset for collectionView
        collectionViewTop.constant = -52
        // Hide labels
        rentTitleLabel.alpha = 0
        rentLabel.alpha = 0
        saleTitleLabel.alpha = 0
        saleLabel.alpha = 0
    }
    
    @IBAction public func reviewButtonPressed(_ sender: Any) {
        buttomPressedCallback?(true)
    }
}
