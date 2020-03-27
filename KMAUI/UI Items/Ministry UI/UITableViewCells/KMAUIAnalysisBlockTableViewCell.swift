//
//  KMAUIAnalysisBlockTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 24.01.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit

public class KMAUIAnalysisBlockTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet public weak var itemNameLabel: KMAUIBoldTextLabel!
    @IBOutlet public weak var optionsButton: UIButton!
    @IBOutlet public weak var stackView: UIStackView!
    
    // MARK: - Variables
    public var dataItem = KMAUIDataItem() {
        didSet {
            setupCell()
        }
    }
    public static let id = "KMAUIAnalysisBlockTableViewCell"
    public var optionsCallback: ((Bool) -> Void)?
    public var pointCallback: ((Int) -> Void)?
    public var rowViews = [UIView]()
    public var selectedIndex = -1
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        optionsButton.setImage(KMAUIConstants.shared.optionsIcon.withRenderingMode(.alwaysTemplate), for: .normal)
        optionsButton.tintColor = KMAUIConstants.shared.KMAUITextColor
        
        // No selection required
        selectionStyle = .none
    }
    
    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    public func setupCell() {
        itemNameLabel.text = dataItem.itemName
        
        // Clear existing subviews
        rowViews = [UIView]()
        
        for subview in stackView.subviews {
            stackView.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
        
        // Prepare the rows
        for (index, row) in dataItem.rows.enumerated() {
            // Row background view
            let rowBgView = UIView()
            
            if selectedIndex == index {
                rowBgView.backgroundColor = KMAUIConstants.shared.KMAUIMainBgColor
            } else {
                rowBgView.backgroundColor = KMAUIConstants.shared.KMAUIViewBgColor
            }
            
            rowBgView.layer.cornerRadius = KMAUIConstants.shared.KMACornerRadius
            rowBgView.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
            stackView.addArrangedSubview(rowBgView)
            rowBgView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 0).isActive = true
            
            // Cache row view
            rowViews.append(rowBgView)
            
            // Row stack view
            let itemView = UIStackView()            
            itemView.axis = .horizontal
            itemView.distribution = UIStackView.Distribution.fill
            itemView.alignment = UIStackView.Alignment.fill
            itemView.spacing = 8
            
            // Add the item view into the rowBgView
            rowBgView.addSubview(itemView)
            KMAUIUtilities.shared.setConstaints(parentView: rowBgView, childView: itemView, left: 0, right: 0, top: 0, bottom: 0)
            
            // selection button
            let selectionButton = UIButton()
            selectionButton.tag = index + 100
            selectionButton.addTarget(self, action: #selector(selectionButtonPressed(button:)), for: .touchUpInside)
            rowBgView.addSubview(selectionButton)
            KMAUIUtilities.shared.setConstaints(parentView: rowBgView, childView: selectionButton, left: 0, right: 0, top: 0, bottom: 0)
            
            // Row name label
            let rowNameLabel = KMAUIRegularTextLabel()
            rowNameLabel.textAlignment = .left
            rowNameLabel.text = row.rowName
            rowNameLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .horizontal)
            itemView.addArrangedSubview(rowNameLabel)
            rowNameLabel.leadingAnchor.constraint(equalTo: itemView.leadingAnchor, constant: 8).isActive = true
            
            // Row value label
            let rowValueLabel = KMAUIBoldTextLabel()
            rowValueLabel.textAlignment = .right
            rowValueLabel.text = row.rowValue
            rowValueLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 252), for: .horizontal)
            itemView.addArrangedSubview(rowValueLabel)
            
            // The arrow image view
            let arrowImageView = UIImageView()
            arrowImageView.contentMode = .center
            arrowImageView.image = KMAUIConstants.shared.arrowIndicator
            arrowImageView.widthAnchor.constraint(equalToConstant: 12.0).isActive = true
            arrowImageView.heightAnchor.constraint(equalToConstant: 12.0).isActive = true
            itemView.addArrangedSubview(arrowImageView)
            
            if index < dataItem.rows.count - 1 {
                // Line view
                let lineView = UIView()
                lineView.backgroundColor = KMAUIConstants.shared.KMAUIGreyLineColor.withAlphaComponent(0.2)
                lineView.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
                stackView.addArrangedSubview(lineView)
                lineView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 0).isActive = true
                lineView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 0).isActive = true
            }
        }
    }
    
    // MARK: - IBActions
    
    @objc func selectionButtonPressed(button: UIButton) {
        let newIndex = button.tag - 100
        
        if newIndex == selectedIndex {
            // Deselect index
            selectedIndex = -1
        } else {
            // Select new index
            selectedIndex = newIndex
        }
        
        for (index, rowBgView) in rowViews.enumerated() {
            if selectedIndex == index {
                rowBgView.backgroundColor = KMAUIConstants.shared.KMAUIMainBgColor
            } else {
                rowBgView.backgroundColor = KMAUIConstants.shared.KMAUIViewBgColor
            }
        }
        
        pointCallback?(selectedIndex)
    }
    
    @IBAction func optionsButtonPressed(_ sender: Any) {
        optionsCallback?(true)
    }
}
