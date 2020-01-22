//
//  KMAUITotalPerformanceTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 21.01.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit
import MKRingProgressView

public class KMAUITotalPerformanceTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet public weak var totalProgressView: RingProgressView!
    @IBOutlet public weak var progressPercentLabel: UILabel!
    @IBOutlet public weak var itemTitleLabel: KMAUIRegularTextLabel!
    @IBOutlet public weak var itemValueLabel: KMAUIBoldTextLabel!
    @IBOutlet public weak var horizontalLineLabel: UIView!
    @IBOutlet public weak var communityProgressView: RingProgressView!
    @IBOutlet public weak var communityProgressLabel: KMAUIRegularTextLabel!
    @IBOutlet public weak var serviceProgressView: RingProgressView!
    @IBOutlet public weak var serviceProgressLabel: KMAUIRegularTextLabel!
    @IBOutlet public weak var securityProgressView: RingProgressView!
    @IBOutlet public weak var securityProgressLabel: KMAUIRegularTextLabel!
    @IBOutlet public weak var clearButton: UIButton!
    
    // MARK - Variables
    public var countryPerformance = KMACountryPerformance()
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Setup the clear button to have an image on the right
        clearButton.semanticContentAttribute = UIApplication.shared
            .userInterfaceLayoutDirection == .rightToLeft ? .forceLeftToRight : .forceRightToLeft
        
        // Setup the font size
        itemValueLabel.font = itemValueLabel.font.withSize(22)
        communityProgressLabel.font = communityProgressLabel.font.withSize(12)
        serviceProgressLabel.font = serviceProgressLabel.font.withSize(12)
        securityProgressLabel.font = securityProgressLabel.font.withSize(12)
        
        // No selection required
        selectionStyle = .none
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    /**
     Setting the up the UI items
     */
    
    public func setupCell() {
        // Region details
        itemValueLabel.text = countryPerformance.countryName

        if !countryPerformance.performance.isEmpty {
            var totalPerformance = 0
            
            for performanceItem in countryPerformance.performance {
                totalPerformance += performanceItem
            }
            
            totalPerformance /= countryPerformance.performance.count
            progressPercentLabel.text = "\(totalPerformance)%"
            
            // Effectivity
            communityProgressLabel.attributedText = KMAUIUtilities.shared.attributedText(text: "Community \(countryPerformance.performance[0])%", search: "\(countryPerformance.performance[0])%", fontSize: communityProgressLabel.font.pointSize, noColor: true)
            serviceProgressLabel.attributedText = KMAUIUtilities.shared.attributedText(text: "Service \(countryPerformance.performance[1])%", search: "\(countryPerformance.performance[1])%", fontSize: serviceProgressLabel.font.pointSize, noColor: true)
            securityProgressLabel.attributedText = KMAUIUtilities.shared.attributedText(text: "Security \(countryPerformance.performance[2])%", search: "\(countryPerformance.performance[2])%", fontSize: securityProgressLabel.font.pointSize, noColor: true)
            
            // Progress views
            self.totalProgressView.progress = 0
            self.communityProgressView.progress = 0
            self.serviceProgressView.progress = 0
            self.securityProgressView.progress = 0
            
            UIView.animate(withDuration: 1.0) {
                self.totalProgressView.progress = Double(totalPerformance) / 100
                self.communityProgressView.progress = Double(self.countryPerformance.performance[0]) / 100
                self.serviceProgressView.progress = Double(self.countryPerformance.performance[1]) / 100
                self.securityProgressView.progress = Double(self.countryPerformance.performance[2]) / 100
            }
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func clearButtonPressed(_ sender: Any) {
    }
}

