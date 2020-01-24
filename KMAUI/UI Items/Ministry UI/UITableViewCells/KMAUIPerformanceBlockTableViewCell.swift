//
//  KMAUIPerformanceBlockTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 22.01.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit
import MKRingProgressView

public class KMAUIPerformanceBlockTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet weak var progressView: RingProgressView!
    @IBOutlet weak var progressLabel: KMAUIBoldTextLabel!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemStatLabel: KMAUIRegularTextLabel!
    @IBOutlet weak var starButton: UIButton!
    @IBOutlet weak var arrowIndicator: UIImageView!
    
    // MARK: - Variables
    public var itemPerformance = KMAItemPerformance() {
        didSet {
            setupCell()
        }
    }
    
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
        // Progress view
        progressView.progress = Double(itemPerformance.progress) / 100
        KMAUIUtilities.shared.setupColor(ring: progressView)
        
        // Progress label
        progressLabel.text = "\(itemPerformance.progress)%"
        
        // Item name label
        itemNameLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(18)
        itemNameLabel.text = itemPerformance.itemName
        
        // Item stat label
        itemStatLabel.text = itemPerformance.itemStat
        
        // Star button
        starButton.setTitle("", for: .normal)
        starButton.setImage(KMAUIConstants.shared.starIcon.withRenderingMode(.alwaysTemplate), for: .normal)
        starButton.layer.cornerRadius = KMAUIConstants.shared.KMACornerRadius
        starButton.clipsToBounds = true
        
        if itemPerformance.isOn {
            starButton.tintColor = UIColor.white
            starButton.backgroundColor = KMAUIConstants.shared.KMABlueColor
        } else {
            starButton.tintColor = KMAUIConstants.shared.KMAUIGreyLineColor
            starButton.backgroundColor = KMAUIConstants.shared.KMAUIGreyProgressColor
        }
    }
}
