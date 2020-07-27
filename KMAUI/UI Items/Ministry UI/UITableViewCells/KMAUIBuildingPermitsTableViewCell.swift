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
        
        // Rows
        var keys = KMAUIConstants.shared.establishmentPermitKeys
        
        if dataset.type == "buildingPermits" {
            keys = KMAUIConstants.shared.buildingPermitKeys
        }
        
        // Title
        let itemView = UIStackView()
        itemView.axis = .horizontal
        itemView.distribution = UIStackView.Distribution.fill
        itemView.alignment = UIStackView.Alignment.fill
        itemView.spacing = 4
        
        var titlesArray = [KMAUIRowData(rowName: "Types of Activities", rowValue: "")]
        
        if dataset.type == "buildingPermits" {
            titlesArray = [KMAUIRowData(rowName: "Type of Permit", rowValue: "")]
        }
        
        titlesArray.append(contentsOf: rows)
        
        for (index, titles) in titlesArray.enumerated() {
            // Building kind
            let rowNameLabel = KMAUIBoldTextLabel()
            rowNameLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(fontSize)
            rowNameLabel.text = titles.rowName
            
            if index == 0 {
                rowNameLabel.setLineSpacing(lineSpacing: 1.2, lineHeightMultiple: 1.2, alignment: .left)
            } else {
                rowNameLabel.textAlignment = .center
                rowNameLabel.setLineSpacing(lineSpacing: 1.2, lineHeightMultiple: 1.2, alignment: .center)
            }

            rowNameLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 24.0).isActive = true
            itemView.addArrangedSubview(rowNameLabel)
        }
        
        stackView.addArrangedSubview(itemView)
        itemView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 0).isActive = true
        
        addLine()
        
        for key in keys {
            // Title
            let itemView = UIStackView()
            itemView.axis = .horizontal
            itemView.distribution = UIStackView.Distribution.fill
            itemView.alignment = UIStackView.Alignment.fill
            itemView.spacing = 4
            
            // Row title
            let rowNameLabel = KMAUIBoldTextLabel()
            rowNameLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(fontSize)
            rowNameLabel.text = key
            rowNameLabel.setLineSpacing(lineSpacing: 1.2, lineHeightMultiple: 1.2, alignment: .left)
            rowNameLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 24.0).isActive = true
            
            rowNameLabel.layer.cornerRadius = 8
            rowNameLabel.clipsToBounds = true
            itemView.addArrangedSubview(rowNameLabel)
            
            // Values
            for value in values {
                if let count = value[key] {
                    // Value title
                    let rowNameLabel = KMAUIRegularTextLabel()
                    rowNameLabel.font = KMAUIConstants.shared.KMAUIRegularFont.withSize(fontSize)
                    rowNameLabel.textAlignment = .center
                    rowNameLabel.text = "\(count)"
                    itemView.addArrangedSubview(rowNameLabel)
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
