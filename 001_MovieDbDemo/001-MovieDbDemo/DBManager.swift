//
//  DBManager.swift
//  001-MovieDbDemo
//
//  Created by 雲端開發部-江世豪 on 2019/2/19.
//  Copyright © 2019 com.mitake. All rights reserved.
//

import UIKit
import FMDB

struct MovieInfo {
  var movieID: Int!
  var title: String!
  var category: String!
  var year: Int!
  var movieURL: String!
  var coverURL: String!
  var watched: Bool!
  var likes: Int!
}

let field_MovieID = "movieID"
let field_MovieTitle = "title"
let field_MovieCategory = "category"
let field_MovieYear = "year"
let field_MovieURL = "movieURL"
let field_MovieCoverURL = "coverURL"
let field_MovieWatched = "watched"
let field_MovieLikes = "likes"

class DBManager: NSObject {
  static let shared = DBManager()
  
  let databaseFileName = "database.sqlite"
  var pathToDatabase: String!
  var database: FMDatabase!
  
  override init() {
    super.init()
    
    let documentsDirectory =
      (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString) as String
    pathToDatabase = documentsDirectory.appending("/\(databaseFileName)")
  }
  
  func createDatabase() -> Bool {
    var created = false
    
    if !FileManager.default.fileExists(atPath: pathToDatabase) {
      database = FMDatabase(path: pathToDatabase)
      
      if database != nil {
        if database.open() {
          let createMoviesTableQuery = "create table movies (\(field_MovieID) integer primary key autoincrement not null, \(field_MovieTitle) text not null, \(field_MovieCategory) text not null, \(field_MovieYear) integer not null, \(field_MovieURL) text, \(field_MovieCoverURL) text not null, \(field_MovieWatched) bool not null default 0, \(field_MovieLikes) integer not null)"
          
          do {
            try database.executeUpdate(createMoviesTableQuery, values: nil)
            created = true
          }
          catch {
            print("Could not create table.")
            print(error.localizedDescription)
          }
          
          database.close()
        }
        else {
          print("Could not open the database.")
        }
      }
    }
    
    return created
  }
  
  func openDatabase() -> Bool {
    if database == nil {
      if FileManager.default.fileExists(atPath: pathToDatabase) {
        database = FMDatabase(path: pathToDatabase)
      }
    }
    
    if database != nil {
      if database.open() {
        return true
      }
    }
    
    return false
  }
  
  func insertMovieData() {
    if !openDatabase() {
      return
    }
    
    if let pathToMoviesFile = Bundle.main.path(forResource: "movies", ofType: "tsv") {
      do {
        let moviesFileContents = try String(contentsOfFile: pathToMoviesFile)
        let moviesData = moviesFileContents.components(separatedBy: "\r\n")
        var query = ""
        
        for movie in moviesData {
          let movieParts = movie.components(separatedBy: "\t")
          
          if movieParts.count == 5 {
            let movieTitle = movieParts[0]
            let movieCategory = movieParts[1]
            let movieYear = movieParts[2]
            let movieURL = movieParts[3]
            let movieCoverURL = movieParts[4]
            
            // query 包含多個敘述句，所以尾巴加上分號
            query += "insert into movies (\(field_MovieID), \(field_MovieTitle), \(field_MovieCategory), \(field_MovieYear), \(field_MovieURL), \(field_MovieCoverURL), \(field_MovieWatched), \(field_MovieLikes)) values (null, '\(movieTitle)', '\(movieCategory)', \(movieYear), '\(movieURL)', '\(movieCoverURL)', 0, 0);"
          }
        }
        
        if !database.executeStatements(query) {
          print("Failed to insert initial data into the database.")
          print(database.lastError(), database.lastErrorMessage())
        }
      }
      catch {
        print(error.localizedDescription)
      }
    }
    
    database.close()
  }
  
  func loadMovies() -> [MovieInfo]! {
    var movies: [MovieInfo]!

    if openDatabase() {
      let query = "select * from movies order by \(field_MovieYear) asc"

      do {
        let results = try database.executeQuery(query, values: nil)

        while results.next() {
          let movie = MovieInfo(movieID: Int(results.int(forColumn: field_MovieID)),
                                title: results.string(forColumn: field_MovieTitle),
                                category: results.string(forColumn: field_MovieCategory),
                                year: Int(results.int(forColumn: field_MovieYear)),
                                movieURL: results.string(forColumn: field_MovieURL),
                                coverURL: results.string(forColumn: field_MovieCoverURL),
                                watched: results.bool(forColumn: field_MovieWatched),
                                likes: Int(results.int(forColumn: field_MovieLikes))
          )

          if movies == nil {
            movies = [MovieInfo]()
          }

          movies.append(movie)
        }
      }
      catch {
        print(error.localizedDescription)
      }

      database.close()
    }

    return movies
  }
  
  typealias LoadMovieCompletionHandler = (_ movieInfo: MovieInfo?) -> Void
  func loadMovie(_ id: Int, _ completionHandler: LoadMovieCompletionHandler) {
    var movieInfo: MovieInfo!
    
    if openDatabase() {
      let query = "select * from movies where \(field_MovieID) = ?"
      
      do {
        let results = try database.executeQuery(query, values: [id])
        
        if results.next() {
          movieInfo = MovieInfo(movieID: Int(results.int(forColumn: field_MovieID)),
                                title: results.string(forColumn: field_MovieTitle),
                                category: results.string(forColumn: field_MovieCategory),
                                year: Int(results.int(forColumn: field_MovieYear)),
                                movieURL: results.string(forColumn: field_MovieURL),
                                coverURL: results.string(forColumn: field_MovieCoverURL),
                                watched: results.bool(forColumn: field_MovieWatched),
                                likes: Int(results.int(forColumn: field_MovieLikes))
          )
        }
        else {
          print(database.lastError())
        }
      }
      catch {
        print(error.localizedDescription)
      }
      
      database.close()
    }
    
    completionHandler(movieInfo)
  }
  
  func updateMovie(_ id: Int, watched: Bool, likes: Int) -> Bool {
    var success = false
    
    if openDatabase() {
      let query = "update movies set \(field_MovieWatched) = ?, \(field_MovieLikes) = ? where \(field_MovieID) = ?"
      
      do {
        try database.executeUpdate(query, values: [watched, likes, id])
        success = true
      }
      catch {
        print(error.localizedDescription)
        success = false
      }
      
      database.close()
    }
    
    return success
  }
  
  func deleteMovie(_ id: Int) -> Bool {
    var success = false
    
    if openDatabase() {
      let query = "delete from movies where \(field_MovieID) = ?"
      
      do {
        try database.executeUpdate(query, values: [id])
        success = true
      }
      catch {
        print(error.localizedDescription)
      }
      
      database.close()
    }
    
    return success
  }
}
