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
  var descriptionLbl: UILabel!
  
  // MARK: Properties
  var movieId: Int!
  var movieInfo: MovieInfo!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.createUI()
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
    watchedSw.isOn = false
    self.view.addSubview(watchedSw)
  
    descriptionLbl = UILabel()
    descriptionLbl.font = .systemFont(ofSize: 15)
    descriptionLbl.textColor = .gray
    descriptionLbl.numberOfLines = 5
    self.view.addSubview(descriptionLbl)
    
    movieCoverImgView.backgroundColor = .gray
    movieTitleBtn.setTitle("HAHAHA", for: .normal)
    categoryLbl.text = "OHOH"
    yearLbl.text = "1986"
    descriptionLbl.text = "1234567890qwertyuiop[asdfgjklxcvbnm234567890qwertyuiop[asdfghjklxcvbnm1234567890poiuytrewqasdfgjklmbvcxzasdfjkjklasdfjklasdfjkladfjkladfjkladsfjkladsfjkaldsfjkaldfjnm234567890qwertyuiop[asdfghjklxcvbnm1234567890poiuytrewqasdfgjklmbvcxzasdfjkjklasdfjklasdfjkladfjkladfjkladsfjkladsfjkaldsfjkaldfj"
    
    self.addConstraints()
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
    
    descriptionLbl.snp.makeConstraints { (make) in
      make.bottom.equalTo(self.view.snp_bottomMargin).offset(-80)
      make.centerX.equalTo(self.view)
      make.width.equalTo(self.view).multipliedBy(0.8)
    }
  }
  
  @objc func movieTitleButtonPressed(sender: UIButton) {
    print("movieTitleButtonPressed")
  }
}
