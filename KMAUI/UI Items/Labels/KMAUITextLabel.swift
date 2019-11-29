//
//  KMAUITextLabel.swift
//  KMA EYES CITIZENS
//
//  Created by Stanislav Rastvorov on 8/28/19.
//  Copyright © 2019 Stanislav Rastvorov. All rights reserved.
//

import UIKit

/// This label to be used for a regular text, like description labels.

public class KMAUITextLabel: UILabel {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
        textColor = KMAUIConstants.shared.KMATextColor
        numberOfLines = 0
    }
}
