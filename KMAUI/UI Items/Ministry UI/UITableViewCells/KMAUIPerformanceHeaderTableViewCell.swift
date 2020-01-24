//
//  KMAUITotalPerformanceTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 21.01.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit
import MKRingProgressView

public class KMAUIPerformanceHeaderTableViewCell: UITableViewCell {
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
    
    // MARK - Variables
    public var performanceStruct = KMAPerformanceStruct() {
        didSet {
            self.setupCell()
        }
    }
    
    // MARK: - Cell methods
    
    override public func awakeFromNib() {
        super.awakeFromNib()

        // Setup the font size
        itemValueLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(22)
        communityProgressLabel.font = KMAUIConstants.shared.KMAUIRegularFont.withSize(12)
        serviceProgressLabel.font = KMAUIConstants.shared.KMAUIRegularFont.withSize(12)
        securityProgressLabel.font = KMAUIConstants.shared.KMAUIRegularFont.withSize(12)
        
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
        // Item details
        itemTitleLabel.text = performanceStruct.itemTitle
        itemValueLabel.text = performanceStruct.itemName
        
        // Total performance (average from the items) Community, Service and Security for an item
        
        if performanceStruct.performanceArray.count == 3 {
            var totalPerformance = 0
            let performanceTitles = ["Community", "Service", "Security"]
            let labelArray = [communityProgressLabel, serviceProgressLabel, securityProgressLabel]
            let performanceViewArray = [communityProgressView, serviceProgressView, securityProgressView]
            
            for (index, performace) in performanceStruct.performanceArray.enumerated() {
                // Increment the total performance
                totalPerformance += performace
                // Setup the data for label and progress view
                if let label = labelArray[index], let progressView = performanceViewArray[index] {
                    label.attributedText = KMAUIUtilities.shared.attributedText(text: "\(performanceTitles[index]) \(performace)%", search: "\(performace)%", fontSize: label.font.pointSize, noColor: true)
                    progressView.progress = Double(performace) / 100
                    KMAUIUtilities.shared.setupColor(ring: progressView)
                }
            }
            
            // Setup the total performance
            totalPerformance /= performanceStruct.performanceArray.count
            progressPercentLabel.text = "\(totalPerformance)%"
            totalProgressView.progress = Double(totalPerformance) / 100
            KMAUIUtilities.shared.setupColor(ring: totalProgressView)
        }
    }
}

