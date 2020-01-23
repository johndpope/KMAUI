//
//  KMAUIBoldTextLabel.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 22.01.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit

public class KMAUIBoldTextLabel: UILabel {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        font = KMAUIConstants.shared.KMAUIBoldFont
        textColor = KMAUIConstants.shared.KMAUITextColor
        numberOfLines = 0
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        font = KMAUIConstants.shared.KMAUIBoldFont
        textColor = KMAUIConstants.shared.KMAUITextColor
        numberOfLines = 0
    }
}
