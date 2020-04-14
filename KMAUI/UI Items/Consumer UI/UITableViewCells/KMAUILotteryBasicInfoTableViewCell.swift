//
//  KMAUILotteryBasicInfoTableViewCell.swift
//  KMA EYES CITIZENS
//
//  Created by Stanislav Rastvorov on 10.04.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit

public class KMAUILotteryBasicInfoTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet public weak var bgView: KMAUIRoundedCornersView!
    @IBOutlet public weak var statusLabel: KMAUIBoldTextLabel!
    @IBOutlet public weak var titleLabel: KMAUIBoldTextLabel!
    @IBOutlet public weak var stackViewBg: UIView!
    @IBOutlet public weak var stackViewBgTop: NSLayoutConstraint!
    @IBOutlet public weak var stackView: UIStackView!
    @IBOutlet public weak var viewDetailsButton: UIButton!
    @IBOutlet public weak var viewDetailsButtonTop: NSLayoutConstraint!
    @IBOutlet public weak var viewDetailsButtonHeight: NSLayoutConstraint!
    
    // MARK: - Variables
    public var isExpanded = false
    public static let id = "KMAUILotteryBasicInfoTableViewCell1"
    public var selectedSegment = 0
    public var lottery = KMAUILandPlanStruct() {
        didSet {
            setupCell()
        }
    }
    public var canHighlight = false
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Background
        contentView.backgroundColor = KMAUIConstants.shared.KMAUIMainBgColor
        bgView.backgroundColor = KMAUIConstants.shared.KMAUIViewBgColor
        // Larger shadow for bgView
        bgView.layer.shadowOffset = CGSize(width: 0, height: 0)
        bgView.layer.shadowRadius = 4
        
        // Status label
        statusLabel.layer.cornerRadius = 6
        statusLabel.clipsToBounds = true
        statusLabel.textColor = UIColor.white
        statusLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(12)
        
        // Title label
        titleLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(24)
        
        // viewDetails button
        viewDetailsButton.backgroundColor = KMAUIConstants.shared.KMAUILightButtonColor
        viewDetailsButton.titleLabel?.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(17)
        viewDetailsButton.setTitleColor(KMAUIConstants.shared.KMAUITextColor, for: .normal)
        viewDetailsButton.layer.cornerRadius = 17
        viewDetailsButton.clipsToBounds = true
        
        // No standard selection requried
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
    
    public func setupCell() {
        // Hide view details
        hideViewDetails()
        // Setup data rows
        var rows = [KMAUIRowData]()
        // Check the segment
        if selectedSegment == 0 {
            // Sub lands count, citizens count
            rows = [KMAUIRowData(rowName: "Sub lands", rowValue: "\(lottery.subLandsCount)"), KMAUIRowData(rowName: "Citizens", rowValue: "\(lottery.queueCount)")]
        } else if selectedSegment == 1 {
            // Sub lands count, citizens count, View details button
            rows = [KMAUIRowData(rowName: "Sub lands", rowValue: "\(lottery.subLandsCount)"), KMAUIRowData(rowName: "Citizens", rowValue: "\(lottery.queueCount)")]
            if lottery.lotteryStatus == "Approved to start" {
                showViewDetails()
            }
        } else if selectedSegment == 2 {
            // Medal on top, land size percent, land id, address, decline or accept land / declined
        }
        
        // Lottery status
        statusLabel.text = lottery.lotteryStatus.addGaps()
        statusLabel.backgroundColor = KMAUIUtilities.shared.lotteryColor(status: lottery.lotteryStatus)
        
        // Lottery name
        titleLabel.text = lottery.landName
        
        // Stack view
        stackViewBg.backgroundColor = UIColor.clear
        setupStackView(rows: rows)
    }
    
    /**
     Hide view details
     */
    
    func hideViewDetails() {
        viewDetailsButton.alpha = 0
        viewDetailsButtonTop.constant = 0
        viewDetailsButtonHeight.constant = 0
    }
    
    /**
     Show view details
     */
    
    func showViewDetails() {
        viewDetailsButton.alpha = 1
        viewDetailsButtonTop.constant = 24
        viewDetailsButtonHeight.constant = 34
    }
    
    /**
     Show the stackView
     */
    
    public func setupStackView(rows: [KMAUIRowData]) {
        // Remove subviews
        for subview in stackView.subviews {
            stackView.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
        
        // Prepare the rows
        for (index, row) in rows.enumerated() {
            let itemView = UIStackView()
            itemView.axis = .horizontal
            itemView.distribution = UIStackView.Distribution.fill
            itemView.alignment = UIStackView.Alignment.fill
            itemView.spacing = 4
            
            // Row name label
            let rowNameLabel = KMAUIRegularTextLabel()
            rowNameLabel.font = KMAUIConstants.shared.KMAUIRegularFont.withSize(16)
            rowNameLabel.textAlignment = .left
            rowNameLabel.text = row.rowName
            rowNameLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .horizontal)
            itemView.addArrangedSubview(rowNameLabel)
            
            // Row value label
            let rowValueLabel = KMAUIBoldTextLabel()
            rowValueLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(16)
            rowValueLabel.textAlignment = .right
            rowValueLabel.text = row.rowValue
            rowValueLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 252), for: .horizontal)
            itemView.addArrangedSubview(rowValueLabel)
            
            stackView.addArrangedSubview(itemView)
            itemView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 0).isActive = true
            
            if index < rows.count - 1 {
                // Line view
                let lineView = UIView()
                lineView.backgroundColor = KMAUIConstants.shared.KMAUIGreyLineColor.withAlphaComponent(0.2)
                lineView.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
                stackView.addArrangedSubview(lineView)
                lineView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 0).isActive = true
                lineView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 0).isActive = true
            }
        }
        stackViewBg.alpha = 1
        stackViewBgTop.constant = 16
    }
}
