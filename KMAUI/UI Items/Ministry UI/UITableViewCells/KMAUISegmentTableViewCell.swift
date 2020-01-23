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
    public var segmentItems = [String]() {
        didSet {
            self.setupCell()
        }
    }
    public var selectedIndex = 0
    public var selectedIndexCallback: ((Int) -> Void)?
    
    // MARK: - Cell methods
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // No selection required
        selectionStyle = .none
    }
    
    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    public func setupCell() {
        // Clear current subviews
        for subview in bgView.subviews {
            subview.removeFromSuperview()
        }
        
        // Create the new segmentControl
        let segmentControl = UISegmentedControl(items: segmentItems)
        segmentControl.selectedSegmentIndex = selectedIndex
        segmentControl.tintColor = KMAUIConstants.shared.KMAUIBlueDark
        segmentControl.layer.cornerRadius = KMAUIConstants.shared.KMACornerRadius
        segmentControl.backgroundColor = KMAUIConstants.shared.KMABackColor
//        segmentControl.layer.borderColor = UIColor.clear.cgColor
        
        if #available(iOS 13.0, *) {
            segmentControl.selectedSegmentTintColor = KMAUIConstants.shared.KMAUIBlueDark
        }
        
        segmentControl.layer.borderWidth = 0
        
        let normalAttritutes = [NSAttributedString.Key.font.rawValue: KMAUIConstants.shared.KMAUIRegularFont.withSize(12), NSAttributedString.Key.foregroundColor: KMAUIConstants.shared.KMAUITextColor] as! [NSAttributedString.Key: Any]
        segmentControl.setTitleTextAttributes(normalAttritutes, for: .normal)
        
        let selectedAttributes = [NSAttributedString.Key.font.rawValue: KMAUIConstants.shared.KMAUIBoldFont.withSize(12), NSAttributedString.Key.foregroundColor: KMAUIConstants.shared.KMABackColor] as! [NSAttributedString.Key: Any]
        segmentControl.setTitleTextAttributes(selectedAttributes, for: .selected)
        
        // Add target action method
        segmentControl.addTarget(self, action: #selector(segmentControlValueChanged(item:)), for: .valueChanged)

        // Add this custom Segmented Control to our view
        bgView.addSubview(segmentControl)
        fixBackgroundSegmentControl(segmentControl)
        
        KMAUIUtilities.shared.setConstaints(parentView: bgView, childView: segmentControl, left: 2, right: 2, top: 2, bottom: 2)
    }
    
    @objc public func segmentControlValueChanged(item: UISegmentedControl) {
        selectedIndex = item.selectedSegmentIndex
        selectedIndexCallback?(selectedIndex)
    }
    
    // Getting the correct background color without a shadow
    func fixBackgroundSegmentControl( _ segmentControl: UISegmentedControl){
        if #available(iOS 13.0, *) {
            //just to be sure it is full loaded
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                for i in 0...(segmentControl.numberOfSegments-1)  {
                    let backgroundSegmentView = segmentControl.subviews[i]
                    //it is not enogh changing the background color. It has some kind of shadow layer
                    backgroundSegmentView.isHidden = true
                }
            }
        }
    }
}
