//
//  KMARefreshControl.swift
//  KMA EYES CITIZENS
//
//  Created by Stanislav Rastvorov on 8/28/19.
//  Copyright © 2019 Stanislav Rastvorov. All rights reserved.
//

import UIKit

/// The refresh control with the VillageLync UI. Can be used for tableViews refresh functionality.

public class KMARefreshControl: UIRefreshControl {
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
}
