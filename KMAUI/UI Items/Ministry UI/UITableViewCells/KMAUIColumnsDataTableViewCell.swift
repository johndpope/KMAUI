//
//  KMAUIColumnsDataTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 30.01.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit

public class KMAUIColumnsDataTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet public weak var headerStackView: UIStackView!
    @IBOutlet public weak var detailsStackView: UIStackView!
        
    // MARK: - Variables
    public static let id = "KMAUIColumnsDataTableViewCell"
    public var headers = [String]()
    public var incomeData = [KMAUIIncomeData]() {
        didSet {
            setupCell()
        }
    }

    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
 
    public func setupCell() {
        // Clear headers subviews
        for subview in headerStackView.subviews {
//            subview.removeFromSuperview()
            headerStackView.removeArrangedSubview(subview)
        }
        
        // Setup headers data
        for item in headers {
            let headerLabel = KMAUIBoldTextLabel()
            headerLabel.text = item
            headerLabel.textAlignment = .left
            headerStackView.addArrangedSubview(headerLabel)
        }
        
        // Clear details subviews
        for subview in detailsStackView.subviews {
//            subview.removeFromSuperview()
            detailsStackView.removeArrangedSubview(subview)
        }

        // Setup details data
        for (index, value) in incomeData.enumerated() {
            let itemView = UIStackView()
            itemView.axis = .horizontal
            itemView.alignment = .fill
            itemView.distribution = .fillEqually
            itemView.spacing = 8.0
            
            let items = [value.itemName, value.femaleSalary.withDollarK(), value.maleSalary.withDollarK()]
            
            for item in items {
                let headerLabel = KMAUIRegularTextLabel()
                headerLabel.text = item
                headerLabel.textAlignment = .left
                itemView.addArrangedSubview(headerLabel)
            }
            
            detailsStackView.addArrangedSubview(itemView)
            
            if index < incomeData.count - 1 {
                let lineView = UIView()
                lineView.backgroundColor = KMAUIConstants.shared.KMAUIGreyLineColor.withAlphaComponent(0.1)
                lineView.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
                detailsStackView.addArrangedSubview(lineView)
            }
        }
    }
}
