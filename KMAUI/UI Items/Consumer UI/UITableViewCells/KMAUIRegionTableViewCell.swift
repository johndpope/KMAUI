//
//  KMAUIRegionTableViewCell.swift
//  KMA EYES CITIZENS
//
//  Created by Stanislav Rastvorov on 09.04.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit

public class KMAUIRegionTableViewCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet public weak var bgView: KMAUIRoundedCornersView!
    @IBOutlet public weak var titleLabel: UILabel!
    @IBOutlet public weak var infoLabel: UILabel!
    @IBOutlet public weak var joinButton: UIButton!
    
    // MARK: - Variables
    public static let id = "KMAUIRegionTableViewCell"
    public var region = KMAMapAreaStruct() {
        didSet {
            setupCell()
        }
    }
    public var callback: ((Bool) -> Void)?
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Background
        contentView.backgroundColor = KMAUIConstants.shared.KMAUIMainBgColor
        bgView.backgroundColor = KMAUIConstants.shared.KMAUIViewBgColor
        // Larger shadow for bgView
        bgView.layer.shadowOffset = CGSize(width: 0, height: 0)
        bgView.layer.shadowRadius = 4
        
        // Join button
        joinButton.layer.cornerRadius = 17
        joinButton.clipsToBounds = true
        joinButton.titleLabel?.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(17)

        // Title label
        titleLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(22)
        
        // Info label
        infoLabel.font = KMAUIConstants.shared.KMAUIRegularFont.withSize(16)

        // No standard selection requried
        selectionStyle = .none
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        setupColors(highlight: selected)
    }
    
    override public func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        setupColors(highlight: highlighted)
    }
    
    public func setupColors(highlight: Bool) {
        if highlight {
            bgView.backgroundColor = KMAUIConstants.shared.KMAUIMainBgColor
        } else {
            bgView.backgroundColor = KMAUIConstants.shared.KMAUIViewBgColor
        }
    }
    
    public func setupCell() {
        titleLabel.text = region.nameE
        infoLabel.text = "Citizens queue – \(region.lotteryMembersCount)"
        
        if region.joined {
            joinButton.backgroundColor = KMAUIConstants.shared.KMAUILightButtonColor
            joinButton.setTitleColor(KMAUIConstants.shared.KMAUITextColor, for: .normal)
            joinButton.setTitle("Joined", for: .normal)
        } else {
            joinButton.backgroundColor = KMAUIConstants.shared.KMATurquoiseColor
            joinButton.setTitleColor(UIColor.white, for: .normal)
            joinButton.setTitle("Join", for: .normal)
        }
    }
    
    @IBAction public func joinButtonPressed(_ sender: Any) {
        callback?(true)
    }
}
