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
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Setup the progress view
        addProgressView()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        // Setup the progress view
        addProgressView()
    }
    
    /**
     Add the progress for the view
     */
    
    public func addProgressView() {
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
        progressView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8).isActive = true
        progressView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        // Adjusting the height for a progress
        progressView.transform = progressView.transform.scaledBy(x: 1, y: 2)
        
        // Round corners
        progressView.layer.cornerRadius = progressView.frame.height / 2
        progressView.clipsToBounds = true
    }
    
    /**
     Setup the progress for the view
     */
    
    public func updateProgress() {
        progressView.progress = progress
        
        if progress >= 0.7 {
            progressView.progressTintColor = KMAUIConstants.shared.KMAUIGreenProgressColor
        } else if progress >= 0.4 {
            progressView.progressTintColor = KMAUIConstants.shared.KMAUIYellowProgressColor
        } else {
            progressView.progressTintColor = KMAUIConstants.shared.KMAUIRedProgressColor
        }
    }
}
