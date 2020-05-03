//
//  FeederCell.swift
//  PetFeederApp
//
//  Created by Jonathan Fletcher on 4/30/20.
//  Copyright © 2020 Jonathan Fletcher. All rights reserved.
//

import UIKit

//MARK: Feeder Cell
class FeederCell: UICollectionViewCell {
    
    var feeder: Feeder? {
        
        didSet {
            
            if let feederName = feeder?.feederId {
                
                feederIdLabel.text = feederName
            }
            
            if let feedCount = feeder?.feedCount {
                
                feedCountLabel.text = String(feedCount)
            }
        }
    }
    
    let cellBackground: UIView = {
        
        let view = UIView()
        
        view.backgroundColor = Color.lightGray
        view.layer.cornerRadius = 3
        view.clipsToBounds = true
        
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowOpacity = 0.5
        view.layer.shadowRadius = 5
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let feederIdLabel: UILabel = {
        
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 32)
        label.textColor = Color.darkCarbonGray
        label.textAlignment = .left
        label.text = "Spot's Feeder"
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let statusLabel: UILabel = {
        
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 24)
        label.textColor = Color.lighterDarkCarbonGray
        label.textAlignment = .left
        label.text = "Online"
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let feedCountLabel: UILabel = {
        
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 24)
        label.textColor = Color.darkNavyGray
        label.textAlignment = .right
        label.text = "5"
        
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
        
        addSubview(cellBackground)
        cellBackground.addSubview(feederIdLabel)
        cellBackground.addSubview(statusLabel)
        cellBackground.addSubview(feedCountLabel)
        
        cellBackground.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        cellBackground.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        cellBackground.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        cellBackground.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        
        feederIdLabel.topAnchor.constraint(equalTo: cellBackground.topAnchor, constant: 8).isActive = true
        feederIdLabel.leadingAnchor.constraint(equalTo: cellBackground.leadingAnchor, constant: 8).isActive = true
        feederIdLabel.trailingAnchor.constraint(equalTo: cellBackground.trailingAnchor, constant: -8).isActive = true
        feederIdLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        statusLabel.topAnchor.constraint(equalTo: feederIdLabel.bottomAnchor, constant: 2).isActive = true
        statusLabel.leadingAnchor.constraint(equalTo: cellBackground.leadingAnchor, constant: 8).isActive = true
        statusLabel.trailingAnchor.constraint(equalTo: cellBackground.trailingAnchor, constant: -8).isActive = true
        statusLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        feedCountLabel.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 2).isActive = true
        feedCountLabel.leadingAnchor.constraint(equalTo: cellBackground.leadingAnchor, constant: 8).isActive = true
        feedCountLabel.trailingAnchor.constraint(equalTo: cellBackground.trailingAnchor, constant: -8).isActive = true
        feedCountLabel.bottomAnchor.constraint(equalTo: cellBackground.bottomAnchor, constant: -8).isActive = true
    }
}
