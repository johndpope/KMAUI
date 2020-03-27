//
//  KMAPoliceDetailsTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 03.01.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit

public class KMAUIPoliceDetailsTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet public weak var logoImageView: UIImageView!
    @IBOutlet public weak var nameLabel: KMAUITitleLabel!
    @IBOutlet public weak var forceLabel: KMAUITextLabel!
    @IBOutlet public weak var notesLabel: KMAUITextLabel!
    @IBOutlet public weak var notesLabelTop: NSLayoutConstraint!
    @IBOutlet public weak var activityView: UIActivityIndicatorView!
    @IBOutlet public weak var reviewTeamButton: KMAUIButtonFilled!
    @IBOutlet public weak var reviewTeamButtonTop: NSLayoutConstraint!
    @IBOutlet public weak var reviewTeamButtonHeight: NSLayoutConstraint!
    
    // MARK: - Variables
    public var neighbourhood = KMAPoliceNeighbourhood()
    public var logo = ""
    public var detailsLoaded = false
    public var crimeLoaded = false
    public var teamLoaded = false
    public var buttonPressedCallback: ((String) -> Void)?
    
    // MARK: - Cell methods
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Round corners for logo
        logoImageView.layer.borderColor = KMAUIConstants.shared.KMAUIGreyLineColor.cgColor
        logoImageView.layer.borderWidth = 1
        logoImageView.layer.cornerRadius = KMAUIConstants.shared.KMACornerRadius
        
        // No selection required
        selectionStyle = .none
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setupCell() {
        if detailsLoaded {
            // Name
            nameLabel.text = neighbourhood.name
            
            // Force
            forceLabel.text = "\(neighbourhood.forceId.capitalized.replacingOccurrences(of: "-", with: " ")) Police"
            
            // Show image
            logoImageView.alpha = 1
            
            // Library logo
            if !logo.isEmpty, let url = URL(string: logo) {
                logoImageView.kf.indicatorType = .activity
                logoImageView.kf.setImage(with: url)
            }
            
            // Hide activity
            activityView.alpha = 0
        } else {
            // Name
            nameLabel.text = "\(neighbourhood.forceId.capitalized.replacingOccurrences(of: "-", with: " ")) Police"
            
            // Details
            forceLabel.text = "Loading details..."
            
            // Hide image
            logoImageView.alpha = 0
            
            // Show activity
            activityView.alpha = 1
            activityView.startAnimating()
        }
        
        if crimeLoaded {
            // Crimes count
            var crimesCount = "1 crime was"
            
            if neighbourhood.crimeArray.count != 1 {
                crimesCount = "\(neighbourhood.crimeArray.count) crimes were"
            }
            
            // Month
            var month = ""
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM"
            
            if !neighbourhood.crimeArray.isEmpty {
                let crime = neighbourhood.crimeArray[0]
                
                if !crime.month.isEmpty {
                    if let date = dateFormatter.date(from: crime.month) {
                        month = "In \(KMAUIUtilities.shared.formatStringMonth(date: date))"
                    }
                }
            }
            
            if !month.isEmpty {
                crimesCount = " " + crimesCount
            }
            
            notesLabel.text = month + crimesCount + " recorded in this neighbourhood."
            notesLabel.alpha = 1
            notesLabelTop.constant = 4
        } else {
            notesLabel.text = ""
            notesLabel.alpha = 0
            notesLabelTop.constant = 0
        }
        
        if teamLoaded {
            reviewTeamButton.alpha = 1
            reviewTeamButtonTop.constant = 8
            reviewTeamButtonHeight.constant = 44
        } else {
            reviewTeamButton.alpha = 0
            reviewTeamButtonTop.constant = 0
            reviewTeamButtonHeight.constant = 0
        }
    }
    @IBAction func reviewTeamButtonPressed(_ sender: Any) {
        buttonPressedCallback?("pressed")
    }
}
