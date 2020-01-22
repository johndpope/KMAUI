//
//  KMAUIRegionPerformanceTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 21.01.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit
import MKRingProgressView

public class KMAUIRegionPerformanceTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet public weak var regionPerformanceView: RingProgressView!
    @IBOutlet public weak var regionPerformanceLabel: UILabel!
    @IBOutlet public weak var regionNameLabel: UILabel!
    @IBOutlet public weak var detailsStackView: UIStackView!
    @IBOutlet public weak var avgCostLabel: UILabel!
    @IBOutlet public weak var marketSizeLabel: UILabel!
    @IBOutlet public weak var vacancyRateLabel: UILabel!

    // MARK: - Variables
    public var regionPerformance = KMARegionPerformance()
    
    // MARK: - Cell methods
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // No selection required
        selectionStyle = .none
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setupCell() {
        regionNameLabel.text = regionPerformance.regionName
        progressPercentLabel.text = "\(regionPerformance.performance)%"
        regionPerformanceView.progress = 0
        
        UIView.animate(withDuration: 1.0) {
            self.regionPerformanceView.progress = Double(self.regionPerformance.performance) / 100
        }
        
        if !regionPerformance.stats.isEmpty {
            avgCostLabel.text = regionPerformance.stats[0]
            marketSizeLabel.text = regionPerformance.stats[1]
            vacancyRateLabel.text = regionPerformance.stats[2]
        }
    }
}

// MARK: - Region performance struct, stores the performance percent and region name

public struct KMARegionPerformance {
    public var regionName = ""
    public var performance = 0
    public var stats = [String]()
    
    public init() {
    }
    
    public init(regionName: String, performance: Int, stats: [String]) {
        self.regionName = regionName
        self.performance = performance
        self.stats = stats
    }
}

