//
//  KMAPoliceDetailsTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 03.01.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit

public class KMAPoliceDetailsTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet public weak var logoImageView: UIImageView!
    @IBOutlet public weak var nameLabel: KMAUITitleLabel!
    @IBOutlet public weak var forceLabel: KMAUITextLabel!
    @IBOutlet public weak var notesLabel: KMAUITextLabel!
    
    // MARK: - Variables
    public var neighbourhood = KMAPoliceNeighbourhood()
    public var logo = ""
    public var crimeLoaded = false
    
    // MARK: - Cell methods
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Round corners for logo
        logoImageView.layer.borderColor = KMAUIConstants.shared.KMALineGray.cgColor
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
        // Library logo
        if !logo.isEmpty, let url = URL(string: logo) {
            logoImageView.kf.indicatorType = .activity
            logoImageView.kf.setImage(with: url)
        }
        
        // Name
        nameLabel.text = neighbourhood.name
        
        // Force
        forceLabel.text = "\(neighbourhood.forceId.capitalized.replacingOccurrences(of: "-", with: " ")) Police"
        
        if crimeLoaded {
            // Crimes count
            var crimesCount = "1 crime"
            
            if neighbourhood.crimeArray.count != 1 {
                crimesCount = "\(neighbourhood.crimeArray.count) crimes"
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
            
            notesLabel.text = month + crimesCount + " were recorded in this neighbourhood."
        } else {
            notesLabel.text = ""
        }
    }
}
