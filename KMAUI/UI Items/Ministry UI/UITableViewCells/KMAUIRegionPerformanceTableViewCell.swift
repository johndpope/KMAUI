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
    @IBOutlet public weak var regionPerformanceLabel: KMAUIBoldTextLabel!
    @IBOutlet public weak var regionNameLabel: KMAUIBoldTextLabel!
    @IBOutlet public weak var detailsStackView: UIStackView!

    // MARK: - Variables
    public var regionPerformance = KMARegionPerformance()
    
    // MARK: - Cell methods
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Setup font size
        regionNameLabel.font = regionNameLabel.font.withSize(22)
        
        // No selection required
        selectionStyle = .none
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setupCell() {
        regionNameLabel.text = regionPerformance.regionName
        regionPerformanceLabel.text = "\(regionPerformance.performance)%"
        regionPerformanceView.progress = 0
        
        UIView.animate(withDuration: 1.0) {
            self.regionPerformanceView.progress = Double(self.regionPerformance.performance) / 100
        }
        
        if !regionPerformance.stats.isEmpty {
            setupStats()

            // Clear existing subviews
            for subview in detailsStackView.subviews {
                subview.removeFromSuperview()
            }
            
            for statItem in regionPerformance.stats {
                // Creating hte horizontal stack view
                let stackView = UIStackView()
                stackView.axis = NSLayoutConstraint.Axis.horizontal
                stackView.distribution = UIStackView.Distribution.fill
                stackView.alignment = UIStackView.Alignment.fill
                stackView.spacing = 8.0
                
                // Creating the title label
                let titleLabel = KMAUIRegularTextLabel()
                titleLabel.textAlignment = .left
                
                if let title = statItem["title"] {
                    titleLabel.text = title
                }
                
                titleLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .horizontal)
                stackView.addArrangedSubview(titleLabel)
                
                // Creating the text label
                let valueLabel = KMAUIBoldTextLabel()
                valueLabel.textAlignment = .right
                valueLabel.widthAnchor.constraint(equalToConstant: 60.0).isActive = true

                if let value = statItem["value"] {
                    valueLabel.text = value
                }
                
                valueLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 252), for: .horizontal)
                stackView.addArrangedSubview(valueLabel)
                
                detailsStackView.addArrangedSubview(stackView)
            }
        }
    }
    
    public func setupStats() {
        
    }
}

