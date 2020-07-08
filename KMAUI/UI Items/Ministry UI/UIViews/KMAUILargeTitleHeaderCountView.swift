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
    @IBOutlet public weak var lotteryImageViewHeight: NSLayoutConstraint!
    @IBOutlet public weak var headerLabel: UILabel!
    @IBOutlet public weak var headerLabelTop: NSLayoutConstraint!
    @IBOutlet public weak var detailsLabel: KMAUIRegularTextLabel!
    @IBOutlet public weak var countLabel: KMAUIBoldTextLabel!
    @IBOutlet public weak var countLabelLeft: NSLayoutConstraint!
    
    // MARK: - Variables
    public var count = 0
    public var isLotteryTitle = false
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
        headerLabelTop.constant = 16
        headerLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(20)
        bgViewBottom.constant = 0
        // Text label
        detailsLabel.font = KMAUIConstants.shared.KMAUIRegularFont.withSize(16)
        // Check details
        bgView.layer.cornerRadius = 8
        // Set the views
        if headerTitle == "Royal Orders" {
            detailsLabel.text = ""
            headerLabelTop.constant = 16 + 20 // centering inside the view
            countLabel.text = nil
            lotteryImageView.layer.borderColor = KMAUIConstants.shared.KMAUIGreyLineColor.withAlphaComponent(0.2).cgColor
            lotteryImageView.layer.borderWidth = 1
            lotteryImageView.layer.cornerRadius = 8
            lotteryImageView.clipsToBounds = true
            lotteryImageViewHeight.constant = 60
        } else if isLotteryTitle {
            detailsLabel.text = "sub lands available for the lottery"
            bgView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            lotteryImageView.image = KMAUIConstants.shared.lotteryPlaceholder
        } else if headerTitle == "Land rules" {
            detailsLabel.text = "sub lands available for the lottery"
            bgView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            lotteryImageView.image = KMAUIConstants.shared.lotteryPlaceholder
        } else if headerTitle == "Citizens" {
            detailsLabel.text = "registered users"
            bgView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
            lotteryImageView.image = KMAUIConstants.shared.citizensIcon
        }
        // Count label
        countLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(20)
        if count > 0 {
            countLabelLeft.constant = 12
            countLabel.text = "\(count)"
        } else {
            countLabelLeft.constant = 0
            countLabel.text = ""
        }
        // Shadow
        if hasShadow {
            // Shadow
            bgView.layer.shadowColor = KMAUIConstants.shared.KMAUIGreyLineColor.cgColor
            bgView.layer.shadowOpacity = 0.4
            bgView.layer.shadowOffset = CGSize(width: 0, height: 0)
            bgView.layer.shadowRadius = 8
            bgView.layer.shouldRasterize = true
            bgView.layer.rasterizationScale = UIScreen.main.scale
            bgView.clipsToBounds = false
            contentView.backgroundColor = KMAUIConstants.shared.KMAUIViewBgColor
            bgViewBottom.constant = 12
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
