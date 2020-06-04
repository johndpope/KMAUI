//
//  KMAUISubLandTitleTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 08.04.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit

public class KMAUILotteryTitleTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet public weak var statusLabel: KMAUIBoldTextLabel!
    @IBOutlet public weak var titleLabel: KMAUIBoldTextLabel!
    @IBOutlet public weak var infoLabel: KMAUIRegularTextLabel!
    
    // MARK: - Variables
    public static let id = "KMAUILotteryTitleTableViewCell"
    public var lottery = KMAUILandPlanStruct() {
        didSet {
            setupCell()
        }
    }
    public var landCase = KMAUILandCaseStruct() {
        didSet {
            setupLandCase()
        }
    }

    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Status label
        statusLabel.layer.cornerRadius = 6
        statusLabel.clipsToBounds = true
        statusLabel.textColor = UIColor.white
        statusLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(12)
        
        // Label adjustments
        titleLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(28)
        titleLabel.textColor = UIColor.white
        infoLabel.font = KMAUIConstants.shared.KMAUIRegularFont.withSize(16)
        infoLabel.textColor = UIColor.white
        
        // No selection required
        selectionStyle = .none
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setupCell() {
        // Lottery status
        statusLabel.text = lottery.lotteryStatus.rawValue.lowercased().addGaps()
        statusLabel.backgroundColor = KMAUIUtilities.shared.lotteryColor(status: lottery.lotteryStatus)
        
        // Lottery name
        titleLabel.text = lottery.landName
        
        // Date formatter
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .short
        // Setup period label
        infoLabel.text = "\(dateFormatter.string(from: lottery.startDate)) – \(dateFormatter.string(from: lottery.endDate))"
    }
    
    public func setupLandCase() {
        if landCase.courtStatus.isEmpty {
            // Not submitted yet
            statusLabel.text = "awaiting submission".addGaps()
            statusLabel.backgroundColor = KMAUIConstants.shared.KMABrightBlueColor
            // Provide details
            titleLabel.text = "Prepare your submission"
            infoLabel.attributedText = KMAUIUtilities.shared.highlight(words: ["land location", "upload photos"], in: "Provide the information about the land location and upload photos to confirm the land ownership")
            infoLabel.setLineSpacing(lineSpacing: 1.2, lineHeightMultiple: 1.2)
        } else {
            // Title
            titleLabel.text = "Case #\(landCase.caseNumber)"
            // Not submitted yet
            statusLabel.text = landCase.courtStatus.addGaps()
            // in progress / approved / declined
            if landCase.courtStatus.lowercased() == "in progress" {
                statusLabel.backgroundColor = KMAUIConstants.shared.KMAUIYellowProgressColor
                infoLabel.attributedText = KMAUIUtilities.shared.highlight(words: ["received", "additional information"], in: "The land case application was received by the court, you can still provide an additional information")
            } else if landCase.courtStatus.lowercased() == "approved" {
                statusLabel.backgroundColor = KMAUIConstants.shared.KMAUIGreenProgressColor
                infoLabel.attributedText = KMAUIUtilities.shared.highlight(words: ["approved"], in: "Your land case was approved by the court, you can review the full details")
            } else if landCase.courtStatus.lowercased() == "declined" {
                statusLabel.backgroundColor = KMAUIConstants.shared.KMAUIRedProgressColor
                infoLabel.attributedText = KMAUIUtilities.shared.highlight(words: ["declined"], in: "Your land case was declined by the court, you can review the full details")
            }
        }
    }
}
