//
//  LoginController.swift
//  PetFeederApp
//
//  Created by Jonathan Fletcher on 4/29/20.
//  Copyright © 2020 Jonathan Fletcher. All rights reserved.
//

import UIKit

//MARK: Login Controller
class LoginController: UIViewController {
    
    var mainViewController: MainViewController?
    
    let loginLabel: UILabel = {
        
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 48)
        label.textColor = Color.darkCarbonGray
        label.textAlignment = .left
        label.text = "Login"
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let emailAddressField: UITextField = {
        
        let tf = UITextField()
        
        tf.font = UIFont.systemFont(ofSize: 24)
        tf.textColor = Color.darkCarbonGray
        tf.borderStyle = .roundedRect
        tf.placeholder = "Email Address"
        
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let passwordField: UITextField = {
        
        let tf = UITextField()
        
        tf.font = UIFont.systemFont(ofSize: 24)
        tf.textColor = Color.darkCarbonGray
        tf.borderStyle = .roundedRect
        tf.placeholder = "Password"
        
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        tf.isSecureTextEntry = true
        
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let loginButton: UIButton = {
        
        let button = UIButton()
        
        button.setTitle(("Login"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 32)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.setTitleColor(Color.lighterDarkCarbonGray, for: .normal)
        button.titleLabel?.textAlignment = .left
        
        button.addTarget(self, action: #selector(login), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //MARK: View Did Load
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupViews()
    }
    
    //MARK: Setup Views
    private func setupViews() {
        
        view.backgroundColor = Color.lighterLightGray
        
        view.addSubview(loginLabel)
        view.addSubview(emailAddressField)
        view.addSubview(passwordField)
        view.addSubview(loginButton)
        
        loginLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        loginLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        loginLabel.heightAnchor.constraint(equalToConstant: 52).isActive = true
        loginLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        emailAddressField.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 32).isActive = true
        emailAddressField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        emailAddressField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        emailAddressField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        passwordField.topAnchor.constraint(equalTo: emailAddressField.bottomAnchor, constant: 4).isActive = true
        passwordField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        passwordField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        passwordField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        loginButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 8).isActive = true
        loginButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 33).isActive = true
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    //MARK: Login
    @objc func login() {
        
        mainViewController?.statusIndicator.isHidden = false
        mainViewController?.statusIndicator.startAnimating()
        
        guard let emailAddress = emailAddressField.text, let password = passwordField.text else { return }
        
        if isValidEmailAddress(emailAddressString: emailAddress) && password.count > 5 {
            
            guard let url = URL(string: "https://iotpetfeederdatamanager.azurewebsites.net/api/users/register") else { return }
            
            let parameters = ["emailAddress": emailAddress, "password": password]
            guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = httpBody
            
            let session = URLSession.shared
            session.dataTask(with: request) { (data, response, error) in
                
                if let response = response as? HTTPURLResponse {
                    
                    if response.statusCode == 200 {
                        
                        if let data = data {
                            
                            do {
                                
                                let newUser = try JSONDecoder().decode(User.self, from: data)
                                
                                self.mainViewController?.user = newUser
                                
                                if let feeders = newUser.feeders {
                                    
                                    self.mainViewController?.feeders = feeders
                                }
                                
                                UserDefaults.standard.set(newUser.id, forKey: "userId")
                                UserDefaults.standard.set(newUser.token, forKey: "userToken")
                                
                                DispatchQueue.main.async {
                                    
                                    self.mainViewController?.logButton.setTitle("Logout", for: .normal)
                                    self.mainViewController?.view.layoutIfNeeded()
                                    
                                    self.mainViewController?.reloadCollectionView()
                                    
                                    self.mainViewController?.statusIndicator.stopAnimating()
                                    self.mainViewController?.statusIndicator.isHidden = true
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
        
        self.dismiss(animated: true) {
            
            self.mainViewController?.reloadCollectionView()
        }
    }
    
    //MARK: Is Valid Email Address
    func isValidEmailAddress(emailAddressString: String) -> Bool {
        
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailAddressString as NSString
            let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0 {
                
                returnValue = false
            }
            
        }
        catch let error as NSError {
            
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        
        return returnValue
    }
}
