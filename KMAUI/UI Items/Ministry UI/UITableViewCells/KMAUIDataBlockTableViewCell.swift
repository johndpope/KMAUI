//
//  KMAUIDataBlockTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 24.01.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit
import MKRingProgressView

public class KMAUIDataBlockTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet public weak var itemNameLabel: KMAUIBoldTextLabel!
    @IBOutlet public weak var itemHandleLabel: KMAUIRegularTextLabel!
    @IBOutlet public weak var itemHandleLableHeight: NSLayoutConstraint!
    @IBOutlet public weak var itemHandleLabelTop: NSLayoutConstraint!
    @IBOutlet public weak var lastUpdatedLabel: KMAUIRegularTextLabel!
    @IBOutlet public weak var stackView: UIStackView!
    
    // MARK: - Variables
    public var hasProgress = false
    public var dataItem = KMAUIDataItem() {
        didSet {
            setupCell()
        }
    }
    public var visibilityChangedCallback: ((Int, Bool) -> Void)?
    public var rowClickedCallback: ((Int) -> Void)?
    public static let id = "KMAUIDataBlockTableViewCell"
    public var rowViews = [UIView]()
    
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
        itemNameLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(18)
        itemNameLabel.text = dataItem.itemName
        
        if hasProgress {
            itemHandleLabel.text = ""
            lastUpdatedLabel.text = ""
            itemHandleLabelTop.constant = 0
            itemHandleLableHeight.constant = 0
        } else {
            itemHandleLabel.text = dataItem.itemHandle
            
            if dataItem.lastUpdate >= Date().addingTimeInterval(-60*60) {
                // During the last hour -> show time
                lastUpdatedLabel.text = "last update \(KMAUIUtilities.shared.dateTime(date: dataItem.lastUpdate, timeOnly: true))"
            } else {
                // Older then 1 hours ago -> show date
                lastUpdatedLabel.text = "last update \(KMAUIUtilities.shared.formatStringShort(date: dataItem.lastUpdate, numOnly: true))"
            }

            itemHandleLabelTop.constant = 8
            itemHandleLableHeight.constant = 22
        }
        
        // Clear existing subviews
        for subview in stackView.subviews {
            stackView.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
        
        // Clear the row views
        rowViews = [UIView]()
        
        // Prepare the rows
        for (index, row) in dataItem.rows.enumerated() {
            let itemView = UIStackView()
            itemView.axis = .horizontal
            itemView.distribution = UIStackView.Distribution.fill
            itemView.alignment = UIStackView.Alignment.center
            itemView.spacing = 8
            
            itemView.layoutMargins = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
            itemView.isLayoutMarginsRelativeArrangement = true

            if hasProgress {
                let progressBgView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 36))
                progressBgView.widthAnchor.constraint(equalToConstant: 12).isActive = true
                progressBgView.heightAnchor.constraint(equalToConstant: 36).isActive = true
                progressBgView.backgroundColor = UIColor.clear
                // Progress view
                let progressView = RingProgressView(frame: CGRect(x: 0, y: 12, width: 12, height: 12))
                progressView.backgroundRingColor = KMAUIConstants.shared.KMAUIGreyProgressColor
                progressView.ringWidth = 2
                progressView.hidesRingForZeroProgress = false
                progressView.backgroundColor = UIColor.clear
                progressView.progress = row.progress
                KMAUIUtilities.shared.setupColor(ring: progressView)
                
                progressBgView.addSubview(progressView)
                itemView.addArrangedSubview(progressBgView)
            }
            
            // Row name label
            let rowNameLabel = KMAUIRegularTextLabel()
            rowNameLabel.textAlignment = .left
            rowNameLabel.text = row.rowName
            rowNameLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .horizontal)
            itemView.addArrangedSubview(rowNameLabel)
            
            // Row value label
            let rowValueLabel = KMAUIBoldTextLabel()
            rowValueLabel.textAlignment = .right
            
            if !row.rowValue.isEmpty {
                rowValueLabel.text = row.rowValue
            } else {
                rowValueLabel.text = "-/-"
                
                if row.count != -1 {
                    rowValueLabel.text = String(format: "%d", row.count)
                }
            }
            
            rowValueLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 252), for: .horizontal)
            itemView.addArrangedSubview(rowValueLabel)
            
            // Visibility button
            let visibilityButton = UIButton()
            visibilityButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
            visibilityButton.heightAnchor.constraint(equalToConstant: 28).isActive = true
            visibilityButton.setTitle("", for: .normal)
            visibilityButton.setImage(KMAUIConstants.shared.eyeIcon.withRenderingMode(.alwaysTemplate), for: .normal)
            
            if row.visibility {
                visibilityButton.backgroundColor = KMAUIConstants.shared.KMAUIBlueDarkColor
                visibilityButton.tintColor = UIColor.white
            } else {
                visibilityButton.tintColor = KMAUIConstants.shared.KMAUIGreyLineColor
                visibilityButton.backgroundColor = KMAUIConstants.shared.KMAProgressGray
            }
            
            visibilityButton.layer.cornerRadius = KMAUIConstants.shared.KMACornerRadius
            visibilityButton.clipsToBounds = true
            visibilityButton.tag = index + 100
            visibilityButton.addTarget(self, action: #selector(visibilityButtonPressed(button:)), for: .touchUpInside)
            itemView.addArrangedSubview(visibilityButton)

            let rowView = UIView()
            rowView.backgroundColor = UIColor.clear
                            
            itemView.backgroundColor = UIColor.clear
            rowView.addSubview(itemView)
            rowView.tag = index + 300
            rowView.layer.cornerRadius = KMAUIConstants.shared.KMACornerRadius
            rowView.clipsToBounds = true
            KMAUIUtilities.shared.setConstaints(parentView: rowView, childView: itemView, left: 0, right: 0, top: 0, bottom: 0)
            
            let rowButton = UIButton()
            rowButton.setTitle("", for: .normal)
            rowButton.tag = index + 200
            rowButton.addTarget(self, action: #selector(rowButtonPressed(button:)), for: .touchUpInside)
            rowButton.addTarget(self, action: #selector(rowButtonHighlight(button:)), for: .touchDown)
            rowButton.addTarget(self, action: #selector(rowButtonUnhighlight(button:)), for: .touchDragOutside)
            rowButton.backgroundColor = UIColor.clear
            rowView.addSubview(rowButton)
            KMAUIUtilities.shared.setConstaints(parentView: rowView, childView: rowButton, left: 0, right: -38, top: 0, bottom: 0)
            
            stackView.addArrangedSubview(rowView)
            rowView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 0).isActive = true
            
            if index < dataItem.rows.count - 1 {
                // Line view
                let lineView = UIView()
                lineView.backgroundColor = KMAUIConstants.shared.KMAUIGreyLineColor.withAlphaComponent(0.1)
                lineView.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
                stackView.addArrangedSubview(lineView)
                lineView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 0).isActive = true
                lineView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 0).isActive = true
            }
            
            rowViews.append(rowView)
        }
    }
    
    // MARK: - IBActions
    
    @objc public func visibilityButtonPressed(button: UIButton) {
        var isVisible = true
        
        if button.tintColor == UIColor.white {
            isVisible = false
            button.tintColor = KMAUIConstants.shared.KMAUIGreyLineColor
            button.backgroundColor = KMAUIConstants.shared.KMAProgressGray
        } else {
            button.backgroundColor = KMAUIConstants.shared.KMAUIBlueDarkColor
            button.tintColor = UIColor.white
        }
        
        visibilityChangedCallback?(button.tag - 100, isVisible)
    }
    
    @objc public func rowButtonPressed(button: UIButton) {
        if rowViews.count > button.tag - 200 {
            let rowView = rowViews[button.tag - 200]
            rowView.backgroundColor = KMAUIConstants.shared.KMAUIMainBgColor
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                rowView.backgroundColor = UIColor.clear
            }
        }
        
        rowClickedCallback?(button.tag - 200)
    }
    
    @objc public func rowButtonHighlight(button: UIButton) {
        if rowViews.count > button.tag - 200 {
            let rowView = rowViews[button.tag - 200]
            rowView.backgroundColor = KMAUIConstants.shared.KMAUIMainBgColor
        }
    }
    
    @objc public func rowButtonUnhighlight(button: UIButton) {
        if rowViews.count > button.tag - 200 {
            let rowView = rowViews[button.tag - 200]
            
            if rowView.backgroundColor == KMAUIConstants.shared.KMAUIMainBgColor {
                rowView.backgroundColor = UIColor.clear
            }
        }
    }
}
