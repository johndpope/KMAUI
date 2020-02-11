//
//  KMAUIProgressView.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 11.02.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit

public class KMAUIProgressView: UIView {
    public var progressView = UIProgressView()
    public var progress: Float = 0 {
        didSet {
            updateProgress()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Remove the subviews
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
        
        // Clear background
        self.backgroundColor = UIColor.clear
        
        // Adding the progressView
        self.addSubview(progressView)
        
        // Centering in the view
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        progressView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 8).isActive = true
        progressView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        // Adjusting the height for a progress
        progress.transform = CGAffineTransformScale(masteryProgress.transform, 1, 8)
    }
    
    public func updateProgress() {
        progressView.progress = progress
    }
}
