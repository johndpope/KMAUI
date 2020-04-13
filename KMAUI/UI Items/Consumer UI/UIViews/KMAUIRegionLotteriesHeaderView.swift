//
//  KMAUIRegionLotteriesHeaderView.swift
//  KMA EYES CITIZENS
//
//  Created by Stanislav Rastvorov on 13.04.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit

public class KMAUIRegionLotteriesHeaderView: UIView {
    
    // MARK: - IBOutlets
    @IBOutlet public var contentView: UIView!
    @IBOutlet public weak var regionNameLabel: KMAUIBoldTextLabel!
    @IBOutlet public weak var lotteriesCountLabel: KMAUIBoldTextLabel!
    
    // MARK: - IBOutlets
    public var headerData = KMAUIRowData() {
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
    
    private func commonInit() {
        let bundle = Bundle(for: KMAUIRegionLotteriesHeaderView.self)
        bundle.loadNibNamed("KMAUIRegionLotteriesHeaderView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        contentView.backgroundColor = KMAUIConstants.shared.KMAUIMainBgColor
        // Region name label
        regionNameLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(22)
        // Lotteries count label
        lotteriesCountLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(14)
        lotteriesCountLabel.textColor = KMAUIConstants.shared.KMAUIViewBgColor
        lotteriesCountLabel.backgroundColor = KMAUIConstants.shared.KMAUIBlueDarkColorBarTint
        lotteriesCountLabel.layer.cornerRadius = 10
        lotteriesCountLabel.clipsToBounds = true
        lotteriesCountLabel.textAlignment = .center
        
    }
    
    public func setupHeader() {
        regionNameLabel.text = headerData.rowName
        lotteriesCountLabel.isHidden = headerData.rowValue == "0"
        lotteriesCountLabel.text = headerData.rowValue
    }
}
