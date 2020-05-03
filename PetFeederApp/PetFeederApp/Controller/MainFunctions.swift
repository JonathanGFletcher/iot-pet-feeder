//
//  FeederFunctions.swift
//  PetFeederApp
//
//  Created by Jonathan Fletcher on 4/29/20.
//  Copyright © 2020 Jonathan Fletcher. All rights reserved.
//

import UIKit

extension MainViewController {
    
    //MARK: Load Initial Data
    func loadInitialData() {
        
        let userId = UserDefaults.standard.object(forKey: "userId")
        
        if userId != nil {
            
            logButton.setTitle(("Logout"), for: .normal)
            loadUserData()
        }
        else {
            
            logButton.setTitle(("Login"), for: .normal)
        }
    }
    
    //MARK: Load User Data
    func loadUserData() {
        
        if let user = user {
            
            if let userFeeders = user.feeders {
                
                feeders = userFeeders
            }
        }
        else {
            
            statusIndicator.isHidden = false
            statusIndicator.startAnimating()
            
            let userId = UserDefaults.standard.object(forKey: "userId")
            let userToken = UserDefaults.standard.object(forKey: "userToken")
            
            if let userIdString = userId as? String, let userTokenString = userToken as? String {
                
                let urlString: String = "https://iotpetfeederdatamanager.azurewebsites.net/api/users/" + userIdString
                
                guard let url = URL(string: urlString) else { return }
                
                var request = URLRequest(url: url)
                request.httpMethod = "GET"
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue("bearer \(userTokenString)", forHTTPHeaderField: "Authorization")
                
                let session = URLSession.shared
                session.dataTask(with: request) { (data, response, error) in
                    
                    if let response = response as? HTTPURLResponse {
                        
                        if response.statusCode == 200 {
                            
                            if let data = data {
                                
                                do {
                                    
                                    let newUser = try JSONDecoder().decode(User.self, from: data)
                                    
                                    self.user = newUser
                                    
                                    if let newUserFeeders = newUser.feeders {
                                        
                                        self.feeders = newUserFeeders
                                        
                                        DispatchQueue.main.async {
                                            
                                            self.reloadCollectionView()
                                            
                                            self.statusIndicator.stopAnimating()
                                            self.statusIndicator.isHidden = true
                                        }
                                    }
                                }
                                catch {
                                    
                                    print(error)
                                }
                            }
                        }
                        else {
                            
                            // Error popup, not 200 code
                        }
                    }
                }.resume()
            }
        }
    }
    
    //MARK: Add Feeder Tapped
    @objc func addFeederTapped() {
        
        addFeederPopup.mainViewController = self
        
        view.addSubview(addFeederPopup)
        
        addFeederPopup.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addFeederPopup.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        addFeederPopup.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        addFeederPopup.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        addFeederPopup.alpha = 0
        addFeederPopup.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.addFeederPopup.alpha = 1
            self.blurVisualEffectView.alpha = 1
            self.addFeederPopup.transform = CGAffineTransform.identity
            
        }, completion: nil)
        
        view.layoutIfNeeded()
    }
    
    //MARK: Remove Add Feeder Popup
    func removeAddFeederPopup() {
        
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.addFeederPopup.alpha = 0
            self.blurVisualEffectView.alpha = 0
            self.addFeederPopup.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            
        }) { (_) in
            
            self.addFeederPopup.removeFromSuperview()
        }
    }
    
    //MARK: Add Feeder
    func addFeeder(feeder: Feeder) {
        
        feeders.append(feeder)
        
        let userId = UserDefaults.standard.object(forKey: "userId")
        let userToken = UserDefaults.standard.object(forKey: "userToken")
        
        if let userIdString = userId as? String, let userTokenString = userToken as? String {
            
            var urlString: String = "https://iotpetfeederdatamanager.azurewebsites.net/api/users/addfeeder"
            urlString += "/" + userIdString
            
            let parameters = ["feederId": feeder.feederId]
            guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
            
            guard let url = URL(string: urlString) else { return }
            
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("bearer \(userTokenString)", forHTTPHeaderField: "Authorization")
            request.httpBody = httpBody
            
            let session = URLSession.shared
            session.dataTask(with: request) { (data, response, error) in
                
                if let response = response as? HTTPURLResponse {
                    
                    if response.statusCode == 200 {
                        
                        // Successfully added feeder popup
                    }
                    else {
                        
                        print("Failed to add feeder.")
                    }
                }
            }.resume()
        }
        
        reloadCollectionView()
        
        let alert = UIAlertController(title: "Added Feeder", message: "Your new feeder has been added.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { (action) in
            
            alert.dismiss(animated: true, completion: nil)
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: Remove Feeder
    func removeFeeder(feederIndex: Int) {
        
        var updatedFeeders: [Feeder] = []
        
        for (index, feeder) in feeders.enumerated() {
            
            if index != feederIndex {
                
                updatedFeeders.append(feeder)
            }
        }
        
        let userId = UserDefaults.standard.object(forKey: "userId")
        let userToken = UserDefaults.standard.object(forKey: "userToken")
        let feederId = feeders[feederIndex].id
        
        if let userIdString = userId as? String, let userTokenString = userToken as? String {
            
            var urlString: String = "https://iotpetfeederdatamanager.azurewebsites.net/api/users/removefeeder"
            urlString += "/" + userIdString
            urlString += "/" + feederId
            
            guard let url = URL(string: urlString) else { return }
            
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("bearer \(userTokenString)", forHTTPHeaderField: "Authorization")
            
            let session = URLSession.shared
            session.dataTask(with: request) { (data, response, error) in
                
                if let response = response as? HTTPURLResponse {
                    
                    if response.statusCode == 200 {
                        
                        // Successfully removed feeder popup
                    }
                    else {
                        
                        print("Failed to remove feeder.")
                    }
                }
            }.resume()
        }
        
        feeders = updatedFeeders
        
        reloadCollectionView()
        
        let alert = UIAlertController(title: "Removed Feeder", message: "The feeder you selected has been removed.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { (action) in
            
            alert.dismiss(animated: true, completion: nil)
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: Update Feeder
    func updateFeeder(feeder: Feeder, index: Int) {
        
        statusIndicator.isHidden = false
        statusIndicator.startAnimating()
        
        feeders[index] = feeder
        
        let userToken = UserDefaults.standard.object(forKey: "userToken")
        let feederId = feeders[index].id
        
        if let userTokenString = userToken as? String {
            
            var urlString: String = "https://iotpetfeederdatamanager.azurewebsites.net/api/feeders"
            urlString += "/" + feederId
            
            guard let url = URL(string: urlString) else { return }
            
            let jsonEncoder = JSONEncoder()
            guard let httpBody = try? jsonEncoder.encode(feeder) else { return }
            
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("bearer \(userTokenString)", forHTTPHeaderField: "Authorization")
            request.httpBody = httpBody
            
            let session = URLSession.shared
            session.dataTask(with: request) { (data, response, error) in
                
                if let response = response as? HTTPURLResponse {
                    
                    if response.statusCode == 204 {
                        
                        DispatchQueue.main.async {
                            
                            self.user = nil
                            self.loadUserData()
                            self.reloadCollectionView()
                            
                            self.statusIndicator.stopAnimating()
                            self.statusIndicator.isHidden = true
                        }
                    }
                    else {
                        
                        print("Code: ", response.statusCode)
                        print("Failed to update feeder.")
                    }
                }
            }.resume()
        }
    }
    
    //MARK: Log
    @objc func log() {
        
        let userId = UserDefaults.standard.object(forKey: "userId")
        let userToken = UserDefaults.standard.object(forKey: "userToken")
        
        if userId != nil && userToken != nil {
            
            print("Logging out.")
            UserDefaults.standard.set(nil, forKey: "userId")
            UserDefaults.standard.set(nil, forKey: "userToken")
            
            user = nil
            feeders = []
            
            logButton.setTitle("Login", for: .normal)
            view.layoutIfNeeded()
            
            let loginController = LoginController()
            loginController.mainViewController = self
            
            reloadCollectionView()
            
            present(loginController, animated: true, completion: nil)
        }
        else {
            
            let loginController = LoginController()
            loginController.mainViewController = self
            
            reloadCollectionView()
            
            present(loginController, animated: true, completion: nil)
        }
    }
}
