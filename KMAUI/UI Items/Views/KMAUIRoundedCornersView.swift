//
//  KMARoundedCornersView.swift
//  KMA EYES CITIZENS
//
//  Created by Stanislav Rastvorov on 9/9/19.
//  Copyright © 2019 Stanislav Rastvorov. All rights reserved.
//

import UIKit

/// This class represents the custom UIView with rounded corners.

public class KMAUIRoundedCornersView: UIView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        backgroundColor = KMAUIConstants.shared.KMABackColor
        layer.cornerRadius = KMAUIConstants.shared.KMACornerRadius
        
        // Shadow
        layer.shadowColor = KMAUIConstants.shared.KMATextGrayColor.cgColor
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize(width: 0, height: 8)
        layer.shadowRadius = 8
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
}
