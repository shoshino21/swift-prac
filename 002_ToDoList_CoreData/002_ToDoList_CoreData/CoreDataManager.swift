//
//  CoreDataManager.swift
//  002_ToDoList_CoreData
//
//  Created by 雲端開發部-江世豪 on 2019/2/23.
//  Copyright © 2019 com.mitake. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager: NSObject {
  var moc: NSManagedObjectContext! = nil
  typealias MyType = Record
  
  init(moc: NSManagedObjectContext) {
    self.moc = moc
  }
  
  func insert(_ entityName: String, info: [String:String]) -> Bool {
    let insertData = NSEntityDescription.insertNewObject(forEntityName: entityName, into: self.moc) as! MyType
    
    for (key, value) in info {
      let t = insertData.entity.attributesByName[key]?.attributeType
      
      if t == .integer16AttributeType || t == .integer32AttributeType || t == .integer64AttributeType {
        insertData.setValue(Int(value), forKey: key)
      }
      else if t == .doubleAttributeType || t == .floatAttributeType {
        insertData.setValue(Double(value), forKey: key)
      }
      else if t == .booleanAttributeType {
        insertData.setValue((value == "true" ? true : false), forKey: key)
      }
      else {
        insertData.setValue(value, forKey: key)
      }
    }
    
    do {
      try moc.save()
      return true
    }
    catch {
      fatalError("Error : \(error)")
    }
    
    return false
  }
  
  typealias NSSortDescSubscript = [String:Bool]
  func fetch(_ entityName: String, predicate: String?, sort: [NSSortDescSubscript]?, limit: Int?) -> [MyType]? {
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
    
    if let myPredicate = predicate {
      request.predicate = NSPredicate(format: myPredicate)
    }
    
    if let mySort = sort {
      var sorts: [NSSortDescriptor] = []
      for sortCondition in mySort {
        for (k, v) in sortCondition {
          sorts.append(NSSortDescriptor(key: k, ascending: v))
        }
      }
      
      request.sortDescriptors = sorts
    }
    
    if let myLimit = limit {
      request.fetchLimit = myLimit
    }
    
    do {
      return try moc.fetch(request) as? [MyType]
    }
    catch {
      fatalError("Error : \(error)")
    }
    
    return nil
  }
  
  func update(_ entityName: String, predicate: String?, info: [String:String]) -> Bool {
    if let results = self.fetch(entityName, predicate: predicate, sort: nil, limit: nil) {
      for result in results {
        for (k, v) in info {
          let t = result.entity.attributesByName[k]?.attributeType
          
          if t == .integer16AttributeType || t == .integer32AttributeType || t == .integer64AttributeType {
            result.setValue(Int(v), forKey: k)
          }
          else if t == .doubleAttributeType || t == .floatAttributeType {
            result.setValue(Double(v), forKey: k)
          }
          else if t == .booleanAttributeType {
            result.setValue((v == "true" ? true : false), forKey: k)
          }
          else {
            result.setValue(v, forKey: k)
          }
        }
      }
      
      do {
        try moc.save()
        return true
      }
      catch {
        fatalError("Error: \(error)")
      }
    }
    
    return false
  }
  
  func delete(_ entityName: String, predicate: String?) -> Bool {
    if let results = self.fetch(entityName, predicate: predicate, sort: nil, limit: nil) {
      for result in results {
        moc.delete(result)
      }
      
      do {
        try moc.save()
        return true
      }
      catch {
        fatalError("Error : \(error)")
      }
    }
    
    return false
  }
}
