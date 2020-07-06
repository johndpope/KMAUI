//
//  KMAUINoDataImageTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 30.03.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit

public class KMAUINoDataImageTableViewCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var bgView: KMAUIRoundedCornersView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var titleLabel: KMAUIBoldTextLabel!
    @IBOutlet weak var infoLabel: KMAUIRegularTextLabel!
    
    // MARK: - Variables
    public static let id = "KMAUINoDataImageTableViewCell"
    public var isLoading = false
    public var mode = "" {
        didSet {
            setupCell()
        }
    }

    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // No selection required
        selectionStyle = .none
        
        // Placeholder view
        logoImageView.image = KMAUIConstants.shared.lotteryPlaceholder
        titleLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(20)
        infoLabel.font = KMAUIConstants.shared.KMAUIRegularFont.withSize(16)
        backgroundColor = UIColor.clear
        
        // Larger shadow for bgView
        bgView.layer.shadowOffset = CGSize(width: 0, height: 4)
        bgView.layer.shadowRadius = 12
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setupCell() {
        logoImageView.image = KMAUIConstants.shared.lotteryPlaceholder
        bgView.backgroundColor = UIColor.clear
        bgView.clipsToBounds = true
        
        if mode == "subLands" {
            titleLabel.text = "No Sub lands"
            infoLabel.text = "We have no Sub lands received in National land lotteries."
        } else if mode == "property" {
            titleLabel.text = "No property"
            infoLabel.text = "We have no property ownership documents to display."
        } else if mode == "documents" {
            titleLabel.text = "No documents"
            infoLabel.text = "We have no documents to display."
        } else if mode == "citizens" {
            titleLabel.text = "No citizens"
            infoLabel.text = "There are no country residents found for the area."
            logoImageView.image = KMAUIConstants.shared.citizensIcon
        } else if mode == "issues" {
            titleLabel.text = "No issues"
            infoLabel.text = "There are no issues found for the area."
        } else if mode == "video" {
            titleLabel.text = "No videos"
            infoLabel.text = "There are no videoes found for the area."
        } else if mode == "photo" {
            titleLabel.text = "No photos"
            infoLabel.text = "There are no photos found for the area."
        } else if mode == "notificationsLoading" {
            titleLabel.text = "Loading notifications"
            infoLabel.text = "We're preparing the notifications list for you."
        } else if mode == "notificationsEmpty" {
            titleLabel.text = "No notifications"
            infoLabel.text = "There are no notifications available for this Department."
        } else if mode == "notificationsSelect" {
            titleLabel.text = "Select notification"
            infoLabel.text = "Select the notification from the list to review the details."
        } else if mode == "notificationPreparing" {
            titleLabel.text = "Preparing notification"
            infoLabel.text = "We're loading the notification details."
        } else if mode == "courtStatus" {
            titleLabel.text = "No court decision"
            infoLabel.text = "Please wait for a judge to prepare the final decision for this case."
        } else if mode.contains("landCases") {
            let type = mode.replacingOccurrences(of: "landCases", with: "")
            titleLabel.text = "No land cases"
            infoLabel.text = "We have no \"\(type)\" land cases to display."
        } else if mode == "waitingDepartment" {
            titleLabel.text = "Department decision pending"
            infoLabel.text = "We're waiting for the Department decision in order to provide the full details for the Judge before the Court decision can be received."
        } else if mode == "citizensSearch" {
             titleLabel.text = "Search for citizens"
             infoLabel.text = "Please search for citizens by Full Name of or National ID"
             logoImageView.image = KMAUIConstants.shared.citizensIcon
        } else if mode == "citizensNotFound" {
            titleLabel.text = "No citizens found"
            infoLabel.text = "Please adjust your search request"
            logoImageView.image = KMAUIConstants.shared.citizensIcon
        } else if mode == "citizensSearching" {
            titleLabel.text = "Searching..."
            infoLabel.text = "Please wait for the search results"
            logoImageView.image = KMAUIConstants.shared.citizensIcon
        } else if mode == "bundles" {
            if isLoading {
                titleLabel.text = "Loading..."
                infoLabel.text = "Please wait for the bundles to be loaded."
                logoImageView.image = KMAUIConstants.shared.citizensIcon
            } else {
                titleLabel.text = "No bundles"
                infoLabel.text = "Unfortunately we weren't able to load any bundles."
                logoImageView.image = KMAUIConstants.shared.rejectionIcon
            }
            bgView.backgroundColor = KMAUIConstants.shared.KMAUIViewBgColorReverse
            bgView.clipsToBounds = false
        } else if mode == "polygones" {
            if isLoading {
                titleLabel.text = "Loading..."
                infoLabel.text = "Please wait for the polygones to be loaded."
                logoImageView.image = KMAUIConstants.shared.citizensIcon
            } else {
                titleLabel.text = "No bundles"
                infoLabel.text = "Unfortunately we weren't able to load any bundles."
                logoImageView.image = KMAUIConstants.shared.rejectionIcon
            }
            bgView.backgroundColor = KMAUIConstants.shared.KMAUIViewBgColorReverse
            bgView.clipsToBounds = false
        }
        // Add the spacing for the infoLabel
        infoLabel.setLineSpacing(lineSpacing: 1.2, lineHeightMultiple: 1.2, alignment: .center)
    }
}
