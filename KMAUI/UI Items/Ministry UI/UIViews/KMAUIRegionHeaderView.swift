//
//  KMAUIRegionHeaderView.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 10.03.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit

public class KMAUIRegionHeaderView: UIView {
    // MARK: - IBOutlets
    @IBOutlet public var contentView: UIView!
    @IBOutlet public weak var regionLabel: KMAUIBoldTextLabel!
    @IBOutlet public weak var queueLabel: KMAUIRegularTextLabel!
    @IBOutlet public weak var timeframeLabel: KMAUIRegularTextLabel!
    
    // MARK: - Variables
    public var region = KMAMapAreaStruct() {
        didSet {
            setupCell()
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
    
    public func setupCell() {
        regionLabel.text = "Ar Riayd"
        queueLabel.text = "Queue – 3"
        timeframeLabel.text = "From 01.03.20 – To 28.02.21"
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("KMAUIRegionHeaderView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
