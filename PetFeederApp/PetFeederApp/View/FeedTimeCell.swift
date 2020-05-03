//
//  FeedTimeCell.swift
//  PetFeederApp
//
//  Created by Jonathan Fletcher on 4/30/20.
//  Copyright © 2020 Jonathan Fletcher. All rights reserved.
//

import UIKit

//MARK: Feed Time Cell
class FeedTimeCell: UICollectionViewCell {
    
    var date: Date? {
        
        didSet {
            
            if let date = date {
                
                feedTimeLabel.text = getTimeString(date: date)
            }
        }
    }
    
    let feedTimeLabel: UILabel = {
        
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 32)
        label.textColor = Color.darkCarbonGray
        label.textAlignment = .left
        label.text = "Time"
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: Init
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Setup Views
    private func setupViews() {
        
        backgroundColor = Color.lighterLightGray
        
        addSubview(feedTimeLabel)
        
        feedTimeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        feedTimeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        feedTimeLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        feedTimeLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}
