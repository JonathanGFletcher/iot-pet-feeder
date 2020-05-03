//
//  ViewController.swift
//  PetFeederApp
//
//  Created by Jonathan Fletcher on 4/29/20.
//  Copyright © 2020 Jonathan Fletcher. All rights reserved.
//

import UIKit

//MARK: Main View Controller
class MainViewController: UIViewController {
    
    var user: User?
    var feeders: [Feeder] = []
    
    let feederCellId = "feederCellId"
    
    let topView: UIView = {
        
        let view = UIView()
        
        view.backgroundColor = Color.lightGray
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let logButton: UIButton = {
        
        let button = UIButton()
        
        button.setTitle((""), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 27)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.setTitleColor(Color.darkerVibrantPurple, for: .normal)
        button.titleLabel?.textAlignment = .left
        
        button.addTarget(self, action: #selector(log), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let addFeederButton: UIButton = {
        
        let button = UIButton()
        
        button.setTitle(("+"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 27)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.setTitleColor(Color.darkerVibrantPurple, for: .normal)
        button.titleLabel?.textAlignment = .right
        
        button.addTarget(self, action: #selector(addFeederTapped), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let statusIndicator: UIActivityIndicatorView = {
        
        let av = UIActivityIndicatorView()
        
        av.translatesAutoresizingMaskIntoConstraints = false
        return av
    }()
    
    lazy var mainCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        
        cv.backgroundColor = Color.lighterLightGray
        
        cv.contentInset = UIEdgeInsets(top: (view.frame.height / 3) - 60, left: 0, bottom: 0, right: 0)
        
        cv.translatesAutoresizingMaskIntoConstraints = false
        
        cv.dataSource = self
        cv.delegate = self
        
        return cv
    }()
    
    let addFeederPopup: AddFeederPopup = {
        
        let popup = AddFeederPopup()
        
        popup.translatesAutoresizingMaskIntoConstraints = false
        return popup
    }()
    
    let blurVisualEffectView: UIVisualEffectView = {
        
        let blurEffect = UIBlurEffect(style: .light)
        
        let view = UIVisualEffectView(effect: blurEffect)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: View Did Load
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        loadInitialData()
        setupCollectionView()
        setupViews()
    }
    
    //MARK: View Did Appear
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        let userId = UserDefaults.standard.object(forKey: "userId")
        
        if userId == nil {
            
            let loginController = LoginController()
            loginController.mainViewController = self
            
            present(loginController, animated: true, completion: nil)
        }
    }
    
    //MARK: Setup Views
    private func setupViews() {
        
        view.backgroundColor = Color.lightGray
        
        view.addSubview(topView)
        topView.addSubview(logButton)
        topView.addSubview(addFeederButton)
        topView.addSubview(statusIndicator)
        
        view.addSubview(mainCollectionView)
        view.addSubview(blurVisualEffectView)
        
        topView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        topView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        topView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        topView.heightAnchor.constraint(equalToConstant: 60 + view.safeAreaInsets.top).isActive = true
        
        logButton.topAnchor.constraint(equalTo: topView.safeAreaLayoutGuide.topAnchor, constant: 4).isActive = true
        logButton.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 8).isActive = true
        logButton.bottomAnchor.constraint(equalTo: topView.bottomAnchor, constant: -4).isActive = true
        logButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        statusIndicator.centerXAnchor.constraint(equalTo: topView.centerXAnchor).isActive = true
        statusIndicator.centerYAnchor.constraint(equalTo: topView.safeAreaLayoutGuide.centerYAnchor).isActive = true
        statusIndicator.widthAnchor.constraint(equalToConstant: 50).isActive = true
        statusIndicator.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        addFeederButton.topAnchor.constraint(equalTo: topView.safeAreaLayoutGuide.topAnchor, constant: 4).isActive = true
        addFeederButton.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -8).isActive = true
        addFeederButton.bottomAnchor.constraint(equalTo: topView.bottomAnchor, constant: -4).isActive = true
        addFeederButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        mainCollectionView.topAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true
        mainCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mainCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        mainCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        blurVisualEffectView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        blurVisualEffectView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        blurVisualEffectView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        blurVisualEffectView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        blurVisualEffectView.alpha = 0
    }
}

//MARK: Main Collection View
extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func setupCollectionView() {
        
        mainCollectionView.register(FeederCell.self, forCellWithReuseIdentifier: feederCellId)
    }
    
    func reloadCollectionView() {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        
        mainCollectionView.reloadData()
        mainCollectionView.collectionViewLayout = layout
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return feeders.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = mainCollectionView.dequeueReusableCell(withReuseIdentifier: feederCellId, for: indexPath) as! FeederCell
        
        cell.feeder = feeders[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let feederViewController = FeederViewController()
        feederViewController.feeder = feeders[indexPath.item]
        feederViewController.feederIndex = indexPath.item
        feederViewController.mainViewController = self
        
        present(feederViewController, animated: true, completion: nil)
    }
}
