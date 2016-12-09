//
//  ToDo.swift
//  ToDoList
//
//  Created by Sergey Guznin on 09.12.16.
//  Copyright © 2016 Sergey Guznin. All rights reserved.
//

import Foundation
class ToDo: NSObject, NSCoding {
  // MARK: Types
  
  struct PropertyKey {
    static let nameKey = "name"
    static let descriptionKey = "description"
    static let dateKey = "date"
    static let isDoneKey = "isDone"
  }
  // MARK: Properties
  
  private(set) var name: String
  private(set) var desc: String?
  private(set) var date: Date
  private(set) var isDone: Bool
  
  // MARK: Archiving Paths
  
  static let documentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
  static let archiveURL = documentsDirectory.appendingPathComponent("todo")
  
  // MARK: Initialization
  
  init?(name: String, desc: String?, date: Date, isDone: Bool = false) {
    // Initialize stored properties.
    self.name = name
    self.desc = desc
    self.date = date
    self.isDone = isDone
    super.init()
    // Initialization should fail if there is no name.
    if name.isEmpty {
      return nil
    }
  }
  
  // MARK: NSCoding
  func encode(with aCoder: NSCoder) {
    aCoder.encode(name, forKey: PropertyKey.nameKey)
    aCoder.encode(desc, forKey: PropertyKey.descriptionKey)
    aCoder.encode(date, forKey: PropertyKey.dateKey)
    aCoder.encode(isDone, forKey: PropertyKey.isDoneKey)
  }
  
  required convenience init?(coder aDecoder: NSCoder) {
    guard let name = aDecoder.decodeObject(forKey: PropertyKey.nameKey) as? String else {return nil}
    guard let desc = aDecoder.decodeObject(forKey: PropertyKey.descriptionKey) as? String? else {return nil}
    guard let date = aDecoder.decodeObject(forKey: PropertyKey.dateKey) as? Date else {return nil }
    let isDone = aDecoder.decodeBool(forKey: PropertyKey.isDoneKey)
    // Must call designated initializer.
    self.init(name: name, desc: desc, date: date, isDone: isDone)
  }
  
  func changeItemStatus(){
    self.isDone = !self.isDone
  }

}
