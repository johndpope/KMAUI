//
//  KMASubLandLoadingTableViewCell.swift
//  KMA EYES CITIZENS
//
//  Created by Stanislav Rastvorov on 08.04.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit

public class KMAUILoadingIndicatorTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet public weak var loadingView: UIActivityIndicatorView!
    @IBOutlet public weak var infoLabel: KMAUIRegularTextLabel!
    @IBOutlet public weak var infoLabelLeft: NSLayoutConstraint!
    
    // MARK: - Variables
    public static let id = "KMAUILoadingIndicatorTableViewCell"
    public var isLoading = false
    public var type = "" {
        didSet {
            setupCell()
        }
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Background color
        backgroundColor = KMAUIConstants.shared.KMAUIViewBgColorReverse
        
        // Loading view color
        loadingView.color = KMAUIConstants.shared.KMAUIBlueDarkColorBarTint
        
        // Font for info label
        infoLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(16)
        
        // No selection required
        selectionStyle = .none
    }
    
    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    public func setupCell() {
        loadingView.startAnimating()
        
        if isLoading {
            loadingView.alpha = 1
            infoLabelLeft.constant = 16
        } else {
            loadingView.alpha = 0
            infoLabelLeft.constant = -37
        }
        
        if type == "lottery" {
            if isLoading {
                infoLabel.text = "Loading the lottery details..."
            } else {
                infoLabel.text = "Error loading the lottery details."
            }
        }
        if type == "subLand" {
            infoLabel.text = "Loading the Land details..."
        } else if type == "trespassCase" {
            infoLabel.text = "Loading the Trespass case details..."
        }
    }
}
