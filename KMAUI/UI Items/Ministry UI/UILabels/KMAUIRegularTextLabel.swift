//
//  KMAUIRegularTextLabel.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 22.01.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit

public class KMAUIRegularTextLabel: UILabel {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
        textColor = KMAUIConstants.shared.KMATextColor
        numberOfLines = 0
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
        textColor = KMAUIConstants.shared.KMATextColor
        numberOfLines = 0
    }
}
