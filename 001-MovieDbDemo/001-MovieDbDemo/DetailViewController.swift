//
//  DetailViewController.swift
//  001-MovieDbDemo
//
//  Created by 雲端開發部-江世豪 on 2019/2/14.
//  Copyright © 2019 com.mitake. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

  // MARK: UI
  var movieCoverImgView: UIImageView!
  var movieTitleBtn: UIButton!
  var categoryLbl: UILabel!
  var yearLbl: UILabel!
  var watchedSw: UISwitch!
  var likesSt: UIStepper!
  var descriptionLbl: UILabel!
  
  // MARK: Properties
  var movieId: Int!
  var movieInfo: MovieInfo!
  
  // MARK: UI
  
  override func viewDidLoad() {
    super.viewDidLoad()
    createUI()
  }
  
  func createUI() {
    movieCoverImgView = UIImageView()
    self.view.addSubview(movieCoverImgView)
    
    movieTitleBtn = UIButton(type: .system)
    movieTitleBtn.addTarget(self, action: #selector(movieTitleButtonPressed), for: .touchUpInside)
    movieTitleBtn.titleLabel?.font = .systemFont(ofSize: 20)
    self.view.addSubview(movieTitleBtn)
    
    categoryLbl = UILabel()
    categoryLbl.font = .boldSystemFont(ofSize: 18)
    self.view.addSubview(categoryLbl)
    
    yearLbl = UILabel()
    yearLbl.font = .systemFont(ofSize: 17)
    self.view.addSubview(yearLbl)
    
    watchedSw = UISwitch()
    watchedSw.addTarget(self, action: #selector(watchedStatusChanged), for: .valueChanged)
    self.view.addSubview(watchedSw)
  
    likesSt = UIStepper()
    likesSt.addTarget(self, action: #selector(numberOfLikesChanged), for: .valueChanged)
    self.view.addSubview(likesSt)
    
    descriptionLbl = UILabel()
    descriptionLbl.font = .systemFont(ofSize: 15)
    descriptionLbl.textColor = .gray
    descriptionLbl.numberOfLines = 5
    self.view.addSubview(descriptionLbl)
    
    movieCoverImgView.backgroundColor = .gray
    movieTitleBtn.setTitle("HAHAHA", for: .normal)
    categoryLbl.text = "OHOH"
    yearLbl.text = "1986"
    likesSt.value = 2.0
    descriptionLbl.text = "1234567890qwertyuiop[asdfgjklxcvbnm234567890qwertyuiop[asdfghjklxcvbnm1234567890poiuytrewqasdfgjklmbvcxzasdfjkjklasdfjklasdfjkladfjkladfjkladsfjkladsfjkaldsfjk"
    
    addConstraints()
  }

  func addConstraints() {
    movieCoverImgView.snp.makeConstraints { (make) in
      make.top.equalTo(self.view.snp_topMargin).offset(20)
      make.centerX.equalTo(self.view)
      make.width.equalTo(150)
      make.height.equalTo(200)
    }
    
    movieTitleBtn.snp.makeConstraints { (make) in
      make.top.equalTo(movieCoverImgView.snp_bottomMargin).offset(20)
      make.centerX.equalTo(self.view)
    }
    
    categoryLbl.snp.makeConstraints { (make) in
      make.top.equalTo(movieTitleBtn.snp_bottomMargin).offset(20)
      make.centerX.equalTo(self.view)
    }

    yearLbl.snp.makeConstraints { (make) in
      make.top.equalTo(categoryLbl.snp_bottomMargin).offset(20)
      make.centerX.equalTo(self.view)
    }

    watchedSw.snp.makeConstraints { (make) in
      make.top.equalTo(yearLbl.snp_bottomMargin).offset(50)
      make.centerX.equalTo(self.view)
    }

    likesSt.snp.makeConstraints { (make) in
      make.top.equalTo(watchedSw.snp_bottomMargin).offset(30)
      make.centerX.equalTo(self.view)
    }
    
    descriptionLbl.snp.makeConstraints { (make) in
      make.bottom.equalTo(self.view.snp_bottomMargin).offset(-40)
      make.centerX.equalTo(self.view)
      make.width.equalTo(self.view).multipliedBy(0.8)
    }
  }
  
  // MARK: Action
  
  @objc func movieTitleButtonPressed(sender: UIButton) {
    print("movieTitleButtonPressed")
  }
  
  @objc func watchedStatusChanged(sender: UISwitch) {
    print("watchedStatusChanged to \(sender.isOn)")
    movieInfo.watched = watchedSw.isOn
  }
  
  @objc func numberOfLikesChanged(sender: UIStepper) {
    print("numberOfLikesChanged to \(sender.value)")
    movieInfo.likes = Int(likesSt.value)
    descriptionLbl.text = messageForLikes()
  }
  
  
  // MARK: Methods
  
  func setValuesToViews() {
    let session = URLSession(configuration: .default)
    let url = URL(string: movieInfo.coverURL)
    
    session.dataTask(with: url!) { (fetchedData, response, error) in
      DispatchQueue.main.async {
        if let data = fetchedData {
          self.movieCoverImgView.image = UIImage(data: data)
        }
      }
    }
    
    movieTitleBtn.setTitle(movieInfo.title, for: .normal)
    categoryLbl.text = movieInfo.category
    yearLbl.text = String(movieInfo.year)
    watchedSw.isOn = movieInfo.watched
    likesSt.value = Double(movieInfo.likes)
    descriptionLbl.text = messageForLikes()
  }
  
  func messageForLikes() -> String {
    switch movieInfo.likes {
    case 0:
      return "I didn't like it at all."
    case 1:
      return "Interesting, but not exciting."
    case 2:
      return "Nice movie!"
    default:
      return "I loved it!"
    }
  }
}
