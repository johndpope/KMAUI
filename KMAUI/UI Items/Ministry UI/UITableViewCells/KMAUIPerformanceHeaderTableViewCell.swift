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
    @IBOutlet public weak var bgView: KMAUIRoundedCornersView!
    @IBOutlet public weak var totalProgressView: RingProgressView!
    @IBOutlet public weak var progressPercentLabel: UILabel!
    @IBOutlet public weak var itemTitleLabel: KMAUIRegularTextLabel!
    @IBOutlet public weak var itemValueLabel: KMAUIBoldTextLabel!
    @IBOutlet public weak var communityProgressView: RingProgressView!
    @IBOutlet public weak var communityProgressLabel: KMAUIRegularTextLabel!
    @IBOutlet public weak var serviceProgressView: RingProgressView!
    @IBOutlet public weak var serviceProgressLabel: KMAUIRegularTextLabel!
    @IBOutlet public weak var securityProgressView: RingProgressView!
    @IBOutlet public weak var securityProgressLabel: KMAUIRegularTextLabel!
    @IBOutlet public weak var stackViewBgView: UIView!
    @IBOutlet public weak var stackView: UIStackView!
    @IBOutlet public weak var detailsStackView: UIStackView!
    
    // MARK - Variables
    public var canHighlight = false
    public var performanceStruct = KMAPerformanceStruct() {
        didSet {
            self.setupCell()
        }
    }
    public static let id = "KMAUIPerformanceHeaderTableViewCell"
    
    // MARK: - Cell methods
    
    override public func awakeFromNib() {
        super.awakeFromNib()

        // Setup the font size
        itemValueLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(22)
        communityProgressLabel.font = KMAUIConstants.shared.KMAUIRegularFont.withSize(12)
        serviceProgressLabel.font = KMAUIConstants.shared.KMAUIRegularFont.withSize(12)
        securityProgressLabel.font = KMAUIConstants.shared.KMAUIRegularFont.withSize(12)
        
        // Stack view background color and corners
        stackViewBgView.backgroundColor = KMAUIConstants.shared.KMAUIMainBgColor
        stackViewBgView.layer.cornerRadius = 22
        stackViewBgView.clipsToBounds = true
        
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
            bgView.backgroundColor = KMAUIConstants.shared.KMAUIMainBgColor
        } else {
            bgView.backgroundColor = KMAUIConstants.shared.KMAUIViewBgColor
        }
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
            let labelArray = [communityProgressLabel, serviceProgressLabel, securityProgressLabel]
            let performanceViewArray = [communityProgressView, serviceProgressView, securityProgressView]
            
            for (index, performace) in performanceStruct.performanceArray.enumerated() {
                // Increment the total performance
                totalPerformance += performace
                // Setup the data for label and progress view
                if let label = labelArray[index], let progressView = performanceViewArray[index] {
                    label.attributedText = KMAUIUtilities.shared.attributedText(text: "\(KMAUIConstants.shared.performanceTitles[index]) \(performace)%", search: "\(performace)%", fontSize: label.font.pointSize, noColor: true)
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
        
        // Clear existing subviews
        for subview in detailsStackView.subviews {
            subview.removeFromSuperview()
        }

        for statItem in performanceStruct.rows {
            // Creating hte horizontal stack view
            let stackView = UIStackView()
            stackView.axis = NSLayoutConstraint.Axis.horizontal
            stackView.distribution = UIStackView.Distribution.fill
            stackView.alignment = UIStackView.Alignment.fill
            stackView.spacing = 8
            
            // Creating the title label
            let titleLabel = KMAUIRegularTextLabel()
            titleLabel.textAlignment = .left
            titleLabel.text = statItem.rowName
            titleLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .horizontal)
            stackView.addArrangedSubview(titleLabel)
            
            // Creating the text label
            let valueLabel = KMAUIBoldTextLabel()
            valueLabel.textAlignment = .right
            valueLabel.widthAnchor.constraint(equalToConstant: 60.0).isActive = true
            valueLabel.text = statItem.rowValue
            valueLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 252), for: .horizontal)
            stackView.addArrangedSubview(valueLabel)
            
            detailsStackView.addArrangedSubview(stackView)
        }
    }
}

