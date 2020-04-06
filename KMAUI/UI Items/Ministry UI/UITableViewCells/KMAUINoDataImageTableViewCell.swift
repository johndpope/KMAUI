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
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var titleLabel: KMAUIBoldTextLabel!
    @IBOutlet weak var infoLabel: KMAUIRegularTextLabel!
    
    // MARK: - Variables
    public static let id = "KMAUINoDataImageTableViewCell"
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
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setupCell() {
        logoImageView.image = KMAUIConstants.shared.lotteryPlaceholder
        
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
        }
    }
}
