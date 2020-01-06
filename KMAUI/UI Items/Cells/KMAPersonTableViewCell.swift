//
//  KMAPersonTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 06.01.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit
import Parse
import Kingfisher

public class KMAPersonTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet public weak var profileImageView: UIImageView!
    @IBOutlet public weak var fullNameLabel: KMAUITitleLabel!
    @IBOutlet public weak var usernameLabel: KMAUITextLabel!
    @IBOutlet public weak var rightArrowImageView: UIImageView!
    
    // MARK: - Variables
    public var person = KMAPerson()

    // MARK: - Cell methods

    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Right arrow image view
        KMAUIUtilities.shared.setupArrow(imageView: rightArrowImageView)
        
        // No selection required
        selectionStyle = .none
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    /**
     Setup cell
     */
    
    public func setupCell() {
        fullNameLabel.text = person.fullName
        usernameLabel.text = person.username
    }
}

// MARK: - Person struct

public struct KMAPerson {
    public var username = ""
    public var fullName = ""
    public var profileImage = ""
    
    public init() {
    }
}
