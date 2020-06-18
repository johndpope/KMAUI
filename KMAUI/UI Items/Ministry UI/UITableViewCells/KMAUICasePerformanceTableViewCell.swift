//
//  KMAUICasePerformanceTableViewCell.swift
//  KMA
//
//  Created by Stanislav Rastvorov on 22.05.2020.
//  Copyright © 2020 Office Mac. All rights reserved.
//

import UIKit
import MKRingProgressView

public class KMAUICasePerformanceTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet public weak var bgView: UIView!
    @IBOutlet public weak var performanceLabel: UILabel!
    @IBOutlet public weak var progressView: RingProgressView!
    @IBOutlet public weak var progressLabel: KMAUIBoldTextLabel!
    @IBOutlet public weak var regionLabel: UILabel!
    @IBOutlet public weak var divideLineView: UIView!
    @IBOutlet public weak var resolvedLabel: UILabel!
    @IBOutlet public weak var resolvedValueLabel: UILabel!
    
    // MARK: - Variables
    public static let id = "KMAUICasePerformanceTableViewCell"
    public var stats = KMAUIRowData() {
        didSet{
            setupCell()
        }
    }

    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Background view
        backgroundColor = KMAUIConstants.shared.KMAUIMainBgColor
        
        // BgView
        bgView.layer.cornerRadius = 8
        bgView.layer.borderWidth = 2
        bgView.layer.borderColor = KMAUIConstants.shared.KMAUILightBorderColor.cgColor
        bgView.clipsToBounds = true
        
        // Performance title
        performanceLabel.font = UIFont.systemFont(ofSize: 14, weight: .light)
        performanceLabel.textColor = KMAUIConstants.shared.KMAUITextColor
        
        // Progress label
        progressLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(14)
        
        // Region label
        regionLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(22)
        
        // Divide line
        divideLineView.backgroundColor = KMAUIConstants.shared.KMAUIGreyLineColor.withAlphaComponent(0.2)
        
        // Resolved label
        resolvedLabel.font = KMAUIConstants.shared.KMAUIRegularFont.withSize(16)
        
        // Resolved value label
        resolvedValueLabel.font = KMAUIConstants.shared.KMAUIRegularFont.withSize(16)
        
        // No selection required
        selectionStyle = .none
    }
    
    public func setupCell() {
        // Setup stats data
        regionLabel.text = stats.rowName
        progressLabel.text = "\(Int(stats.progress * 100))%"
        progressView.progress = stats.progress
        resolvedLabel.text = "Approved"
        
        if !stats.rowValue.isEmpty {
            resolvedLabel.text = stats.rowValue
        }
        
        resolvedValueLabel.text = "\(stats.value)/\(stats.count)"
        // Adjust the font size for 100% situation
        if stats.progress == 1 {
            progressLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(12)
        } else {
            progressLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(14)
        }
    }
    
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        // Your custom borderColor
        bgView.layer.borderColor = KMAUIConstants.shared.KMAUILightBorderColor.cgColor
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
