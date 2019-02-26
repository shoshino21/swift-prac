//
//  Record+CoreDataProperties.swift
//  002_ToDoList_CoreData
//
//  Created by 雲端開發部-江世豪 on 2019/2/23.
//  Copyright © 2019 com.mitake. All rights reserved.
//
//

import Foundation
import CoreData


extension Record {
  
  @nonobjc public class func fetchRequest() -> NSFetchRequest<Record> {
    return NSFetchRequest<Record>(entityName: "Record")
  }
  
  @NSManaged public var id: Int32
  @NSManaged public var seq: Int32
  @NSManaged public var content: String?
  @NSManaged public var done: Bool
  
}
