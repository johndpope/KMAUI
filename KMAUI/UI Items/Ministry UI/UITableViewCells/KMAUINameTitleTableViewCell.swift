//
//  KMAUINameTitleTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 17.02.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit

public class KMAUINameTitleTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet public weak var uploadDescriptionBgView: UIView!
    @IBOutlet public weak var uploadDescriptionLabel: KMAUITextLabel!
    
    // MARK: - Variables
    public static let id = "KMAUINameTitleTableViewCell"
    public var uploadDescription = "" {
        didSet {
            setupCell()
        }
    }

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
        uploadDescriptionLabel.text = uploadDescription
    }
}
