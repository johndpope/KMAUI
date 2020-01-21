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
    @IBOutlet public weak var itemTitleLabel: UILabel!
    @IBOutlet public weak var itemValueLabel: UILabel!
    @IBOutlet public weak var horizontalLineLabel: UIView!
    @IBOutlet public weak var communityProgressView: RingProgressView!
    @IBOutlet public weak var communityProgressLabel: UILabel!
    @IBOutlet public weak var serviceProgressView: RingProgressView!
    @IBOutlet public weak var serviceProgressLabel: UILabel!
    @IBOutlet public weak var securityProgressView: RingProgressView!
    @IBOutlet public weak var securityProgressLabel: UILabel!
    
    // MARK - Variables
    public var regionPerformance = KMARegionPerformance()
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
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
        itemValueLabel.text = regionPerformance.regionName
        progressPercentLabel.text = "\(regionPerformance.totalPerformance)%"
        
        // Effectivity
        communityProgressLabel.attributedText = KMAUIUtilities.shared.attributedText(text: "Community \(regionPerformance.performance[0])%", search: "\(regionPerformance.performance[0])%", fontSize: communityProgressLabel.font.pointSize)
        serviceProgressLabel.attributedText = KMAUIUtilities.shared.attributedText(text: "Service \(regionPerformance.performance[1])%", search: "\(regionPerformance.performance[1])%", fontSize: serviceProgressLabel.font.pointSize)
        securityProgressLabel.attributedText = KMAUIUtilities.shared.attributedText(text: "Security \(regionPerformance.performance[2])%", search: "\(regionPerformance.performance[2])%", fontSize: securityProgressLabel.font.pointSize)
        
        // Progress views
        UIView.animate(withDuration: 1.0) {
            self.totalProgressView.progress = Double(self.regionPerformance.totalPerformance) / 100
            self.communityProgressView.progress = Double(self.regionPerformance.performance[0]) / 100
            self.serviceProgressView.progress = Double(self.regionPerformance.performance[1]) / 100
            self.securityProgressView.progress = Double(self.regionPerformance.performance[2]) / 100
        }
    }
}

// MARK: - Region performance struct, stores the performance percent and region name

public struct KMARegionPerformance {
    public var regionName = ""
    public var totalPerformance = 0
    public var performance = [Int]()
    
    public init() {
    }
    
    public init(regionName: String, performance: [Int], totalPerformance: Int) {
        self.regionName = regionName
        self.performance = performance
        self.totalPerformance = totalPerformance
    }
}
