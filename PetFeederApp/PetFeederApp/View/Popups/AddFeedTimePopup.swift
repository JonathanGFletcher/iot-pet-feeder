//
//  AddFeedTimePopup.swift
//  PetFeederApp
//
//  Created by Jonathan Fletcher on 5/2/20.
//  Copyright © 2020 Jonathan Fletcher. All rights reserved.
//

import UIKit

//MARK: Add Feed Time Popup
class AddFeedTimePopup: UIView {
    
    var mainViewController: FeederViewController?
    
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
    
    let addTimeLabel: UILabel = {
        
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 32)
        label.textColor = Color.darkCarbonGray
        label.textAlignment = .left
        label.text = "Add Feed Time"
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let timePicker: UIDatePicker = {
        
        let dp = UIDatePicker()
        
        dp.datePickerMode = .time
        
        dp.translatesAutoresizingMaskIntoConstraints = false
        return dp
    }()
    
    let addButton: UIButton = {
        
        let button = UIButton()
        
        button.setTitle(("Add"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 27)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.setTitleColor(Color.darkerVibrantPurple, for: .normal)
        button.titleLabel?.textAlignment = .left
        
        button.addTarget(self, action: #selector(addTime), for: .touchUpInside)
        
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
        
        popupBackground.addSubview(addTimeLabel)
        popupBackground.addSubview(timePicker)
        popupBackground.addSubview(addButton)
        popupBackground.addSubview(exitButton)
        
        popupBackground.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        popupBackground.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -100).isActive = true
        popupBackground.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.85).isActive = true
        popupBackground.heightAnchor.constraint(equalToConstant: 260).isActive = true
        
        addTimeLabel.topAnchor.constraint(equalTo: popupBackground.topAnchor, constant: 8).isActive = true
        addTimeLabel.leadingAnchor.constraint(equalTo: popupBackground.leadingAnchor, constant: 8).isActive = true
        addTimeLabel.trailingAnchor.constraint(equalTo: popupBackground.trailingAnchor, constant: -8).isActive = true
        addTimeLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        timePicker.topAnchor.constraint(equalTo: addTimeLabel.bottomAnchor).isActive = true
        timePicker.leadingAnchor.constraint(equalTo: popupBackground.leadingAnchor).isActive = true
        timePicker.trailingAnchor.constraint(equalTo: popupBackground.trailingAnchor).isActive = true
        timePicker.heightAnchor.constraint(equalToConstant: 162).isActive = true
        
        addButton.leadingAnchor.constraint(equalTo: popupBackground.leadingAnchor, constant: 8).isActive = true
        addButton.bottomAnchor.constraint(equalTo: popupBackground.bottomAnchor, constant: -16).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        exitButton.trailingAnchor.constraint(equalTo: popupBackground.trailingAnchor, constant: -8).isActive = true
        exitButton.bottomAnchor.constraint(equalTo: popupBackground.bottomAnchor, constant: -16).isActive = true
        exitButton.widthAnchor.constraint(equalToConstant: 90).isActive = true
        exitButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    //MARK: Add Time
    @objc func addTime() {
        
        mainViewController?.addFeedTime(date: timePicker.date)
        mainViewController?.removeAddFeedTimePopup()
    }
    
    //MARK: Exit Popup
    @objc func exitPopup() {
        
        mainViewController?.removeAddFeedTimePopup()
    }
}
