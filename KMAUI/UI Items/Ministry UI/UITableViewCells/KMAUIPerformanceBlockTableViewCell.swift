//
//  KMAUIPerformanceBlockTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 22.01.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit
import MKRingProgressView

public class KMAUIPerformanceBlockTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet public weak var bgView: KMAUIRoundedCornersView!
    @IBOutlet public weak var bgViewTop: NSLayoutConstraint!
    @IBOutlet public weak var progressView: RingProgressView!
    @IBOutlet public weak var progressLabel: KMAUIBoldTextLabel!
    @IBOutlet public weak var itemNameLabel: UILabel!
    @IBOutlet public weak var itemStatLabel: KMAUIRegularTextLabel!
    @IBOutlet public weak var itemStatLabelWidth: NSLayoutConstraint!
    @IBOutlet public weak var itemStatLabelLeft: NSLayoutConstraint!
    @IBOutlet public weak var starButton: UIButton!
    @IBOutlet public weak var arrowIndicator: UIImageView!
    @IBOutlet public weak var lineView: UIView!
    @IBOutlet public weak var lineViewTop1: NSLayoutConstraint!
    @IBOutlet public weak var lineViewTop2: NSLayoutConstraint!
    @IBOutlet public weak var detailsStackView: UIStackView!
    @IBOutlet public weak var detailsStackViewTop: NSLayoutConstraint!
    @IBOutlet public weak var detailsStackBgView: UIView!
    
    // MARK: - Variables
    public var hasStat = false
    public var itemPerformance = KMAUIItemPerformance()
    public var isExpandable = false
    public var isFirst = false
    public var isExpanded = false {
        didSet {
            setupCell()
        }
    }
    public var isOnCallback: ((Bool) -> Void)?
    public static let id = "KMAUIPerformanceBlockTableViewCell"
    
    // MARK: - Cell methods
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
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
        if highlight {
            bgView.backgroundColor = KMAUIConstants.shared.KMAUIMainBgColor
            arrowIndicator.tintColor = UIColor.white
            arrowIndicator.backgroundColor = KMAUIConstants.shared.KMAUIBlueDarkColor
        } else {
            bgView.backgroundColor = KMAUIConstants.shared.KMAUIViewBgColor
            arrowIndicator.tintColor = KMAUIConstants.shared.KMAUIGreyLineColor
                        starButton.backgroundColor = KMAUIConstants.shared.KMAProgressGray
        }
    }
    
    public func setupCell() {
        if isFirst {
            bgViewTop.constant = 12
        } else {
            bgViewTop.constant = 0
        }
        
        if !itemPerformance.performanceArray.isEmpty {
            var progress = 0
            
            for item in itemPerformance.performanceArray {
                progress += item
            }
            
            // Progress view
            progressView.progress = Double(progress) / (Double(itemPerformance.performanceArray.count) * 100)
            KMAUIUtilities.shared.setupColor(ring: progressView)
            
            // Progress label
            progressLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(12)
            progressLabel.text = "\(progress / itemPerformance.performanceArray.count)%"
        }

        // Item name label
        itemNameLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(16)
        itemNameLabel.text = itemPerformance.itemName
        
        if hasStat {
            // Item stat label
            var costValue = "+\(itemPerformance.avgCost)%"
            
            if itemPerformance.avgCost < 0 {
                costValue = "\(itemPerformance.avgCost)%"
            }
            
            itemStatLabel.attributedText = KMAUIUtilities.shared.attributedText(text: "avg.cost \(costValue)", search: costValue, fontSize: KMAUIConstants.shared.KMAUIBoldFont.pointSize, noColor: true)
            itemStatLabelWidth.constant = 56
            itemStatLabelLeft.constant = 4
        } else {
            itemStatLabel.text = ""
            itemStatLabelWidth.constant = 0
            itemStatLabelLeft.constant = 0
        }

        // Star button
        starButton.setTitle("", for: .normal)
        starButton.setImage(KMAUIConstants.shared.starIcon.withRenderingMode(.alwaysTemplate), for: .normal)
        starButton.layer.cornerRadius = KMAUIConstants.shared.KMACornerRadius
        starButton.clipsToBounds = true
        
        // Arrow indicator
        
        setupStarTint()
        
        if isExpanded {
            showDetailsStackView()
        } else {
            hideDetailsStackView()
        }
    }
    
    /**
     Setup tint for image
     */
    
    public func setupStarTint() {
        if itemPerformance.isOn {
            starButton.tintColor = KMAUIConstants.shared.KMAUIYellowProgressColor // UIColor.white
            //            starButton.backgroundColor = KMAUIConstants.shared.KMAUIBlueDarkColor
        } else {
            starButton.tintColor = KMAUIConstants.shared.KMAUIGreyLineColor
            //            starButton.backgroundColor = KMAUIConstants.shared.KMAProgressGray
        }
    }
    
    /**
     Show the detailsStackView
     */
    
    public func showDetailsStackView() {
        // Remove subviews
        for subview in detailsStackView.subviews {
            detailsStackView.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
        
        // Prepare the rows
        for (index, progress) in itemPerformance.performanceArray.enumerated() {
            let itemView = UIStackView()
            itemView.axis = .horizontal
            itemView.distribution = UIStackView.Distribution.fill
            itemView.alignment = UIStackView.Alignment.fill
            itemView.spacing = 4
            
            // Progress view
            let progressBgView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 28))
            progressBgView.widthAnchor.constraint(equalToConstant: 12).isActive = true
            progressBgView.heightAnchor.constraint(equalToConstant: 28).isActive = true
            progressBgView.backgroundColor = UIColor.clear
            // Progress view
            let progressView = RingProgressView(frame: CGRect(x: 0, y: 9, width: 12, height: 12))
            progressView.backgroundRingColor = KMAUIConstants.shared.KMAUIGreyProgressColor
            progressView.ringWidth = 2
            progressView.hidesRingForZeroProgress = false
            progressView.backgroundColor = UIColor.clear
            progressView.progress = Double(progress) / 100
            KMAUIUtilities.shared.setupColor(ring: progressView)
            
            progressBgView.addSubview(progressView)
            itemView.addArrangedSubview(progressBgView)
            
            // Row name label
            let rowNameLabel = KMAUIRegularTextLabel()
            rowNameLabel.textAlignment = .left
            rowNameLabel.text = KMAUIConstants.shared.performanceTitles[index]
            rowNameLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .horizontal)
            itemView.addArrangedSubview(rowNameLabel)
            // rowNameLabel.leadingAnchor.constraint(equalTo: itemView.leadingAnchor, constant: 0).isActive = true
            
            // Row value label
            let rowValueLabel = KMAUIBoldTextLabel()
            rowValueLabel.textAlignment = .right
            rowValueLabel.text = "\(progress)%"
            rowValueLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 252), for: .horizontal)
            itemView.addArrangedSubview(rowValueLabel)
                        
            detailsStackView.addArrangedSubview(itemView)
            itemView.leadingAnchor.constraint(equalTo: detailsStackView.leadingAnchor, constant: 0).isActive = true
        }
        
        lineView.alpha = 0.1
        lineViewTop1.constant = 16
        lineViewTop2.constant = 16
        
        detailsStackView.alpha = 1
        detailsStackViewTop.constant = 8
        
        arrowIndicator.image = KMAUIConstants.shared.arrowUpIndicator.withRenderingMode(.alwaysTemplate)
    }
    
    /**
     Hide the detailsStackView
     */
    
    public func hideDetailsStackView() {
        // Remove subviews
        for subview in detailsStackView.subviews {
            detailsStackView.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
        
        lineView.alpha = 0
        lineViewTop1.constant = 8
        lineViewTop2.constant = 8
        
        detailsStackView.alpha = 0
        detailsStackViewTop.constant = 0
        
        if isExpandable {
            arrowIndicator.image = KMAUIConstants.shared.arrowDownIndicator.withRenderingMode(.alwaysTemplate)
        } else {
            arrowIndicator.image = KMAUIConstants.shared.arrowIndicator.withRenderingMode(.alwaysTemplate)
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func starButtonPressed(_ sender: Any) {
        itemPerformance.isOn = !itemPerformance.isOn
        setupStarTint()
        isOnCallback?(itemPerformance.isOn)
    }
}
