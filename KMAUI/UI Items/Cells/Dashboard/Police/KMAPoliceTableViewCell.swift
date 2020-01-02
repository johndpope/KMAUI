//
//  KMAPoliceTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 28.12.2019.
//  Copyright © 2019 Stanislav Rastvorov. All rights reserved.
//

import UIKit

public class KMAPoliceTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet public weak var bgView: KMAUIRoundedCornersView!
    @IBOutlet public weak var logoImageView: UIImageView!
    @IBOutlet public weak var headerLabel: KMAUITitleLabel!
    @IBOutlet public weak var infoLabel: KMAUITextLabel!
    @IBOutlet public weak var rightArrowImageView: UIImageView!
    @IBOutlet public weak var rightArrowImageViewWidth: NSLayoutConstraint!
    @IBOutlet public weak var rightArrowImageViewRight: NSLayoutConstraint!
    @IBOutlet public weak var reviewButton: KMAUIButtonFilled!
    @IBOutlet weak var reviewButtonTop: NSLayoutConstraint!
    @IBOutlet public weak var reviewButtonHeight: NSLayoutConstraint!
    
    // MARK: - Variables
    public var policeObject = KMAPoliceNeighbourhood()
    public var logo = ""
    public var hasButton = false
    public var canHighlight = true
    public var crimeLoaded = false
    public var buttonPressedCallback: ((String) -> Void)?
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Setup the right arrow
        KMAUIUtilities.shared.setupArrow(imageView: rightArrowImageView)
        
        // Round corners for logo
        logoImageView.layer.borderColor = KMAUIConstants.shared.KMALineGray.cgColor
        logoImageView.layer.borderWidth = 1
        logoImageView.layer.cornerRadius = KMAUIConstants.shared.KMACornerRadius
        
        // No selection required
        selectionStyle = .none
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
        if highlight, canHighlight {
            bgView.backgroundColor = KMAUIConstants.shared.KMABrightBlueColor
            headerLabel.textColor = UIColor.white
            infoLabel.textColor = UIColor.white
            rightArrowImageView.tintColor = UIColor.white
        } else {
            bgView.backgroundColor = KMAUIConstants.shared.KMABackColor
            headerLabel.textColor = KMAUIConstants.shared.KMATitleColor
            infoLabel.textColor = KMAUIConstants.shared.KMATextColor
            rightArrowImageView.tintColor = KMAUIConstants.shared.KMATextGrayColor
        }
    }
    
    /**
     Setup Cell
     */
    
    public func setupCell() {
        headerLabel.text = "\(policeObject.forceId.capitalized.replacingOccurrences(of: "-", with: " ")) Police"
        infoLabel.text = "Review the crime data"
        
        // Library logo
        if !logo.isEmpty, let url = URL(string: logo) {
            logoImageView.kf.indicatorType = .activity
            logoImageView.kf.setImage(with: url)
        }
        
        if !canHighlight {
            rightArrowImageView.alpha = 0
            rightArrowImageViewWidth.constant = 0
            rightArrowImageViewRight.constant = 0
            
            if crimeLoaded {
                infoLabel.text = "Crime accidents nearby: \(policeObject.crimeArray.count)"
            }
        }
        
        if hasButton {
            reviewButton.alpha = 1
            reviewButtonTop.constant = 16
            reviewButtonHeight.constant = 44
        } else {
            reviewButton.alpha = 0
            reviewButtonTop.constant = 0
            reviewButtonHeight.constant = 0
        }
    }
    
    // MARK: - IBActions
    
    @IBAction public func reviewButtonPressed(_ sender: Any) {
        buttonPressedCallback?("pressed")
    }
}
