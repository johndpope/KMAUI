//
//  KMAUIPolygoneReviewsTableViewCell.swift
//  KMA
//
//  Created by Stanislav Rastvorov on 24.07.2020.
//  Copyright © 2020 Office Mac. All rights reserved.
//

import UIKit
import KMAUI

public class KMAUIPolygoneReviewsTableViewCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var bgView: KMAUIRoundedCornersView!
    @IBOutlet weak var titleLabel: KMAUIBoldTextLabel!
    @IBOutlet weak var stackView: UIStackView!
    
    // MARK: - Variables
    public static let id = "KMAUIPolygoneReviewsTableViewCell"
    public var reviews = [KMAUIGoogleReviewStruct]() {
        didSet {
            setupCell()
        }
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Background color
        backgroundColor = KMAUIConstants.shared.KMAUIViewBgColorReverse
        
        // Larger shadow for bgView
        bgView.backgroundColor = KMAUIConstants.shared.KMAUIViewBgColor
        bgView.layer.shadowOffset = CGSize(width: 0, height: 4)
        bgView.layer.shadowRadius = 12
        
        // Title label
        titleLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(20)
         
        // No selection required
        selectionStyle = .none
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setupCell() {
        // Setup title
        titleLabel.text = "Reviews"
        
        // Clear existing subviews
        for subview in stackView.subviews {
            stackView.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }

        // Prepare the rows
        for (index, review) in reviews.enumerated() {
            // Top view
            let topView = UIStackView()
            topView.axis = .horizontal
            topView.distribution = UIStackView.Distribution.fillProportionally
            topView.alignment = UIStackView.Alignment.fill
            topView.spacing = 8
            
            // Profile images
            let profileImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
            profileImageView.image = KMAUIConstants.shared.profilePlaceholder.withRenderingMode(.alwaysTemplate)
            profileImageView.layer.cornerRadius = 4
            profileImageView.layer.borderWidth = 1
            profileImageView.tintColor = KMAUIConstants.shared.KMAUIGreyLineColor.withAlphaComponent(0.2)
            profileImageView.layer.borderColor = KMAUIConstants.shared.KMAUIGreyLineColor.withAlphaComponent(0.2).cgColor
            profileImageView.clipsToBounds = true
            profileImageView.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
            profileImageView.widthAnchor.constraint(equalToConstant: 44.0).isActive = true
            
            // Show the image
            if let profilePhotoURL = URL(string: review.profilePhotoURL) {
                profileImageView.kf.indicatorType = .activity
                profileImageView.kf.setImage(with: profilePhotoURL)
            }
            
            topView.addArrangedSubview(profileImageView)
            
            // Name / Rating and Time view
            let nameTimeView = UIStackView()
            nameTimeView.axis = .vertical
            nameTimeView.distribution = UIStackView.Distribution.fill
            nameTimeView.alignment = UIStackView.Alignment.fill
            nameTimeView.spacing = 0
            
            // Name and rating
            let nameRatingView = UIStackView()
            nameRatingView.axis = .horizontal
            nameRatingView.distribution = UIStackView.Distribution.fill
            nameRatingView.alignment = UIStackView.Alignment.fill
            nameRatingView.spacing = 8
            
            // Name label
            let nameLabel = KMAUIBoldTextLabel()
            nameLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(16)
            nameLabel.text = review.author
            nameRatingView.addArrangedSubview(nameLabel)
            
            // Rating label
            if review.rating > 0 {
                let ratingLabel = KMAUIBoldTextLabel()
                ratingLabel.textColor = UIColor.white
                ratingLabel.text = "\(review.rating)"
                
                if review.rating >= 4.5 {
                    ratingLabel.backgroundColor = KMAUIConstants.shared.KMAUIGreenProgressColor
                } else if review.rating >= 3 {
                    ratingLabel.backgroundColor = KMAUIConstants.shared.KMAUIYellowProgressColor
                } else {
                    ratingLabel.backgroundColor = KMAUIConstants.shared.KMARedColor
                }
                
                ratingLabel.heightAnchor.constraint(equalToConstant: 22.0).isActive = true
                ratingLabel.widthAnchor.constraint(equalToConstant: 44.0).isActive = true
                ratingLabel.layer.cornerRadius = 4
                ratingLabel.clipsToBounds = true
                ratingLabel.textAlignment = .center
                nameRatingView.addArrangedSubview(ratingLabel)
            }
            
            // Add the nameRating into the nameTime
            nameTimeView.addArrangedSubview(nameRatingView)
            
            // Time label
            let timeLabel = KMAUIRegularTextLabel()
            timeLabel.text = review.displayTime
            nameTimeView.addArrangedSubview(timeLabel)
            topView.addArrangedSubview(nameTimeView)
            
            // Add item view into stack view
            stackView.addArrangedSubview(topView)
            topView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 0).isActive = true
            
            // Row name label
            let rowNameLabel = KMAUIRegularTextLabel()
            rowNameLabel.textAlignment = .left
            rowNameLabel.text = review.text
            stackView.addArrangedSubview(rowNameLabel)
            
            // Divide with line
            if index + 1 < reviews.count {
                addLine()
            }
        }
    }
    
    func addLine() {
        // Line view
        let lineView = UIView()
        lineView.backgroundColor = KMAUIConstants.shared.KMAUIGreyLineColor.withAlphaComponent(0.2)
        lineView.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
        stackView.addArrangedSubview(lineView)
        lineView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 0).isActive = true
        lineView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 0).isActive = true
    }
}
