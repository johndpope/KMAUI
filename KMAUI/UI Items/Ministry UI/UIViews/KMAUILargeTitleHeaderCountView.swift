//
//  KMAUILargeTitleHeaderView.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 12.03.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit

public class KMAUILargeTitleHeaderCountView: UIView {
    // MARK: - IBoutlets
    @IBOutlet public var contentView: UIView!
    @IBOutlet public weak var bgView: UIView!
    @IBOutlet public weak var bgViewBottom: NSLayoutConstraint!
    @IBOutlet public weak var lotteryImageView: UIImageView!
    @IBOutlet public weak var headerLabel: UILabel!
    @IBOutlet public weak var detailsLabel: KMAUIRegularTextLabel!
    @IBOutlet public weak var countLabel: KMAUIBoldTextLabel!
    
    // MARK: - Variables
    public var count = 0
    public var hasShadow = false {
        didSet {
            setupHeader()
        }
    }
    public var headerTitle = "" {
        didSet {
            setupHeader()
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public func setupHeader() {
        // Fill the data to display
        headerLabel.text = headerTitle
        headerLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(20)
        // Text label
        detailsLabel.font = KMAUIConstants.shared.KMAUIRegularFont.withSize(16)
        // Check details
        bgView.layer.cornerRadius = 8
        // Set the views
        if headerTitle == "Land rules" {
            detailsLabel.text = "sub lands available for lottery"
            bgViewBottom.constant = 0
            bgView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            lotteryImageView.image = KMAUIConstants.shared.lotteryPlaceholder
        } else if headerTitle == "Citizens" {
            detailsLabel.text = "registered users"
            bgViewBottom.constant = 16
            bgView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
            lotteryImageView.image = KMAUIConstants.shared.citizensIcon
        }
        // Count label
        countLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(20)
        countLabel.text = "\(count)"
        // Shadow
        if hasShadow {
            // Shadow
            bgView.layer.shadowColor = KMAUIConstants.shared.KMATextGrayColor.cgColor
            bgView.layer.shadowOpacity = 0.1
            bgView.layer.shadowOffset = CGSize(width: 0, height: 0)
            bgView.layer.shadowRadius = 8
            bgView.layer.shouldRasterize = true
            bgView.layer.rasterizationScale = UIScreen.main.scale
            bgView.clipsToBounds = false
            contentView.backgroundColor = KMAUIConstants.shared.KMAUIViewBgColor
            bgViewBottom.constant = 24
        } else {
            bgView.clipsToBounds = true
            contentView.backgroundColor = KMAUIConstants.shared.KMAUIMainBgColor
        }
    }
    
    private func commonInit() {
        let bundle = Bundle(for: KMAUILargeTitleHeaderView.self)
        bundle.loadNibNamed("KMAUILargeTitleHeaderCountView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
