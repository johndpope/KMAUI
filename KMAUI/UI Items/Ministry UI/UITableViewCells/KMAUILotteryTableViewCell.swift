//
//  KMAUILotteryTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 11.03.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit
import Kingfisher

public class KMAUILotteryTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet public weak var bgView: KMAUIRoundedCornersView!
    @IBOutlet public weak var bgViewLeft: NSLayoutConstraint!
    @IBOutlet public weak var bgViewRight: NSLayoutConstraint!
    @IBOutlet public weak var bgViewTop: NSLayoutConstraint!
    @IBOutlet public weak var bgViewBottom: NSLayoutConstraint!
    @IBOutlet public weak var isActiveImageView: UIImageView!
    @IBOutlet public weak var lotteryNameLabel: KMAUIBoldTextLabel!
    @IBOutlet public weak var lotteryNameLabelLeft: NSLayoutConstraint!
    @IBOutlet public weak var subLandsLabel: UILabel!
    @IBOutlet weak var subLandsLabelTop: NSLayoutConstraint!
    @IBOutlet public weak var subLandsLabelLeft: NSLayoutConstraint!
    @IBOutlet public weak var subLandsCountLabel: UILabel!
    @IBOutlet public weak var statusView: UIView!
    @IBOutlet public weak var statusViewWidth: NSLayoutConstraint! // default: 7
    @IBOutlet public weak var statusViewRight: NSLayoutConstraint! // default: 6
    @IBOutlet public weak var statusLabel: KMAUIRegularTextLabel!
    @IBOutlet public weak var statusLabelHeight: NSLayoutConstraint!
    @IBOutlet public weak var statusLabelBottom: NSLayoutConstraint!
    @IBOutlet public weak var profileImageView: UIImageView!
    @IBOutlet public weak var stackView: UIStackView!
    @IBOutlet public var stackViewTop: NSLayoutConstraint!
    @IBOutlet public weak var stackViewBottom: NSLayoutConstraint!
    
    // MARK: - Variables
    public var type = "lottery"
    public var citizen = KMAPerson()
    public var subLand = KMAUISubLandStruct()
    public var lottery = KMAUILandPlanStruct()
    public var isFirst = false
    public var highlightActive = false
    public var noBg = false
    public var isActive = false {
        didSet {
            setupCell()
        }
    }

    // MARK: - Variables
    public static let id = "KMAUILotteryTableViewCell"
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // bgView shadow
        bgView.layer.shadowOffset = CGSize(width: 0, height: 4)
        bgView.layer.shadowRadius = 4
        
        // Fonts
        lotteryNameLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(16)
        subLandsLabel.font = KMAUIConstants.shared.KMAUIRegularFont.withSize(16)
        subLandsCountLabel.font = KMAUIConstants.shared.KMAUIRegularFont.withSize(16)
        
        // isActive imageView
        isActiveImageView.image = KMAUIConstants.shared.arrowIndicator.withRenderingMode(.alwaysTemplate)
        isActiveImageView.layer.cornerRadius = 4
        isActiveImageView.clipsToBounds = true
        
        // Default state - disabled
        isActiveImageView.tintColor = KMAUIConstants.shared.KMAUIGreyLineColor
        isActiveImageView.backgroundColor = KMAUIConstants.shared.KMAProgressGray
        
        // Status view
        statusView.layer.cornerRadius = 3.5
        statusView.clipsToBounds = true
        
        // Set the profileImageView
        profileImageView.tintColor = KMAUIConstants.shared.KMATextGrayColor.withAlphaComponent(0.5)
        profileImageView.backgroundColor = KMAUIConstants.shared.KMAUIMainBgColor
        profileImageView.layer.cornerRadius = 22
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.kf.indicatorType = .activity
        profileImageView.clipsToBounds = true
        
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
        if noBg {
            isActiveImageView.tintColor = KMAUIConstants.shared.KMAUIGreyLineColor
            isActiveImageView.backgroundColor = UIColor.clear
            
            if highlight {
                bgView.backgroundColor = KMAUIConstants.shared.KMAUIMainBgColorReverse
            } else {
                bgView.backgroundColor = KMAUIConstants.shared.KMAUIViewBgColorReverse
            }
        } else if highlight {
            bgView.backgroundColor = KMAUIConstants.shared.KMAUIMainBgColor
            
            if highlightActive {
                isActiveImageView.tintColor = UIColor.white
                isActiveImageView.backgroundColor = KMAUIConstants.shared.KMAUIArrowSelectedColor
            }
        } else {
            bgView.backgroundColor = KMAUIConstants.shared.KMAUIViewBgColor
            
            if highlightActive {
                isActiveImageView.tintColor = KMAUIConstants.shared.KMAUIGreyLineColor
                isActiveImageView.backgroundColor = KMAUIConstants.shared.KMAProgressGray
            }
        }
    }
    
    public func setupCell() {
        // Top offset
        if isFirst {
            bgViewTop.constant = 8
        } else {
            bgViewTop.constant = 0
        }
        
        // Is active status
        if isActive {
            isActiveImageView.tintColor = UIColor.white
            isActiveImageView.backgroundColor = KMAUIConstants.shared.KMAUIArrowSelectedColor
        } else {
            isActiveImageView.tintColor = KMAUIConstants.shared.KMAUIGreyLineColor
            isActiveImageView.backgroundColor = KMAUIConstants.shared.KMAProgressGray
        }
        
        if type == "lottery" {
            setupLottery()
        } else if type == "subLand" {
            setupSubLand()
        } else if type == "citizen" {
            setupCitizen()
        }
    }
    
    public func setupLottery() {
        // Basic details
        lotteryNameLabel.text = lottery.landName
        subLandsLabel.text = "Sub Lands"
        subLandsCountLabel.text = "\(lottery.totalCount)"
        
        // Lottery status
        statusLabel.text = lottery.lotteryStatus.rawValue
        statusView.backgroundColor = KMAUIUtilities.shared.lotteryColor(status: lottery.lotteryStatus)
        
        statusView.alpha = 1
        statusViewWidth.constant = 7
        statusViewRight.constant = 6
        
        statusLabel.font = KMAUIConstants.shared.KMAUIRegularFont
        statusLabel.textColor = KMAUIConstants.shared.KMAUITextColor
        statusLabel.backgroundColor = UIColor.clear
        statusLabel.layer.borderWidth = 0
        
        lotteryNameLabelLeft.constant = 16
        subLandsLabelLeft.constant = 16
        
        profileImageView.alpha = 0
        
        setupStackView()
        subLandsLabelTop.constant = 24
    }
    
    public func setupSubLand() {
        statusLabel.text = "     " + subLand.subLandType + "     "
        lotteryNameLabel.text = "Land ID \(subLand.subLandId)"
        subLandsLabel.text = "Land Plan \(subLand.landPlanName)"
        subLandsCountLabel.text = ""
        
        statusView.alpha = 0
        statusViewWidth.constant = 0
        statusViewRight.constant = 0
        
        statusLabel.font = KMAUIConstants.shared.KMAUIBoldFont
        statusLabel.textColor = KMAUIUtilities.shared.getTextColor(subLandType: subLand.subLandType)
        statusLabel.backgroundColor = KMAUIUtilities.shared.getColor(subLandType: subLand.subLandType)
        statusLabel.layer.borderColor = KMAUIConstants.shared.KMAUIGreyLineColor.withAlphaComponent(0.2).cgColor
        statusLabel.layer.borderWidth = 1
        statusLabel.layer.cornerRadius = 23 / 2
        statusLabel.clipsToBounds = true
        
        lotteryNameLabelLeft.constant = 16
        subLandsLabelLeft.constant = 16
        
        profileImageView.alpha = 0
        
        if noBg {
            backgroundColor = KMAUIConstants.shared.KMAUIViewBgColorReverse
            bgView.layer.shadowRadius = 0
            bgViewLeft.constant = 0
            bgViewRight.constant = 0
            bgViewTop.constant = 0
            bgViewBottom.constant = 0
            bgView.layer.cornerRadius = 0
            statusLabelHeight.constant = 0
            statusLabelBottom.constant = 0
        }
        
        stackView.alpha = 0
        stackViewTop.constant = 0
        subLandsLabelTop.constant = 6
    }
    
    public func setupCitizen() {
        statusLabel.text = "Verified user"
        lotteryNameLabel.text = citizen.fullName
        subLandsLabel.text = "National ID: \(citizen.objectId.uppercased())"
        subLandsCountLabel.text = ""
        
        statusView.alpha = 0
        statusViewWidth.constant = 0
        statusViewRight.constant = 0
        
        statusLabel.font = KMAUIConstants.shared.KMAUIBoldFont
        statusLabel.textColor = KMAUIConstants.shared.KMAUIGreenProgressColor
        statusLabel.backgroundColor = UIColor.clear
        statusLabel.layer.borderWidth = 0
        
        lotteryNameLabelLeft.constant = 72
        subLandsLabelLeft.constant = 72
        
        profileImageView.alpha = 1
        // Setup placeholder image
        profileImageView.image = KMAUIConstants.shared.profilePlaceholder.withRenderingMode(.alwaysTemplate)
        // Load profile image
        if let url = URL(string: citizen.profileImage) {
            profileImageView.kf.setImage(with: url)
        }
        
        stackView.alpha = 0
        stackViewTop.constant = 0
        subLandsLabelTop.constant = 6
    }
    
    /**
     Show the stackView
     */
    
    public func setupStackView() {
        stackView.alpha = 1
        stackViewTop.constant = 8
        
        // Remove subviews
        for subview in stackView.subviews {
            stackView.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
        
        var rows = [KMAUIRowData]()
        // Adding the createdAt and updatedAt
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        rows.append(KMAUIRowData(rowName: "Lottery created", rowValue: dateFormatter.string(from: lottery.createdAt)))
        // If created != updated
        if lottery.createdAt != lottery.updatedAt {
            rows.append(KMAUIRowData(rowName: "Latest update", rowValue: dateFormatter.string(from: lottery.updatedAt)))
        }
        
        // Prepare the rows
        for (index, row) in rows.enumerated() {
            if index == 0 {
                // Line view
                let lineView = UIView()
                lineView.backgroundColor = KMAUIConstants.shared.KMAUIGreyLineColor.withAlphaComponent(0.2)
                lineView.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
                stackView.addArrangedSubview(lineView)
                lineView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 0).isActive = true
                lineView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 0).isActive = true
            }
            
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
            rowNameLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 252), for: .horizontal)
            rowNameLabel.widthAnchor.constraint(equalToConstant: 120.0).isActive = true
            itemView.addArrangedSubview(rowNameLabel)
            
            // Row value label
            let rowValueLabel = KMAUIBoldTextLabel()
            rowValueLabel.font = KMAUIConstants.shared.KMAUIRegularFont.withSize(16)
            rowValueLabel.textAlignment = .right
            rowValueLabel.text = row.rowValue
            rowValueLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .horizontal)
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
        stackView.alpha = 1
    }
}

