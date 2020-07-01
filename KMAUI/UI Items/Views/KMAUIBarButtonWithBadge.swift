//
//  KMAUIBarButtonWithBadge.swift
//  KMA
//
//  Created by Stanislav Rastvorov on 01.07.2020.
//  Copyright © 2020 Office Mac. All rights reserved.
//

import UIKit

public class KMAUIBarButtonWithBadge: UIBarButtonItem {
    
    public func setBadge(with value: Int) {
        self.badgeValue = value
    }
    
    private var badgeValue: Int? {
        didSet {
            if let value = badgeValue,
                value > 0 {
                lblBadge.isHidden = false
                lblBadge.text = "\(value)"
            } else {
                lblBadge.isHidden = true
            }
        }
    }
    
    public var tapAction: (() -> Void)?
    
    private let filterBtn = UIButton()
    private let lblBadge = UILabel()
    
    override init() {
        super.init()
        setup()
    }
    
    public init(with image: UIImage?) {
        super.init()
        setup(image: image)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup(image: UIImage? = nil) {
        self.filterBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        self.filterBtn.adjustsImageWhenHighlighted = false
        self.filterBtn.setImage(image?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.filterBtn.tintColor = KMAUIConstants.shared.KMAUIBlueDarkColorBarTint
        self.filterBtn.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        
        self.lblBadge.frame = CGRect(x: 18, y: 0, width: 18, height: 18)
        self.lblBadge.backgroundColor = KMAUIConstants.shared.KMATurquoiseColor
        self.lblBadge.clipsToBounds = true
        self.lblBadge.layer.cornerRadius = 9
        self.lblBadge.textColor = UIColor.white
        self.lblBadge.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
        self.lblBadge.textAlignment = .center
        self.lblBadge.isHidden = true
        self.lblBadge.minimumScaleFactor = 0.1
        self.lblBadge.adjustsFontSizeToFitWidth = true
        self.filterBtn.addSubview(lblBadge)
        self.customView = filterBtn
    }
    
    @objc func buttonPressed() {
        if let action = tapAction {
            action()
        }
    }
    
}
