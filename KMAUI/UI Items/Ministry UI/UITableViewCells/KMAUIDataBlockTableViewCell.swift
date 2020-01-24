//
//  KMAUIDataBlockTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 24.01.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit

public class KMAUIDataBlockTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet public weak var itemNameLabel: KMAUIBoldTextLabel!
    @IBOutlet public weak var itemHandleLabel: KMAUIRegularTextLabel!
    @IBOutlet public weak var lastUpdatedLabel: KMAUIRegularTextLabel!
    @IBOutlet public weak var stackView: UIStackView!
    
    // MARK: - Variables
    public var dataItem = KMAUIDataItem() {
        didSet {
            setupCell()
        }
    }
    public var visibilityChangedCallback: ((Int, Bool) -> Void)?
    public static let id = "KMAUIDataBlockTableViewCell"
    
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
        itemNameLabel.text = dataItem.itemName
        itemHandleLabel.text = dataItem.itemHandle
        lastUpdatedLabel.text = "Last update \(KMAUIUtilities.shared.formatStringShort(date: dataItem.lastUpdate))"
        
        for (index, row) in dataItem.rows.enumerated() {
            let itemView = UIStackView()
            
            itemView.axis = .horizontal
            itemView.distribution = UIStackView.Distribution.fill
            itemView.alignment = UIStackView.Alignment.fill
            itemView.spacing = 8.0
            
            // Row name label
            let rowNameLabel = KMAUIRegularTextLabel()
            rowNameLabel.textAlignment = .left
            
            if let rowName = row["rowName"] as? String {
                rowNameLabel.text = rowName
            }
            
            rowNameLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .horizontal)
            itemView.addArrangedSubview(rowNameLabel)
            rowNameLabel.leadingAnchor.constraint(equalTo: itemView.leadingAnchor, constant: 0).isActive = true
            
            // Row value label
            let rowValueLabel = KMAUIBoldTextLabel()
            rowValueLabel.textAlignment = .right
            
            if let rowValue = row["rowValue"] as? String {
                rowValueLabel.text = rowValue
            }
            
            rowValueLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 252), for: .horizontal)
            itemView.addArrangedSubview(rowValueLabel)
            
            // Visibility button
            let visibilityButton = UIButton()
            visibilityButton.widthAnchor.constraint(equalToConstant: 33.0).isActive = true
            visibilityButton.heightAnchor.constraint(equalToConstant: 28.0).isActive = true
            visibilityButton.setTitle("", for: .normal)
            visibilityButton.setImage(KMAUIConstants.shared.eyeIcon.withRenderingMode(.alwaysTemplate), for: .normal)
            
            if let visibility = row["visibility"] as? Bool, visibility {
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
            
            stackView.addArrangedSubview(itemView)
            itemView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 0).isActive = true
            
            if index < dataItem.rows.count - 1 {
                // Line view
                let lineView = UIView()
                lineView.backgroundColor = KMAUIConstants.shared.KMAUIGreyLineColor.withAlphaComponent(0.1)
                lineView.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
                stackView.addArrangedSubview(lineView)
                lineView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 12).isActive = true
                lineView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 12).isActive = true
            }
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
}
