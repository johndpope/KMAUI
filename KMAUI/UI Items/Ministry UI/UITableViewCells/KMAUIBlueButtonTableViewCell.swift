//
//  KMAUIBlueButtonTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 05.03.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit

public class KMAUIBlueButtonTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet public weak var lotteryButton: KMAUIButtonFilled!
    
    // MARK: - Variables
    public static let id = "KMAUIBlueButtonTableViewCell"
    public var buttonCallback: ((Bool) -> Void)?

    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // No selection required
        selectionStyle = .none
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setupNewTrespass() {
        lotteryButton.setTitle("Create a new Trespass case", for: .normal)
        lotteryButton.titleLabel?.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(18)
        lotteryButton.backgroundColor = KMAUIConstants.shared.KMATurquoiseColor
        lotteryButton.layer.cornerRadius = 26
        clipsToBounds = true
    }
    
    // MARK: - IBActions
    
    @IBAction public func lotteryButtonPressed(_ sender: Any) {
        buttonCallback?(true)
    }
}
