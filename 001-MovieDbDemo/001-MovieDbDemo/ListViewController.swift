//
//  ListViewController.swift
//  001-MovieDbDemo
//
//  Created by 雲端開發部-江世豪 on 2019/2/14.
//  Copyright © 2019 com.mitake. All rights reserved.
//

import UIKit
import SnapKit

class ListViewController: UIViewController {
  
  // MARK: UI
  var movieListTable: UITableView!
  
  // MARK: Properties
  let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
  let listCellIdentifier = "ListCellIdentifier"
  
  var movies: [MovieInfo]!
  var selectedMovieIndex: Int!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.createTable()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    movies = DBManager.shared.loadMovies()
    movieListTable.reloadData()
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
}

extension ListViewController: UITableViewDataSource, UITableViewDelegate {
  // MARK: UITableView
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return (movies != nil) ? movies.count : 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: listCellIdentifier, for: indexPath)
    
    let currentMovie = movies[indexPath.row]
    
    cell.textLabel?.text = currentMovie.title
    cell.imageView?.contentMode = .scaleAspectFit
    
    let session = URLSession(configuration: .default)
    let url = URL(string: currentMovie.coverURL)!
    
    let task = session.dataTask(with: url) { (imageData, response, error) in
      if let data = imageData {
        DispatchQueue.main.async {
          cell.imageView?.image = UIImage(data: data)
          cell.layoutSubviews()
        }
      }
    }
    task.resume()
    
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
