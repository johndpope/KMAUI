//
//  KMAUILandCaseRegionTableViewCell.swift
//  KMA
//
//  Created by Stanislav Rastvorov on 27.05.2020.
//  Copyright © 2020 Office Mac. All rights reserved.
//

import UIKit
import MKRingProgressView

public class KMAUILandCaseRegionTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet public weak var bgView: KMAUIRoundedCornersView!
    @IBOutlet public weak var progressView: RingProgressView!
    @IBOutlet public weak var progressLabel: KMAUIBoldTextLabel!
    @IBOutlet public weak var regionNameLabel: KMAUIBoldTextLabel!
    @IBOutlet public weak var approvedCountLabel: KMAUIRegularTextLabel!
    @IBOutlet public weak var rightArrowImageView: UIImageView!
    
    // MARK: - Variables
    public static let id = "KMAUILandCaseRegionTableViewCell"
    public var region = KMAMapAreaStruct()
    public var isActive = false {
        didSet {
            setupCell()
        }
    }

    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Background color
        backgroundColor = KMAUIConstants.shared.KMAUIMainBgColor
        
        // BgView
        bgView.backgroundColor = KMAUIConstants.shared.KMAUIViewBgColor
        bgView.clipsToBounds = true
        
        // Region name label
        regionNameLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(18)
        
        // Progress label
        progressLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(12)
        
        // Setup the right arrow
        rightArrowImageView.image = KMAUIConstants.shared.disclosureArrow.withRenderingMode(.alwaysTemplate)
        rightArrowImageView.layer.cornerRadius = 4
        rightArrowImageView.clipsToBounds = true

        // No selection required
        selectionStyle = .none
    }
    
    public func setupCell() {
        regionNameLabel.text = region.nameE
        approvedCountLabel.text = "Approved – \(region.approvedLandCasesCount)"
        
        if region.landCasesCount == 0 {
            progressView.progress = 0
            progressLabel.text = "0%"
        } else {
            let progress = Double(Int(Double(region.approvedLandCasesCount) / Double(region.landCasesCount) * 100)) / 100
            
            progressView.progress = progress
            progressLabel.text = "\(Int(progress * 100))%"
        }
    }
    
    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        setupColors(highlight: selected)
    }
    
    override public func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        setupColors(highlight: highlighted)
    }
    
    public func setupColors(highlight: Bool) {
        if highlight {
            bgView.backgroundColor = KMAUIConstants.shared.KMAUIMainBgColor
            rightArrowImageView.tintColor = UIColor.white
            rightArrowImageView.backgroundColor = KMAUIConstants.shared.KMAUIBlackTitleButton
        } else {
            bgView.backgroundColor = KMAUIConstants.shared.KMAUIViewBgColor
            rightArrowImageView.tintColor = KMAUIConstants.shared.KMAUIGreyLineColor
            rightArrowImageView.backgroundColor = KMAUIConstants.shared.KMAProgressGray
            
            if isActive {
                rightArrowImageView.tintColor = UIColor.white
                rightArrowImageView.backgroundColor = KMAUIConstants.shared.KMAUIBlackTitleButton
            }
        }
    }
}
