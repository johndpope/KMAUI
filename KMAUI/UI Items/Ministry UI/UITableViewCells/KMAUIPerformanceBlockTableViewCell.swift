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
    @IBOutlet public weak var progressView: RingProgressView!
    @IBOutlet public weak var progressLabel: KMAUIBoldTextLabel!
    @IBOutlet public weak var itemNameLabel: KMAUIBoldTextLabel!
    @IBOutlet public weak var itemStatLabel: KMAUIRegularTextLabel!
    @IBOutlet public weak var starButton: UIButton!
    @IBOutlet public weak var arrowIndicatorView: UIImageView!
    
    // MARK: - Variables
    public var itemPerformance = KMAItemPerformance() {
        didSet {
            setupCell()
        }
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Star button corner radius
        starButton.setImage(KMAUIConstants.shared.starIcon.withRenderingMode(.alwaysTemplate), for: .normal)
        starButton.layer.cornerRadius = KMAUIConstants.shared.KMACornerRadius
        starButton.clipsToBounds = true
        
        // No selection required
        selectionStyle = .none
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setupCell() {
        progressView.progress = Double(itemPerformance.progress) / 100
        KMAUIUtilities.shared.setupColor(ring: progressView)
        progressLabel.text = "\(itemPerformance.progress)%"
        itemNameLabel.text = itemPerformance.itemName
        itemStatLabel.text = itemPerformance.itemStat
        
        if itemPerformance.isOn {
            starButton.tintColor = UIColor.white
            starButton.backgroundColor = KMAUIConstants.shared.KMABlueColor
        } else {
            starButton.tintColor = KMAUIConstants.shared.KMAUIGreyLineColor
            starButton.backgroundColor = KMAUIConstants.shared.KMAUIGreyProgressColor
        }
    }
}
