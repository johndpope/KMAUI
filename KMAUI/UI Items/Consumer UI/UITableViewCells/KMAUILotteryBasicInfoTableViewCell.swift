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
    @IBOutlet public weak var statusLabelHeight: NSLayoutConstraint!
    @IBOutlet public weak var statusLabelBottom: NSLayoutConstraint!
    @IBOutlet public weak var titleLabel: KMAUIBoldTextLabel!
    @IBOutlet public weak var stackViewBg: UIView!
    @IBOutlet public weak var stackViewBgTop: NSLayoutConstraint!
    @IBOutlet public weak var stackView: UIStackView!
    @IBOutlet public weak var viewDetailsButton: UIButton!
    @IBOutlet public weak var viewDetailsButtonTop: NSLayoutConstraint!
    @IBOutlet public weak var viewDetailsButtonHeight: NSLayoutConstraint!
    @IBOutlet public weak var medalImageView: UIImageView!
    @IBOutlet public weak var medalImageViewHeight: NSLayoutConstraint!
    @IBOutlet public weak var medalImageViewBottom: NSLayoutConstraint!
    // Action buttons
    @IBOutlet public weak var declineButton: UIButton!
    @IBOutlet public weak var acceptLandButton: UIButton!
    
    // MARK: - Variables
    public var isExpanded = false
    public static let id = "KMAUILotteryBasicInfoTableViewCell"
    public var selectedSegment = 0
    public var lottery = KMAUILandPlanStruct() {
        didSet {
            setupLottery()
        }
    }
    public var subLand = KMAUISubLandStruct() {
        didSet {
            setupSubLand()
        }
    }
    public var canHighlight = false
    public var buttonPressed: ((String) -> Void)?
    
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
        
        // declineButton
        declineButton.backgroundColor = KMAUIConstants.shared.KMAUILightButtonColor
        declineButton.titleLabel?.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(17)
        declineButton.setTitleColor(KMAUIConstants.shared.KMAUITextColor, for: .normal)
        declineButton.layer.cornerRadius = 17
        declineButton.clipsToBounds = true
        
        // acceptLandButton
        acceptLandButton.backgroundColor = KMAUIConstants.shared.KMATurquoiseColor
        acceptLandButton.titleLabel?.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(17)
        acceptLandButton.setTitleColor(UIColor.white, for: .normal)
        acceptLandButton.layer.cornerRadius = 17
        acceptLandButton.clipsToBounds = true
        
        // Setup medal image view
        medalImageView.image = KMAUIConstants.shared.medalIcon.withRenderingMode(.alwaysTemplate)
        medalImageView.tintColor = KMAUIConstants.shared.KMAUITextColor
        
        // Stack view
        stackView.backgroundColor = UIColor.clear
        stackViewBg.backgroundColor = UIColor.clear
        
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
    
    public func setupLottery() {
        // Hide all action buttons
        acceptLandButton.alpha = 0
        declineButton.alpha = 0
        viewDetailsButton.alpha = 0
        
        // No need to highlight the data
        canHighlight = false
        
        // Show status, hide medal
        setupView(mode: "status")
        viewDetailsButton.setTitle("View details", for: .normal)
        viewDetailsButton.setTitleColor(KMAUIConstants.shared.KMAUITextColor, for: .normal)
        
        // Setup data rows
        let rows = [KMAUIRowData(rowName: "Sub lands", rowValue: "\(lottery.subLandsCount)")] // , KMAUIRowData(rowName: "Citizens", rowValue: "\(lottery.queueCount)")]
        
        // Check the segment
        if selectedSegment == 1, lottery.lotteryStatus == .approvedToStart {
            // Only show details for approvedToStart and finished lotteries on the segment 1
            showViewDetails(mode: "details")
        } else {
            // Hide view details
            hideViewDetails()
        }
        
        // Lottery status
        statusLabel.text = lottery.lotteryStatus.rawValue.addGaps()
        statusLabel.backgroundColor = KMAUIUtilities.shared.lotteryColor(status: lottery.lotteryStatus)
        
        // Lottery name
        titleLabel.text = lottery.landName
        
        // Stack view
        setupStackView(rows: rows)
    }
    
    public func setupSubLand() {
        // Hide all action buttons
        acceptLandButton.alpha = 0
        declineButton.alpha = 0
        viewDetailsButton.alpha = 0
        
        // Can highlight the sub land to review the details screen
        canHighlight = true
        
        // Hide status, show medal
        setupView(mode: "medal")
        
        // Setup sub land name
        titleLabel.text = subLand.landPlanName
        
        // Stack view
        let rows = [KMAUIRowData(rowName: "Land ID", rowValue: "\(subLand.subLandId)"), KMAUIRowData(rowName: "Region", rowValue: "\(subLand.regionName)"), KMAUIRowData(rowName: "Land percent", rowValue: "\(Int(subLand.subLandPercent * 100)) %")]
        setupStackView(rows: rows)

        // Setup buttons
        if subLand.status == "pending" {
            showViewDetails(mode: "action")
            declineButton.setTitle("Decline", for: .normal)
            acceptLandButton.setTitle("Accept land", for: .normal)
        } else {
            showViewDetails(mode: "details")
            viewDetailsButton.isUserInteractionEnabled = false
            viewDetailsButton.setTitle(subLand.status.capitalized, for: .normal)
            
            if subLand.status == "declined" {
                viewDetailsButton.setTitleColor(KMAUIConstants.shared.KMAUIRedProgressColor, for: .normal)
            } else if subLand.status == "awaiting payment" {
                viewDetailsButton.setTitleColor(KMAUIConstants.shared.KMABrightBlueColor, for: .normal)
            } else if subLand.status == "confirmed" {
                viewDetailsButton.setTitleColor(KMAUIConstants.shared.KMAUIGreenProgressColor, for: .normal)
            }
        }
    }
    
    public func setupView(mode: String) {
        if mode == "status" {
            statusLabel.alpha = 1
            statusLabelHeight.constant = 26
            statusLabelBottom.constant = 12
            medalImageView.alpha = 0
            medalImageViewHeight.constant = 0
            medalImageViewBottom.constant = 0
        } else if mode == "medal" {
            statusLabel.alpha = 0
            statusLabelHeight.constant = 0
            statusLabelBottom.constant = 0
            medalImageView.alpha = 1
            medalImageViewHeight.constant = 68
            medalImageViewBottom.constant = 12
        }
    }
    
    /**
     Hide view details
     */
    
    func hideViewDetails() {
        viewDetailsButton.alpha = 0
        viewDetailsButtonTop.constant = 0
        viewDetailsButtonHeight.constant = 0
        // Hide buttons
        declineButton.alpha = 0
        acceptLandButton.alpha = 0
    }
    
    /**
     Show view details
     */
    
    func showViewDetails(mode: String) {
        viewDetailsButtonTop.constant = 24
        viewDetailsButtonHeight.constant = 34
        
        declineButton.isUserInteractionEnabled = true
        acceptLandButton.isUserInteractionEnabled = true
        viewDetailsButton.isUserInteractionEnabled = true
        
        if mode == "details" {
            viewDetailsButton.alpha = 1
            declineButton.alpha = 0
            acceptLandButton.alpha = 0
        } else if mode == "action" {
            viewDetailsButton.alpha = 0
            declineButton.alpha = 1
            acceptLandButton.alpha = 1
        }
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

    // MARK: - IBActions
    
    @IBAction func declineButtonPressed(_ sender: Any) {
        buttonPressed?("decline")
    }
    
    @IBAction func acceptLandButtonPressed(_ sender: Any) {
        buttonPressed?("acceptLand")
    }
    
    @IBAction func viewDetailsButtonPressed(_ sender: Any) {
        buttonPressed?("viewDetails")
    }
}
