//
//  KMAUISelectableHeaderTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 28.01.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit

public class KMAUISelectableHeaderTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet public weak var stackView: UIStackView!
    
    // MARK: - Variables
    public var items = [KMAUIItemPerformance]() {
        didSet {
                setupCell()
            }
        }
    public static let id = "KMAUISelectableHeaderTableViewCell"
    public var lineViews = [UIView]()
    public var itemLabels = [UILabel]()
    public var selectedIndex = -1
    public var selectedCallback: ((Int) -> Void)?

    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // No selection required
        selectionStyle = .none
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setupCell() {
        // Clear subviews
        lineViews = [UIView]()
        itemLabels = [UILabel]()
        
        for subview in stackView.subviews {
            stackView.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
        
        // Fill subviews
        for (index, item) in items.enumerated() {
            // Background item view
            let itemBg = UIView()
            itemBg.heightAnchor.constraint(equalToConstant: 28).isActive = true
            
            // Item stack view
            let itemView = UIStackView()
            itemView.axis = .vertical
            itemView.alignment = .center
            itemView.distribution = .fill
            itemView.spacing = 4.0
            itemBg.addSubview(itemView)
            KMAUIUtilities.shared.setConstaints(parentView: itemBg, childView: itemView, left: 0, right: 0, top: 0, bottom: 0)
            
            // Item label
            let itemLabel = UILabel()
            itemLabel.text = item.itemName
            itemLabel.textAlignment = .left
            itemView.addArrangedSubview(itemLabel)
            itemLabels.append(itemLabel)
            
            // Active line
            let activeView = UIView()
            activeView.backgroundColor = KMAUIConstants.shared.KMATurquoiseColor
            if item.isOn {
                itemLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(18)
                selectedIndex = index
                activeView.alpha = 1
            } else {
                itemLabel.font = KMAUIConstants.shared.KMAUIRegularFont.withSize(18)
                activeView.alpha = 0
            }
            activeView.widthAnchor.constraint(equalToConstant: 18).isActive = true
            activeView.heightAnchor.constraint(equalToConstant: 2).isActive = true
            itemView.addArrangedSubview(activeView)
            lineViews.append(activeView)
            
            // Item button
            let itemButton = UIButton()
            itemButton.setTitle("", for: .normal)
            itemButton.tag = index + 100
            itemButton.addTarget(self, action: #selector(itemButtonPressed(button:)), for: .touchUpInside)
            itemBg.addSubview(itemButton)
            KMAUIUtilities.shared.setConstaints(parentView: itemBg, childView: itemButton, left: 0, right: 0, top: 0, bottom: 0)
            
            stackView.addArrangedSubview(itemBg)
        }
    }
    
    @objc public func itemButtonPressed(button: UIButton) {
        selectedIndex = button.tag - 100
        
        for (index, activeView) in lineViews.enumerated() {
            let itemLabel = itemLabels[index]
            
            if index == selectedIndex, activeView.alpha == 0 {
                UIView.animate(withDuration: 0.15) {
                    activeView.alpha = 1
                }
                
                itemLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(18)
            } else if index != selectedIndex, activeView.alpha == 1 {
                UIView.animate(withDuration: 0.15) {
                    activeView.alpha = 0
                }
                
                itemLabel.font = KMAUIConstants.shared.KMAUIRegularFont.withSize(18)
            }
        }
        
        selectedCallback?(selectedIndex)
    }
}
