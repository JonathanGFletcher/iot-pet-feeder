//
//  EditFeedTimePopup.swift
//  PetFeederApp
//
//  Created by Jonathan Fletcher on 5/2/20.
//  Copyright © 2020 Jonathan Fletcher. All rights reserved.
//

import UIKit

//MARK: Edit Feed Time Popup
class EditFeedTimePopup: UIView {
    
    var date: Date? {
        
        didSet {
            
            if let date = date {
                
                timePicker.date = date
            }
        }
    }
    
    var mainViewController: FeederViewController?
    var timeIndex: Int?
    
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
    
    let editTimeLabel: UILabel = {
        
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 32)
        label.textColor = Color.darkCarbonGray
        label.textAlignment = .left
        label.text = "Edit Feed Time"
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let timePicker: UIDatePicker = {
        
        let dp = UIDatePicker()
        
        dp.datePickerMode = .time
        
        dp.translatesAutoresizingMaskIntoConstraints = false
        return dp
    }()
    
    let removeButton: UIButton = {
        
        let button = UIButton()
        
        button.setTitle(("Remove Time"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 27)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.setTitleColor(Color.darkerVibrantPurple, for: .normal)
        button.titleLabel?.textAlignment = .center
        
        button.addTarget(self, action: #selector(removeTime), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let updateButton: UIButton = {
        
        let button = UIButton()
        
        button.setTitle(("Update"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 27)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.setTitleColor(Color.darkerVibrantPurple, for: .normal)
        button.titleLabel?.textAlignment = .left
        
        button.addTarget(self, action: #selector(updateTime), for: .touchUpInside)
        
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
        
        popupBackground.addSubview(editTimeLabel)
        popupBackground.addSubview(timePicker)
        popupBackground.addSubview(removeButton)
        popupBackground.addSubview(updateButton)
        popupBackground.addSubview(exitButton)
        
        popupBackground.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        popupBackground.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -100).isActive = true
        popupBackground.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.85).isActive = true
        popupBackground.heightAnchor.constraint(equalToConstant: 294).isActive = true
        
        editTimeLabel.topAnchor.constraint(equalTo: popupBackground.topAnchor, constant: 8).isActive = true
        editTimeLabel.leadingAnchor.constraint(equalTo: popupBackground.leadingAnchor, constant: 8).isActive = true
        editTimeLabel.trailingAnchor.constraint(equalTo: popupBackground.trailingAnchor, constant: -8).isActive = true
        editTimeLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        timePicker.topAnchor.constraint(equalTo: editTimeLabel.bottomAnchor).isActive = true
        timePicker.leadingAnchor.constraint(equalTo: popupBackground.leadingAnchor).isActive = true
        timePicker.trailingAnchor.constraint(equalTo: popupBackground.trailingAnchor).isActive = true
        timePicker.heightAnchor.constraint(equalToConstant: 162).isActive = true
        
        removeButton.leadingAnchor.constraint(equalTo: popupBackground.leadingAnchor, constant: 8).isActive = true
        removeButton.trailingAnchor.constraint(equalTo: popupBackground.trailingAnchor, constant: -8).isActive = true
        removeButton.bottomAnchor.constraint(equalTo: updateButton.topAnchor, constant: -4).isActive = true
        removeButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        updateButton.leadingAnchor.constraint(equalTo: popupBackground.leadingAnchor, constant: 8).isActive = true
        updateButton.bottomAnchor.constraint(equalTo: popupBackground.bottomAnchor, constant: -16).isActive = true
        updateButton.widthAnchor.constraint(equalToConstant: 90).isActive = true
        updateButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        exitButton.trailingAnchor.constraint(equalTo: popupBackground.trailingAnchor, constant: -8).isActive = true
        exitButton.bottomAnchor.constraint(equalTo: popupBackground.bottomAnchor, constant: -16).isActive = true
        exitButton.widthAnchor.constraint(equalToConstant: 90).isActive = true
        exitButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    //MARK: Remove Time
    @objc func removeTime() {
        
        if let timeIndex = timeIndex {
            
            mainViewController?.removeFeedTime(timeIndex: timeIndex)
            mainViewController?.removeEditFeedTimePopup()
        }
    }
    
    //MARK: Update Time
    @objc func updateTime() {
        
        if let timeIndex = timeIndex {
            
            mainViewController?.updateFeedTime(timeIndex: timeIndex, date: timePicker.date)
            mainViewController?.removeEditFeedTimePopup()
        }
    }
    
    //MARK: Exit Popup
    @objc func exitPopup() {
        
        mainViewController?.removeEditFeedTimePopup()
    }
}
