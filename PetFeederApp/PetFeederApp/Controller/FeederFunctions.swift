//
//  FeederFunctions.swift
//  PetFeederApp
//
//  Created by Jonathan Fletcher on 5/2/20.
//  Copyright © 2020 Jonathan Fletcher. All rights reserved.
//

import UIKit

extension FeederViewController {
    
    //MARK: Setup Feed Times
    func setupFeedTimes() {
        
        if let feeder = feeder {
            
            feedTimeStrings = feeder.feedTimes?.components(separatedBy: ",")
            
            var newFeedTimes: [Date] = []
            
            if let timeStrings = feedTimeStrings {
                
                for timeString in timeStrings {
                    
                    if let time = Double(timeString) {
                        
                        newFeedTimes.append(Date(timeIntervalSince1970: TimeInterval(time)))
                    }
                }
            }
            
            feedTimes = newFeedTimes
        }
        
        if let feedTimes = feedTimes {
            
            if feedTimes.count > 0 {
                
                let nextTimeIndex = getNextTimeIndex(dates: feedTimes)
                
                nextFeedTimeLabel.text = getTimeString(date: feedTimes[nextTimeIndex])
                view.layoutIfNeeded()
            }
        }
    }
    
    //MARK: Remove Feeder Tapped
    @objc func removeFeederTapped() {
        
        if let feederIndex = feederIndex {
            
            mainViewController?.removeFeeder(feederIndex: feederIndex)
            dismiss(animated: true, completion: nil)
        }
    }
    
    //MARK: Add Feed Time Tapped
    @objc func addFeedTimeTapped() {
        
        addFeedTimePopup.mainViewController = self
        
        view.addSubview(addFeedTimePopup)
        
        addFeedTimePopup.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addFeedTimePopup.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        addFeedTimePopup.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        addFeedTimePopup.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        addFeedTimePopup.alpha = 0
        addFeedTimePopup.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.addFeedTimePopup.alpha = 1
            self.blurVisualEffectView.alpha = 1
            self.addFeedTimePopup.transform = CGAffineTransform.identity
            
        }, completion: nil)
        
        view.layoutIfNeeded()
    }
    
    //MARK: Edit Feed Time Tapped
    func editFeedTimeTapped() {
        
        editFeedTimePopup.mainViewController = self
        
        view.addSubview(editFeedTimePopup)
        
        editFeedTimePopup.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        editFeedTimePopup.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        editFeedTimePopup.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        editFeedTimePopup.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        editFeedTimePopup.alpha = 0
        editFeedTimePopup.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.editFeedTimePopup.alpha = 1
            self.blurVisualEffectView.alpha = 1
            self.editFeedTimePopup.transform = CGAffineTransform.identity
            
        }, completion: nil)
        
        view.layoutIfNeeded()
    }
    
    //MARK: Remove Add Feed Time Popup
    func removeAddFeedTimePopup() {
        
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.addFeedTimePopup.alpha = 0
            self.blurVisualEffectView.alpha = 0
            self.addFeedTimePopup.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            
        }) { (_) in
            
            self.addFeedTimePopup.removeFromSuperview()
        }
    }
    
    //MARK: Remove Edit Feed Time Popup
    func removeEditFeedTimePopup() {
        
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.editFeedTimePopup.alpha = 0
            self.blurVisualEffectView.alpha = 0
            self.editFeedTimePopup.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            
        }) { (_) in
            
            self.editFeedTimePopup.removeFromSuperview()
        }
    }
    
    //MARK: Add Feed Time
    func addFeedTime(date: Date) {
        
        if let feedTimes = feedTimes {
            
            var foundTime: Bool = false
            
            for feedTime in feedTimes {
                
                let calendar = Calendar.current
                let newHour = calendar.component(.hour, from: date)
                let newMinute = calendar.component(.minute, from: date)
                let hour = calendar.component(.hour, from: feedTime)
                let minute = calendar.component(.minute, from: feedTime)
                
                if newHour == hour && newMinute == minute {
                    
                    foundTime = true
                }
            }
            
            if foundTime {
                
                let alert = UIAlertController(title: "Invalid Time", message: "This time is already within your schedule!", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { (action) in
                    
                    alert.dismiss(animated: true, completion: nil)
                }))
                
                present(alert, animated: true, completion: nil)
            }
            else {
                
                let now = Date()
                var newDate: Date = date
                
                while newDate <= now {
                    
                    newDate += 86400
                }
                
                if let currentFeedTimes = feeder?.feedTimes {
                    
                    if currentFeedTimes == "" {
                        
                        feeder?.feedTimes = "\(newDate.timeIntervalSince1970)"
                    }
                    else {
                        
                        var newFeedTimes = currentFeedTimes
                        newFeedTimes += ",\(newDate.timeIntervalSince1970)"
                        
                        feeder?.feedTimes = newFeedTimes
                    }
                }
                else {
                    
                    feeder?.feedTimes = "\(newDate.timeIntervalSince1970)"
                }
                
                setupFeedTimes()
                reloadCollectionView()
                
                if let feeder = feeder, let feederIndex = feederIndex {
                    
                    mainViewController?.updateFeeder(feeder: feeder, index: feederIndex)
                }
            }
        }
    }
    
    //MARK: Remove Feed Time
    func removeFeedTime(timeIndex: Int) {
        
        var newFeedTimes: [Date] = []
        var newFeedTimesString: String = ""
        
        if let feedTimes = feedTimes {
            
            for (index, feedTime) in feedTimes.enumerated() {
                
                if index != timeIndex {
                    
                    newFeedTimes.append(feedTime)
                }
            }
        }
        
        for (index, time) in newFeedTimes.enumerated() {
            
            if index != newFeedTimes.count - 1 {
                
                newFeedTimesString += "\(time.timeIntervalSince1970),"
            }
            else {
                
                newFeedTimesString += "\(time.timeIntervalSince1970)"
            }
        }
        
        feeder?.feedTimes = newFeedTimesString
        
        setupFeedTimes()
        reloadCollectionView()
        
        if let feeder = feeder, let feederIndex = feederIndex {
            
            mainViewController?.updateFeeder(feeder: feeder, index: feederIndex)
        }
    }
    
    //MARK: Update Feed Time
    func updateFeedTime(timeIndex: Int, date: Date) {
        
        var newFeedTimes: [Date] = []
        var newFeedTimesString: String = ""
        
        if let feedTimes = feedTimes {
            
            for (index, feedTime) in feedTimes.enumerated() {
                
                if index == timeIndex {
                    
                    newFeedTimes.append(date)
                }
                else {
                    
                    newFeedTimes.append(feedTime)
                }
            }
        }
        
        for (index, time) in newFeedTimes.enumerated() {
            
            if index != newFeedTimes.count - 1 {
                
                newFeedTimesString += "\(time.timeIntervalSince1970),"
            }
            else {
                
                newFeedTimesString += "\(time.timeIntervalSince1970)"
            }
        }
        
        feeder?.feedTimes = newFeedTimesString
        
        setupFeedTimes()
        reloadCollectionView()
        
        if let feeder = feeder, let feederIndex = feederIndex {
            
            mainViewController?.updateFeeder(feeder: feeder, index: feederIndex)
        }
    }
    
    //MARK: Feed Now
    @objc func feedNow() {
        
        if feeder?.feedOverride != 0 {
            
            let alert = UIAlertController(title: "Already feeding!", message: "Feed override has already been set.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { (action) in
                
                alert.dismiss(animated: true, completion: nil)
            }))
            
            present(alert, animated: true, completion: nil)
        }
        else {
            
            let alert = UIAlertController(title: "Feed Now?", message: "Would you like to manually feed?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (_) in
                
                self.feeder?.feedOverride = 1
                
                if let feeder = self.feeder, let feederIndex = self.feederIndex {
                    
                    self.mainViewController?.updateFeeder(feeder: feeder, index: feederIndex)
                }
                
                alert.dismiss(animated: true, completion: nil)
            }))
            
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { (_) in
                
                alert.dismiss(animated: true, completion: nil)
            }))
            
            present(alert, animated: true, completion: nil)
        }
    }
}
