//
//  FeederViewController.swift
//  PetFeederApp
//
//  Created by Jonathan Fletcher on 4/30/20.
//  Copyright © 2020 Jonathan Fletcher. All rights reserved.
//

import UIKit

//MARK: Feeder View Controller
class FeederViewController: UIViewController {
    
    var feeder: Feeder? {
        
        didSet {
            
            if let feederId = feeder?.feederId {
                
                feederIdLabel.text = feederId
            }
        }
    }
    
    var feederIndex: Int?
    var feedTimeStrings: [String]?
    var feedTimes: [Date]?
    
    weak var mainViewController: MainViewController?
    
    let topView: UIView = {
        
        let view = UIView()
        
        view.backgroundColor = Color.lightGray
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let bottomView: UIView = {
        
        let view = UIView()
        
        view.backgroundColor = Color.lightGray
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let feederIdLabel: UILabel = {
        
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 36)
        label.textColor = Color.darkCarbonGray
        label.textAlignment = .left
        label.text = "FeederId"
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nextFeedLabel: UILabel = {
        
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 24, weight: .light)
        label.textColor = Color.lighterDarkCarbonGray
        label.textAlignment = .left
        label.text = "Next Scheduled Feed:"
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nextFeedTimeLabel: UILabel = {
        
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 24)
        label.textColor = Color.lighterDarkCarbonGray
        label.textAlignment = .right
        label.text = "N/A"
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let feedNowButton: UIButton = {
        
        let button = UIButton()
        
        button.setTitle(("Feed Now"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 27)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.setTitleColor(Color.darkerVibrantPurple, for: .normal)
        button.titleLabel?.textAlignment = .left
        
        button.addTarget(self, action: #selector(feedNow), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let removeFeederButton: UIButton = {
        
        let button = UIButton()
        
        button.setTitle(("Remove Feeder"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 27)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.setTitleColor(Color.darkerVibrantPurple, for: .normal)
        button.titleLabel?.textAlignment = .center
        
        button.addTarget(self, action: #selector(removeFeederTapped), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let scheduleHeaderView: UIView = {
        
        let view = UIView()
        
        view.backgroundColor = Color.darkerLightGray
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let scheduleLabel: UILabel = {
        
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 24)
        label.textColor = Color.lighterDarkCarbonGray
        label.textAlignment = .left
        label.text = "Schedule"
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let addFeedTimeButton: UIButton = {
        
        let button = UIButton()
        
        button.setTitle(("+"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 27)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.setTitleColor(Color.darkerVibrantPurple, for: .normal)
        button.titleLabel?.textAlignment = .right
        
        button.addTarget(self, action: #selector(addFeedTimeTapped), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let feedTimeCellId = "feedTimeCellId"
    
    lazy var timesCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 1
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = Color.lightGray
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        
        cv.translatesAutoresizingMaskIntoConstraints = false
        
        cv.dataSource = self
        cv.delegate = self
        
        return cv
    }()
    
    let addFeedTimePopup: AddFeedTimePopup = {
        
        let popup = AddFeedTimePopup()
        
        popup.translatesAutoresizingMaskIntoConstraints = false
        return popup
    }()
    
    let editFeedTimePopup: EditFeedTimePopup = {
        
        let popup = EditFeedTimePopup()
        
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
        
        setupFeedTimes()
        setupCollectionView()
        setupViews()
    }
    
    //MARK: Setup Views
    private func setupViews() {
        
        view.backgroundColor = Color.lighterLightGray
        
        view.addSubview(topView)
        topView.addSubview(feederIdLabel)
        topView.addSubview(nextFeedLabel)
        topView.addSubview(nextFeedTimeLabel)
        topView.addSubview(feedNowButton)
        
        view.addSubview(scheduleHeaderView)
        scheduleHeaderView.addSubview(scheduleLabel)
        scheduleHeaderView.addSubview(addFeedTimeButton)
        
        view.addSubview(timesCollectionView)
        
        view.addSubview(bottomView)
        bottomView.addSubview(removeFeederButton)
        
        view.addSubview(blurVisualEffectView)
        
        topView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        topView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        topView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        topView.heightAnchor.constraint(equalToConstant: CGFloat(view.frame.height / 2)).isActive = true
        
        feederIdLabel.topAnchor.constraint(equalTo: topView.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        feederIdLabel.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 8).isActive = true
        feederIdLabel.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -8).isActive = true
        feederIdLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        nextFeedLabel.topAnchor.constraint(equalTo: feederIdLabel.bottomAnchor, constant: 2).isActive = true
        nextFeedLabel.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 8).isActive = true
        nextFeedLabel.trailingAnchor.constraint(equalTo: nextFeedTimeLabel.leadingAnchor).isActive = true
        nextFeedLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        nextFeedTimeLabel.topAnchor.constraint(equalTo: feederIdLabel.bottomAnchor, constant: 2).isActive = true
        nextFeedTimeLabel.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -8).isActive = true
        nextFeedTimeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        nextFeedTimeLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        feedNowButton.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 8).isActive = true
        feedNowButton.bottomAnchor.constraint(equalTo: topView.bottomAnchor, constant: -4).isActive = true
        feedNowButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        feedNowButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        scheduleHeaderView.topAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true
        scheduleHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scheduleHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scheduleHeaderView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        scheduleLabel.topAnchor.constraint(equalTo: scheduleHeaderView.topAnchor).isActive = true
        scheduleLabel.leadingAnchor.constraint(equalTo: scheduleHeaderView.leadingAnchor, constant: 8).isActive = true
        scheduleLabel.trailingAnchor.constraint(equalTo: addFeedTimeButton.leadingAnchor).isActive = true
        scheduleLabel.bottomAnchor.constraint(equalTo: scheduleHeaderView.bottomAnchor).isActive = true
        
        addFeedTimeButton.topAnchor.constraint(equalTo: scheduleHeaderView.topAnchor).isActive = true
        addFeedTimeButton.trailingAnchor.constraint(equalTo: scheduleHeaderView.trailingAnchor, constant: -8).isActive = true
        addFeedTimeButton.bottomAnchor.constraint(equalTo: scheduleHeaderView.bottomAnchor).isActive = true
        addFeedTimeButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        timesCollectionView.topAnchor.constraint(equalTo: scheduleHeaderView.bottomAnchor).isActive = true
        timesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        timesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        timesCollectionView.bottomAnchor.constraint(equalTo: bottomView.topAnchor).isActive = true
        
        bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        bottomView.heightAnchor.constraint(equalToConstant: 60 + view.safeAreaInsets.bottom).isActive = true
        
        removeFeederButton.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 4).isActive = true
        removeFeederButton.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 8).isActive = true
        removeFeederButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -8).isActive = true
        removeFeederButton.bottomAnchor.constraint(equalTo: bottomView.safeAreaLayoutGuide.bottomAnchor, constant: -4).isActive = true
        
        blurVisualEffectView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        blurVisualEffectView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        blurVisualEffectView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        blurVisualEffectView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        blurVisualEffectView.alpha = 0
    }
}

//MARK: Times Collection View
extension FeederViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func setupCollectionView() {
        
        timesCollectionView.register(FeedTimeCell.self, forCellWithReuseIdentifier: feedTimeCellId)
    }
    
    func reloadCollectionView() {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        
        timesCollectionView.reloadData()
        timesCollectionView.collectionViewLayout = layout
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return feedTimes?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = timesCollectionView.dequeueReusableCell(withReuseIdentifier: feedTimeCellId, for: indexPath) as! FeedTimeCell
        
        if let feedTimes = feedTimes {
            
            cell.date = feedTimes[indexPath.item]
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let feedTimes = feedTimes {
            
            editFeedTimePopup.date = feedTimes[indexPath.item]
            editFeedTimePopup.timeIndex = indexPath.item
        }
        
        editFeedTimeTapped()
    }
}
