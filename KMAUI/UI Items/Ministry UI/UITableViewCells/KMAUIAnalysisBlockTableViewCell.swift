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
    }
    
    // MARK: - IBActions
    
    @IBAction func optionsButtonPressed(_ sender: Any) {
        optionsCallback?(true)
    }
}
