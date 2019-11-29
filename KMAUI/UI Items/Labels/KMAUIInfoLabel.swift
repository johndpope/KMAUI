//
//  KMAInfoLabel.swift
//  KMA EYES CITIZENS
//
//  Created by Stanislav Rastvorov on 8/28/19.
//  Copyright © 2019 Stanislav Rastvorov. All rights reserved.
//

import UIKit

/// This label type to be used for info labels, like: time labe, status label, etc.

public class KMAUIInfoLabel: UILabel {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        font = UIFont.systemFont(ofSize: 15.0, weight: .regular)
        textColor = KMAUIConstants.shared.KMATextGrayColor
        numberOfLines = 0
    }
}
