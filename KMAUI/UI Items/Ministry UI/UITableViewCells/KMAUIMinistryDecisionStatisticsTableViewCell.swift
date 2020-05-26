//
//  KMAUIJudgeTableViewCell.swift
//  KMA
//
//  Created by Stanislav Rastvorov on 22.05.2020.
//  Copyright © 2020 Office Mac. All rights reserved.
//

import UIKit
import Kingfisher
import MKRingProgressView

public class KMAUIMinistryDecisionStatisticsTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet public weak var bgView: KMAUIRoundedCornersView!
    @IBOutlet public weak var logoImageView: UIImageView!
    @IBOutlet public weak var titleLabel: UILabel!
    @IBOutlet public weak var approvedCountLabel: UILabel!
    @IBOutlet public weak var rejectedCountLabel: UILabel!
    @IBOutlet public weak var approvedLineView: UIView!
    @IBOutlet public weak var rejectedLineView: UIView!
    @IBOutlet public weak var statsViewWidth: NSLayoutConstraint!
    @IBOutlet public weak var approvedWidth: NSLayoutConstraint!
    @IBOutlet public weak var rejectedWidth: NSLayoutConstraint!
    @IBOutlet public weak var progressView: RingProgressView!
    @IBOutlet public weak var progressLabel: KMAUIBoldTextLabel!
    
    // MARK: - Variables
    public static let id = "KMAUIMinistryDecisionStatisticsTableViewCell"
    public var decisions = [KMAUIMinistryDecisionStruct]() {
        didSet {
            setupCell()
        }
    }

    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Background view
        backgroundColor = KMAUIConstants.shared.KMAUIViewBgColorReverse
        
        // Larger shadow for bgView
        bgView.layer.shadowOffset = CGSize(width: 0, height: 7)
        bgView.layer.shadowRadius = 8
        
        // Name label
        titleLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(20)

        // Approved count label
        approvedCountLabel.font = KMAUIConstants.shared.KMAUIBoldFont
        
        // Rejected count label
        rejectedCountLabel.font = KMAUIConstants.shared.KMAUIBoldFont
                
        // No selection required
        selectionStyle = .none
    }
    
    public func setupCell() {
        var width: CGFloat = 320
        
        if UIDevice.current.orientation.isLandscape {
            print("Landscape")
        } else {
            print("Portrait")
            width = 200
        }
        
        // Name label
        titleLabel.text = "Statistics"
        // Citizen image
        logoImageView.alpha = 0
        // Approved vs Rejected
        var approvedCount = 0
        var rejectedCount = 0
        
        for decision in decisions {
            if decision.ministryStatus == "approved" {
                approvedCount += 1
            } else {
                rejectedCount += 1
            }
        }
                
        var approvedPercent: Double = 0
        var rejectedPercent: Double = 0
        
        statsViewWidth.constant = width
        approvedWidth.constant = width / 2 - 2
        rejectedWidth.constant = width / 2 - 2
        
        approvedLineView.layer.cornerRadius = 4
        rejectedLineView.layer.cornerRadius = 4
        
        if approvedCount > 0, rejectedCount > 0 {
            approvedPercent = Double(Int((Double(approvedCount) / Double(approvedCount + rejectedCount)) * 100)) / 100
            rejectedPercent = 1 - approvedPercent
            approvedLineView.alpha = 1
            rejectedLineView.alpha = 1
            
            if approvedPercent > 0.8 {
                approvedWidth.constant = (width - 2) * 0.85
                rejectedWidth.constant = width - 2 - approvedWidth.constant
            } else if rejectedPercent > 0.8 {
                rejectedWidth.constant = (width - 2) * 0.85
                approvedWidth.constant = width - 2 - rejectedWidth.constant
            } else {
                approvedWidth.constant = (width - 2) * CGFloat(approvedPercent)
                rejectedWidth.constant = width - 2 - approvedWidth.constant
            }
            
            // Corner radius
            approvedLineView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
            rejectedLineView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        } else if approvedPercent > 0 {
            approvedPercent = 1
            rejectedPercent = 0
            approvedLineView.alpha = 1
            rejectedLineView.alpha = 0
            approvedWidth.constant = width
            rejectedWidth.constant = 0
            approvedLineView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
        } else if rejectedCount > 0 {
            approvedPercent = 0
            rejectedPercent = 1
            approvedLineView.alpha = 0
            rejectedLineView.alpha = 1
            approvedWidth.constant = 0
            rejectedWidth.constant = width
            rejectedLineView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
        }

        approvedCountLabel.text = "\(Int(approvedPercent * 100))%"
        rejectedCountLabel.text = "\(Int(rejectedPercent * 100))%"
        
        progressView.progress = approvedPercent
        progressLabel.text = "\(Int(approvedPercent * 100))%"
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
