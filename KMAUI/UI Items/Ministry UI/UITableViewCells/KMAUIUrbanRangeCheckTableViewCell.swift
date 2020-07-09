//
//  KMAUIUrbanRangeCheckTableViewCell.swift
//  KMA
//
//  Created by Stanislav Rastvorov on 25.06.2020.
//  Copyright © 2020 Office Mac. All rights reserved.
//

import UIKit

public class KMAUIUrbanRangeCheckTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet public weak var bgView: KMAUIRoundedCornersView!
    @IBOutlet public weak var titleLabel: KMAUIBoldTextLabel!
    @IBOutlet public weak var descriptionLabel: KMAUIRegularTextLabel!
    @IBOutlet public weak var outsideButton: UIButton!
    @IBOutlet public weak var insideButton: UIButton!
    @IBOutlet public weak var locationLabel: KMAUIBoldTextLabel!
    
    // MARK: - Variables
    public static let id = "KMAUIUrbanRangeCheckTableViewCell"
    public var actionCallback: ((Bool) -> Void)?
    public var trespassCase = KMAUITrespassCaseStruct() {
        didSet {
            setupCell()
        }
    }

    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Background virew
        backgroundColor = KMAUIConstants.shared.KMAUIViewBgColorReverse
        
        // Larger shadow for bgView
        bgView.backgroundColor = KMAUIConstants.shared.KMAUIViewBgColor
        bgView.layer.shadowOffset = CGSize(width: 0, height: 4)
        bgView.layer.shadowRadius = 12
        
        // Title label
        titleLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(20)
        
        // Description label
        descriptionLabel.font = KMAUIConstants.shared.KMAUIRegularFont.withSize(16)
        
        // Approve button
        insideButton.titleLabel?.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(16)
        insideButton.setTitleColor(UIColor.white, for: .normal)
        insideButton.backgroundColor = KMAUIConstants.shared.KMATurquoiseColor
        insideButton.layer.cornerRadius = 8
        insideButton.clipsToBounds = true
        insideButton.titleLabel?.textAlignment = .center
        
        // Decline button
        outsideButton.titleLabel?.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(16)
        outsideButton.setTitleColor(KMAUIConstants.shared.KMAUITextColor, for: .normal) // UIColor.black
        outsideButton.backgroundColor = KMAUIConstants.shared.KMAUILightBorderColor
        outsideButton.layer.cornerRadius = 8
        outsideButton.clipsToBounds = true
        outsideButton.titleLabel?.textAlignment = .center
        
        // Decision label
        locationLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(16)
        locationLabel.textColor = KMAUIConstants.shared.KMAUITextColor
        locationLabel.backgroundColor = KMAUIConstants.shared.KMAUILightBorderColor
        locationLabel.layer.cornerRadius = 8
        locationLabel.clipsToBounds = true
        
        // No selection required
        selectionStyle = .none
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setupCell() {
        // Title label
        titleLabel.text = "Final decision"
        
        // Description label / Action buttons / Location label
        if trespassCase.caseStatus == "Awaiting decision" {
            descriptionLabel.text = "Please confirm if the land is Inside the Urban Range or Outside of it."
            outsideButton.alpha = 1
            insideButton.alpha = 1
            locationLabel.alpha = 0
            insideButton.setTitle("Inside the Urban Range", for: .normal)
            outsideButton.setTitle("Outside the Urban Range", for: .normal)
        } else if trespassCase.caseStatus == "Outside the Urban Range" {
            descriptionLabel.text = "As the Land location is Outside of the Urban Range the Trespass case can't be Resolved by the Department of Urban Planning."
            outsideButton.alpha = 0
            insideButton.alpha = 0
            locationLabel.alpha = 1
            locationLabel.text = "Land is Outside the Urban Range"
            locationLabel.textColor = KMAUIConstants.shared.KMAUIRedProgressColor
        } else if trespassCase.caseStatus == "Awaiting Municipality decision" {
            descriptionLabel.text = "The Land location is Inside the Urban Range.\nIn order to finalize the Trespass case please select one of the provided decisions."
            outsideButton.alpha = 1
            insideButton.alpha = 1
            locationLabel.alpha = 0
            insideButton.setTitle("Create a new Land case", for: .normal)
            outsideButton.setTitle("Immediate demolition", for: .normal)
        } else if trespassCase.caseStatus == "Resolved" {
            // Immediate demolition
            if trespassCase.trespassDecision == "demolition" {
                descriptionLabel.text = "The Department of Urban Planning has decided to initiate an Immediate demolition of the Illegal building on the Land area."
                outsideButton.alpha = 0
                insideButton.alpha = 0
                locationLabel.alpha = 1
                locationLabel.text = "Immediate demolition of Illegal building"
                locationLabel.textColor = KMAUIConstants.shared.KMAUIRedProgressColor
            }
            // New Land case created
            if trespassCase.trespassDecision.starts(with: "Land case") {
                descriptionLabel.text = "The Department of Urban Planning has decided to initiate the creation of the new Land case for the Trespass citizen. Please review the details on the corresponding app section."
                outsideButton.alpha = 0
                insideButton.alpha = 0
                locationLabel.alpha = 1
                locationLabel.text = "The new \(trespassCase.trespassDecision) created"
                locationLabel.textColor = KMAUIConstants.shared.KMAUIRedProgressColor
            }
        }
        
        // Update the description label line offset
        descriptionLabel.setLineSpacing(lineSpacing: 1.2, lineHeightMultiple: 1.2, alignment: .left)
    }
    
    // MARK: - IBOutlets
    
    @IBAction public func outsideButtonPressed(_ sender: Any) {
        outsideButton.alpha = 0.75
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            self.outsideButton.alpha = 1.0
        }
        
        actionCallback?(false)
    }
    
    @IBAction public func insideButtonPressed(_ sender: Any) {
        insideButton.alpha = 0.75
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            self.insideButton.alpha = 1.0
        }
        
        actionCallback?(true)
    }
}
