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
    @IBOutlet weak var titleLabelTop: NSLayoutConstraint!
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
        // Update font
        infoLabel.font = KMAUIConstants.shared.KMAUIRegularFont.withSize(14)
        // Setup the land case status
        if landCase.courtStatus.isEmpty {
            // Not submitted yet
            statusLabel.text = ""
            statusLabel.backgroundColor = KMAUIConstants.shared.KMABrightBlueColor
            statusLabel.alpha = 0
            // Provide details
            titleLabel.text = "Submission preparing"
            titleLabelTop.constant = -8
            infoLabel.attributedText = KMAUIUtilities.shared.highlight(words: ["land location", "upload photos"], in: "Prepare the information about the land location and upload photos to confirm the land ownership ")
            // Add the spacing for the infoLabel
            infoLabel.setLineSpacing(lineSpacing: 1.2, lineHeightMultiple: 1.2, alignment: .left)
        } else {
            // Title
            titleLabel.text = "Case #\(landCase.caseNumber)"
            titleLabelTop.constant = 16
            // Not submitted yet
            statusLabel.text = landCase.courtStatus.addGaps()
            statusLabel.alpha = 1
            // in progress / approved / declined
            if landCase.courtStatus.lowercased() == "in progress" {
                statusLabel.backgroundColor = KMAUIConstants.shared.KMAUIYellowProgressColor
            } else if landCase.courtStatus.lowercased() == "approved" {
                statusLabel.backgroundColor = KMAUIConstants.shared.KMAUIGreenProgressColor
            } else if landCase.courtStatus.lowercased() == "declined" {
                statusLabel.backgroundColor = KMAUIConstants.shared.KMAUIRedProgressColor
            }
            
            // Date formatter for info label: show the court date
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = .none
            dateFormatter.dateStyle = .medium
            infoLabel.text = "Court date: " + dateFormatter.string(from: landCase.date)
        }
    }
}
