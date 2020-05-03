//
//  AddFeederPopup.swift
//  PetFeederApp
//
//  Created by Jonathan Fletcher on 5/1/20.
//  Copyright © 2020 Jonathan Fletcher. All rights reserved.
//

import UIKit

//MARK: Add Feeder Popup
class AddFeederPopup: UIView {
    
    var mainViewController: MainViewController?
    
    let popupBackground: UIView = {
        
        let view = UIView()
        
        view.backgroundColor = Color.lighterLightGray
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowOpacity = 0.5
        view.layer.shadowRadius = 5
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let addFeederLabel: UILabel = {
        
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 32)
        label.textColor = Color.darkCarbonGray
        label.textAlignment = .left
        label.text = "Add New Feeder"
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let feederNameField: UITextField = {
        
        let tf = UITextField()
        
        tf.font = UIFont.systemFont(ofSize: 27)
        tf.textColor = Color.darkCarbonGray
        tf.borderStyle = .roundedRect
        tf.placeholder = "Feeder Name"
        
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let addButton: UIButton = {
        
        let button = UIButton()
        
        button.setTitle(("Add"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 27)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.setTitleColor(Color.darkerVibrantPurple, for: .normal)
        button.titleLabel?.textAlignment = .left
        
        button.addTarget(self, action: #selector(addFeeder), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let exitButton: UIButton = {
        
        let button = UIButton()
        
        button.setTitle(("Cancel"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 27)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.setTitleColor(Color.darkerVibrantPurple, for: .normal)
        button.titleLabel?.textAlignment = .right
        
        button.addTarget(self, action: #selector(exitPopup), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
        
        addSubview(popupBackground)
        
        popupBackground.addSubview(addButton)
        popupBackground.addSubview(exitButton)
        popupBackground.addSubview(addFeederLabel)
        popupBackground.addSubview(feederNameField)
        
        popupBackground.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        popupBackground.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -100).isActive = true
        popupBackground.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.85).isActive = true
        popupBackground.heightAnchor.constraint(equalToConstant: 160).isActive = true
        
        addFeederLabel.topAnchor.constraint(equalTo: popupBackground.topAnchor, constant: 8).isActive = true
        addFeederLabel.leadingAnchor.constraint(equalTo: popupBackground.leadingAnchor, constant: 8).isActive = true
        addFeederLabel.trailingAnchor.constraint(equalTo: popupBackground.trailingAnchor, constant: -8).isActive = true
        addFeederLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        feederNameField.leadingAnchor.constraint(equalTo: popupBackground.leadingAnchor, constant: 8).isActive = true
        feederNameField.trailingAnchor.constraint(equalTo: popupBackground.trailingAnchor, constant: -8).isActive = true
        feederNameField.bottomAnchor.constraint(equalTo: addButton.topAnchor, constant: -8).isActive = true
        feederNameField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        addButton.leadingAnchor.constraint(equalTo: popupBackground.leadingAnchor, constant: 8).isActive = true
        addButton.bottomAnchor.constraint(equalTo: popupBackground.bottomAnchor, constant: -16).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        exitButton.trailingAnchor.constraint(equalTo: popupBackground.trailingAnchor, constant: -8).isActive = true
        exitButton.bottomAnchor.constraint(equalTo: popupBackground.bottomAnchor, constant: -16).isActive = true
        exitButton.widthAnchor.constraint(equalToConstant: 90).isActive = true
        exitButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    //MARK: Add Feeder
    @objc func addFeeder() {
        
        if let name = feederNameField.text {
            
            if name == "" { return }
            
            let feeder = Feeder(id: "", feederId: name, feedOverride: 0, feedCount: 0, currentTime: 0, numberOfFeedTimes: 0, feedTimes: "")
            
            mainViewController?.addFeeder(feeder: feeder)
            mainViewController?.removeAddFeederPopup()
        }
        
        feederNameField.text = ""
    }
    
    //MARK: Exit Popup
    @objc func exitPopup() {
        
        mainViewController?.removeAddFeederPopup()
    }
}
