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
    @IBOutlet public weak var itemNameLabel: UILabel!
    @IBOutlet public weak var itemStatLabel: KMAUIRegularTextLabel!
    @IBOutlet public weak var starButton: UIButton!
    @IBOutlet public weak var arrowIndicator: UIImageView!
    
    // MARK: - Variables
    public var itemPerformance = KMAUIItemPerformance() {
        didSet {
            setupCell()
        }
    }
    public var isOnCallback: ((Bool) -> Void)?
    public static let id = "KMAUIPerformanceBlockTableViewCell"
    
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
        // Progress view
        progressView.progress = Double(itemPerformance.progress) / 100
        KMAUIUtilities.shared.setupColor(ring: progressView)
        
        // Progress label
        progressLabel.text = "\(itemPerformance.progress)%"
        
        // Item name label
        itemNameLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(16)
        itemNameLabel.text = itemPerformance.itemName
        
        // Item stat label
        var costValue = "+\(itemPerformance.avgCost)%"
        
        if itemPerformance.avgCost < 0 {
            costValue = "-\(itemPerformance.avgCost)%"
        }
        
        itemStatLabel.attributedText = KMAUIUtilities.shared.attributedText(text: "avg.cost \(costValue)", search: costValue, fontSize: KMAUIConstants.shared.KMAUIBoldFont.pointSize, noColor: true)
        
        // Star button
        starButton.setTitle("", for: .normal)
        starButton.setImage(KMAUIConstants.shared.starIcon.withRenderingMode(.alwaysTemplate), for: .normal)
        starButton.layer.cornerRadius = KMAUIConstants.shared.KMACornerRadius
        starButton.clipsToBounds = true
        
        setupStarTint()
    }
    
    /**
     Setup tint for image
     */
    
    public func setupStarTint() {
        if itemPerformance.isOn {
            starButton.tintColor = UIColor.white
            starButton.backgroundColor = KMAUIConstants.shared.KMAUIBlueDarkColor
        } else {
            starButton.tintColor = KMAUIConstants.shared.KMAUIGreyLineColor
            starButton.backgroundColor = KMAUIConstants.shared.KMAProgressGray
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func starButtonPressed(_ sender: Any) {
        itemPerformance.isOn = !itemPerformance.isOn
        setupStarTint()
        isOnCallback?(itemPerformance.isOn)
    }
}
