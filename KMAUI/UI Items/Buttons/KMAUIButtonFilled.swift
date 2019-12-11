//
//  KMAButtonFilled.swift
//  KMA EYES CITIZENS
//
//  Created by Stanislav Rastvorov on 8/29/19.
//  Copyright © 2019 Stanislav Rastvorov. All rights reserved.
//

import UIKit

/// This class represents the button with the green background and white title

public class KMAButtonFilled: UIButton {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        titleLabel?.font = UIFont.systemFont(ofSize: 15.0, weight: .semibold)
        setTitleColor(UIColor.white, for: .normal) // It should be white for both Light and Dark mode
        backgroundColor = KMAUIConstants.shared.KMABrightBlueColor
        layer.cornerRadius = KMAUIConstants.shared.KMACornerRadius
        clipsToBounds = true
    }
}
