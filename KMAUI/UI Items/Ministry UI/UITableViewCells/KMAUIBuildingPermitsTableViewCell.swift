//
//  KMAUIBuildingPermitsTableViewCell.swift
//  KMA
//
//  Created by Stanislav Rastvorov on 21.07.2020.
//  Copyright © 2020 Office Mac. All rights reserved.
//

import UIKit

public class KMAUIBuildingPermitsTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var bgView: KMAUIRoundedCornersView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var stackViewTop: NSLayoutConstraint!
    
    // MARK: - Variables
    public static let id = "KMAUIBuildingPermitsTableViewCell"
    public var isFirst = false
    public var dataset = KMAUIDataset() {
        didSet {
            setupCell()
        }
    }

    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Larger shadow for bgView
        bgView.backgroundColor = KMAUIConstants.shared.KMAUIViewBgColor
        bgView.layer.shadowOffset = CGSize(width: 0, height: 4)
        bgView.layer.shadowRadius = 12
        
        // Background color
        backgroundColor = KMAUIConstants.shared.KMAUIViewBgColorReverse
        
        // No selection required
        selectionStyle = .none
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setupCell() {
        if isFirst {
            stackViewTop.constant = 16
        } else {
            stackViewTop.constant = 0
        }
        
        var rowsTitles = [String]()
        var rows = [KMAUIRowData]()
        var values = [[String: Int]]()
        
        for sets in dataset.detailsArray {
            for (key, value) in sets {
                if let value = value as? [String: Int] {
                    values.append(value)
                }
                
                rowsTitles.append(key)
                rows.append(KMAUIRowData(rowName: key, rowValue: ""))
            }
        }
        
        setupStackView(rows: rows, values: values)
    }
    
    /**
     Show the stackView
     */
    
    public func setupStackView(rows: [KMAUIRowData], values: [[String: Int]]) {
        // Remove subviews
        for subview in stackView.subviews {
            stackView.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
        
        // Optimize the font size for the 9.7-inch iPad
        var fontSize: CGFloat = 12
        
        if UIScreen.main.bounds.size.width == 768 || UIScreen.main.bounds.size.height == 768 {
            fontSize = 10
        }
        
        var keys = KMAUIConstants.shared.buildingPermitKeys

        if dataset.type == "establishmentPermits" {
            keys = KMAUIConstants.shared.establishmentPermitKeys
        } else if dataset.type == "buildingPermits" {
            // Add line
//            addLine()

            // Adding the top title view
            let topLineView = UIStackView()
            topLineView.axis = .horizontal
            topLineView.distribution = UIStackView.Distribution.fillEqually
            topLineView.alignment = UIStackView.Alignment.fill
            topLineView.spacing = 4
            
            for title in keys { // topLineArray
                let rowNameLabel = KMAUIBoldTextLabel()
                rowNameLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(fontSize)
                rowNameLabel.textAlignment = .center
                rowNameLabel.text = title
                topLineView.addArrangedSubview(rowNameLabel)
            }
            
            stackView.addArrangedSubview(topLineView)
            topLineView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 0).isActive = true
        }

        // Add the title for each category
        // Prepare the rows
        for (index1, row) in rows.enumerated() {
//            if dataset.type == "buildingPermits" {
//            // Add line
//                addLine()
//            }
                
            // Building kind
            let rowNameLabel = KMAUIBoldTextLabel()
            rowNameLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(fontSize + 4)
            rowNameLabel.textAlignment = .left
            rowNameLabel.text = "   " + row.rowName
            rowNameLabel.heightAnchor.constraint(equalToConstant: 32.0).isActive = true
            rowNameLabel.backgroundColor = KMAUIConstants.shared.KMAUIMainBgColorReverse
            rowNameLabel.layer.cornerRadius = 8
            rowNameLabel.clipsToBounds = true
            stackView.addArrangedSubview(rowNameLabel)
            
            // Values row
            let itemView = UIStackView()
            itemView.axis = .horizontal
            itemView.distribution = UIStackView.Distribution.fill
            itemView.alignment = UIStackView.Alignment.fill
            itemView.spacing = 4
            
            // Value for items
            let value = values[index1]
            
            for key in keys {
                if let count = value[key] {
                    if dataset.type == "buildingPermits" {
                        let rowNameLabel = KMAUIRegularTextLabel()
                        rowNameLabel.font = KMAUIConstants.shared.KMAUIRegularFont.withSize(fontSize)
                        rowNameLabel.text = "\(count)"
                        rowNameLabel.textAlignment = .center
                        rowNameLabel.heightAnchor.constraint(equalToConstant: 32.0).isActive = true
                        itemView.addArrangedSubview(rowNameLabel)
                    } else {
                        let itemView = UIStackView()
                        itemView.axis = .horizontal
                        itemView.distribution = UIStackView.Distribution.fill
                        itemView.alignment = UIStackView.Alignment.fill
                        itemView.spacing = 8
                        
                        itemView.layoutMargins = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
                        itemView.isLayoutMarginsRelativeArrangement = true
                        
                        // Row name label
                        let rowNameLabel = KMAUIRegularTextLabel()
                        rowNameLabel.textAlignment = .left
                        rowNameLabel.text = key
                        
                        if row.rowName == "Values", row.rowValue.isEmpty {
                            rowNameLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(14)
                        }
                        
                        rowNameLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 253), for: .horizontal)
                        itemView.addArrangedSubview(rowNameLabel)
                        
                        // Row value label
                        let rowValueLabel = KMAUIBoldTextLabel()
                        rowValueLabel.textAlignment = .right
                        rowValueLabel.text = "\(count)"
                        rowValueLabel.setLineSpacing(lineSpacing: 1.2, lineHeightMultiple: 1.2, alignment: .right)
                        rowValueLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .horizontal)
                        itemView.addArrangedSubview(rowValueLabel)
                        
                        stackView.addArrangedSubview(itemView)
                        itemView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 0).isActive = true
                    }
                }
            }
            
            stackView.addArrangedSubview(itemView)
            itemView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 0).isActive = true
        }
    }
    
    func addLine() {
        // Line view
        let lineView = UIView()
        lineView.backgroundColor = KMAUIConstants.shared.KMAUIGreyLineColor.withAlphaComponent(0.2)
        lineView.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
        stackView.addArrangedSubview(lineView)
        lineView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 0).isActive = true
        lineView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 0).isActive = true
    }
}
