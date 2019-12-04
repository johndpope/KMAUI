//
//  KMAUIUtilities.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 04.12.2019.
//  Copyright © 2019 Stanislav Rastvorov. All rights reserved.
//

import UIKit

public class KMAUIUtilities {
    // Access variable
    public static let shared = KMAUIUtilities()
    
    /**
     Returns the UIView for a header with the headerTitle set for a label.
    */
    
    public func headerView(title: String, isRound: Bool? = nil) -> UITableViewHeaderFooterView {
//        var offset: CGFloat = 0
//
//        if let isRound = isRound, isRound {
//            offset = 20
//        }
        
        let offset: CGFloat = 20
        
        let backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: KMAUIConstants.shared.KMAScreenWidth, height: 44 + offset))
        
        if offset > 0 {
            backgroundView.layer.cornerRadius = 16
            backgroundView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
        
        // Header view
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: KMAUIConstants.shared.KMAScreenWidth, height: 44 + offset))
        headerView.backgroundColor = KMAUIConstants.shared.KMABlueColor
        backgroundView.backgroundColor = KMAUIConstants.shared.KMABgGray
        headerView.addSubview(backgroundView)
        
        // Header title label
        let headerTitleLabel = KMAUITitleLabel(frame: CGRect(x: 16, y: 8 + offset, width: KMAUIConstants.shared.KMAScreenWidth - 32, height: 36))
        headerTitleLabel.text = title
        headerTitleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        headerView.addSubview(headerTitleLabel)
        
        // Auto-layout for label
        KMAUIUtilities.shared.setConstaints(parentView: headerView, childView: headerTitleLabel, left: 16, right: -16, top: offset, bottom: 0)
        
        // Create a view cell and attach the custom view to it
        let headerViewObject = UITableViewHeaderFooterView()
        headerViewObject.backgroundView = UIView(frame: headerView.bounds)
        headerViewObject.backgroundView?.backgroundColor = KMAUIConstants.shared.KMABgGray
        let contentView = headerViewObject.contentView
        contentView.addSubview(headerView)
        
        // Auto-layout for headerView
        KMAUIUtilities.shared.setConstaints(parentView: contentView, childView: headerView, left: 0, right: 0, top: 0, bottom: 0)

        return headerViewObject
    }
    
    /**
     Set constraints.
     */
    
    public func setConstaints(parentView: UIView, childView: UIView, left: CGFloat, right: CGFloat, top: CGFloat, bottom: CGFloat) {
        childView.translatesAutoresizingMaskIntoConstraints = false
        childView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: left).isActive = true
        childView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: right).isActive = true
        childView.topAnchor.constraint(equalTo: parentView.topAnchor, constant: top).isActive = true
        childView.bottomAnchor.constraint(equalTo: parentView.bottomAnchor, constant: bottom).isActive = true
    }
}
