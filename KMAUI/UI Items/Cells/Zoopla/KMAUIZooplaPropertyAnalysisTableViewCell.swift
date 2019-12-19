//
//  KMAUIZooplaPropertyAnalysisTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 16.12.2019.
//  Copyright © 2019 Stanislav Rastvorov. All rights reserved.
//

import UIKit

public class KMAUIZooplaPropertyAnalysisTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet public weak var rentLabel: KMAUITitleLabel!
    @IBOutlet public weak var saleLabel: KMAUITitleLabel!
    @IBOutlet public weak var reviewButton: KMAUIButtonFilled!
    @IBOutlet public weak var collectionView: UICollectionView!
    
    // MARK: - Variables
    public var buttomPressedCallback: ((Bool) -> Void)?
    public var zooplaProperty = [KMAZooplaProperty]()
    
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
    
    public func setupCell() {
        // Property rent and sale analysis
        let propertyAnalysis = KMAUIZoopla.shared.getAverage(propertyArray: zooplaProperty)
        rentLabel.text = propertyAnalysis.0
        saleLabel.text = propertyAnalysis.1
    }
    
    @IBAction public func reviewButtonPressed(_ sender: Any) {
        buttomPressedCallback?(true)
    }
}
