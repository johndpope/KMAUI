//
//  KMAUISegmentSelectionTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 22.01.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit

public class KMAUISegmentTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet public weak var bgView: KMAUIRoundedCornersView!
    
    // MARK: - Variables
    public var segmentItems = ["Item 1", "Item 2", "Item 3"] {
        didSet {
            self.setupCell()
        }
    }
    public var isSetup = false
    public var selectedIndex = 0
    public var selectedIndexCallback: ((Int) -> Void)?
    public static let id = "KMAUISegmentTableViewCell"
    public let segmentControl = UISegmentedControl(items: ["Item 1", "Item 2", "Item 3"])
    
    // MARK: - Cell methods
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Clear current subviews
        for subview in bgView.subviews {
            subview.removeFromSuperview()
        }
        
        // Create the new segmentControl
        segmentControl.selectedSegmentIndex = selectedIndex
        segmentControl.tintColor = KMAUIConstants.shared.KMAUIBlueDarkColor
        segmentControl.layer.cornerRadius = KMAUIConstants.shared.KMACornerRadius
        segmentControl.backgroundColor = KMAUIConstants.shared.KMAUIViewBgColor
        
        if #available(iOS 13.0, *) {
            segmentControl.selectedSegmentTintColor = KMAUIConstants.shared.KMAUIBlueDarkColor
        }
        
        segmentControl.layer.borderWidth = 0
        
        let normalAttritutes = [NSAttributedString.Key.font.rawValue: KMAUIConstants.shared.KMAUIRegularFont.withSize(12), NSAttributedString.Key.foregroundColor: KMAUIConstants.shared.KMAUITextColor] as! [NSAttributedString.Key: Any]
        segmentControl.setTitleTextAttributes(normalAttritutes, for: .normal)
        
        let selectedAttributes = [NSAttributedString.Key.font.rawValue: KMAUIConstants.shared.KMAUIBoldFont.withSize(12), NSAttributedString.Key.foregroundColor: UIColor.white] as! [NSAttributedString.Key: Any]
        segmentControl.setTitleTextAttributes(selectedAttributes, for: .selected)
        
        // Add target action method
        segmentControl.addTarget(self, action: #selector(segmentControlValueChanged(item:)), for: .valueChanged)
        
        // Add this custom Segmented Control to our view
        bgView.addSubview(segmentControl)
        KMAUIUtilities.shared.setConstaints(parentView: bgView, childView: segmentControl, left: 0, right: 0, top: 0, bottom: 0)
        
        // No selection required
        selectionStyle = .none
    }
    
    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    public func setupCell() {
        // Update the segment titles
        segmentControl.removeAllSegments()
        for item in segmentItems {
            segmentControl.insertSegment(withTitle: item, at: segmentControl.numberOfSegments, animated: false)
        }
        // Update the segment selected index
        segmentControl.selectedSegmentIndex = selectedIndex
        
        // Fix the background
        if !isSetup {
            segmentControl.fixBackgroundSegmentControl()
            isSetup = true
        }
    }
    
    @objc public func segmentControlValueChanged(item: UISegmentedControl) {
        selectedIndex = item.selectedSegmentIndex
        selectedIndexCallback?(selectedIndex)
    }
}
