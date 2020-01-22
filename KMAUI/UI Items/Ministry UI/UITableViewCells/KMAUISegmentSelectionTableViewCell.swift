//
//  KMAUISegmentSelectionTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 22.01.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit

public class KMAUISegmentSelectionTableViewCell: UITableViewCell {
    @IBOutlet public weak var bgView: KMAUIRoundedCornersView!
    // MARK: - Variables
    public var segmentItems = [String]() {
        didSet {
            self.setupCell()
        }
    }
    public var selectedIndex = 0
    
    // MARK: - Cell methods
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setupCell() {
        /*// Clear current subviews
        for subview in bgView.subviews {
            subview.removeFromSuperview()
        }
        
        // Initialize
        let segmentControl = UISegmentedControl(items: segmentItems)
        segmentControl.selectedSegmentIndex = selectedIndex

        // Style the Segmented Control
//        segmentControl.layer.cornerRadius =  // Don't let background bleed
//        segmentControl.backgroundColor = UIColor.blackColor()
//        segmentControl.tintColor = UIColor.whiteColor()

        // Add target action method
//        segmentControl.addTarget(self, action: "changeColor:", forControlEvents: .ValueChanged)

        // Add this custom Segmented Control to our view
        bgView.addSubview(customSC)*/
    }
}
