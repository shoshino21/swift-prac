//
//  ListViewController.swift
//  001-MovieDbDemo
//
//  Created by 雲端開發部-江世豪 on 2019/2/14.
//  Copyright © 2019 com.mitake. All rights reserved.
//

import UIKit
import SnapKit

struct MovieInfo {
  var movieId: Int!
  var title: String!
  var category: String!
  var year: Int!
  var movieURL: String!
  var coverURL: String!
  var watched: Bool!
}

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  // MARK: UI
  
  var movieListTable: UITableView!
  // 一定是 var，用 let 就無法在之後 viewDidLoad 時賦值了
  // 另外這邊還是不太懂為什麼一定要加驚嘆號
  
  // MARK: Properties
  let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
  let listCellIdentifier = "ListCellIdentifier"
  
  var movies: [MovieInfo]!
  var selectedMovieIndex: Int!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.createTable()
    
    
    
  }
  
  func createTable() {
    movieListTable = UITableView(frame: .zero, style: .plain)
    movieListTable.dataSource = self
    movieListTable.delegate = self
    movieListTable.backgroundColor = .white
    movieListTable.register(UITableViewCell.self, forCellReuseIdentifier: listCellIdentifier)
    movieListTable.allowsSelection = true
    self.view.addSubview(movieListTable)
    
    movieListTable.snp.makeConstraints { (make) in
      make.top.equalTo(self.view).offset(statusBarHeight)
      make.left.right.bottom.equalTo(self.view)
    }
  }
  
  // MARK: UITableViewDataSource / Delegate
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 20
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: listCellIdentifier, for: indexPath)
    
    if let myLabel = cell.textLabel {
      myLabel.text = "\([indexPath.row])"
    }
    
    cell.selectionStyle = .none
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100.0
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    selectedMovieIndex = indexPath.row
    print("\([indexPath.row]) is selected")
    let detailVc = DetailViewController()
    self.navigationController?.pushViewController(detailVc, animated: true)
    
  }
}
