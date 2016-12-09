//
//  ListTableViewController.swift
//  ToDoList
//
//  Created by Sergey Guznin on 09.12.16.
//  Copyright © 2016 Sergey Guznin. All rights reserved.
//

import UIKit

class ListTableViewController: UITableViewController {
  // MARK: Properties
  
  var toDoList = [ToDo]()
  
  enum SortingAttribute: String {
    case date = "Date"
    case abc = "ABC"
  }
  
  enum CheckImage: String {
    case check = "checkmark"
    case uncheck = "uncheck"
  }
  
  // MARK: - Action
  @IBAction func showMenu(_ sender: UIBarButtonItem) {
    let alertName = "Sort ToDo list by"
    let message = ""
    let alert = UIAlertController(title: alertName, message: message, preferredStyle: .actionSheet)
    let sortByDateAction = UIAlertAction(title: SortingAttribute.date.rawValue, style: .default) {
      action -> () in
      self.sortToDoList(attribute: SortingAttribute.date)
    }
    let sortByABCAction = UIAlertAction(title: SortingAttribute.abc.rawValue, style: .default) {
      action -> () in
      self.sortToDoList(attribute: SortingAttribute.abc)
    }
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {
      action -> () in
      print("Cancel")
    }
    alert.addAction(sortByDateAction)
    alert.addAction(sortByABCAction)
    alert.addAction(cancelAction)
    present(alert, animated: true, completion: nil)
  }
  
  func sortToDoList(attribute: SortingAttribute){
    switch attribute {
    case .date:
      self.toDoList  = self.toDoList.sorted(by: { $0.date < $1.date })
    case .abc:
      self.toDoList  = self.toDoList.sorted(by: { $0.name < $1.name })
    default:
      print("Invalid attribute")
      return
    }
    self.tableView.reloadData()
  }
    override func viewDidLoad() {
        super.viewDidLoad()
        if let savedToDoList = loadToDoList() {
          toDoList = savedToDoList
        }
        tableView.tableFooterView = UIView()
    }

     // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return toDoList.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cellIdentifier = "ToDoTableViewCell"
    let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ToDoTableViewCell
    
    // Fetches the appropriate todo for the data source layout.
    let toDo = toDoList[indexPath.row]
    cell?.name.text = toDo.name
    let imageName = toDo.isDone ? CheckImage.check.rawValue : CheckImage.uncheck.rawValue
    cell?.checkImgae.image = UIImage(named: imageName)
    // Add tap recognizer to Image
    let singleTap = UITapGestureRecognizer(target: self, action: #selector(ListTableViewController.tappedCheck))
    singleTap.numberOfTapsRequired = 1
    cell?.checkImgae.isUserInteractionEnabled = true
    cell?.checkImgae.addGestureRecognizer(singleTap)
    cell?.checkImgae.tag = indexPath.row
    return cell!
  }
  
  func tappedCheck(gesture: UIGestureRecognizer){
    if let tag = gesture.view?.tag {
    let selectedIndexPath = NSIndexPath(row: tag, section: 0)
      toDoList[selectedIndexPath.row].changeItemStatus()
      saveToDoList()
      tableView.reloadRows(at: [selectedIndexPath as IndexPath], with: .none)
    }
  }

  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      // Delete the row from the data source
      toDoList.remove(at: indexPath.row)
      saveToDoList()
      tableView.deleteRows(at: [indexPath], with: .fade)
      tableView.reloadData()
    } else if editingStyle == .insert {
      // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
  }
  
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  // MARK: - Navigation
  @IBAction func unwindToToDoList(sender: UIStoryboardSegue) {
    if let sourceViewController = sender.source as? DetailViewController, let toDo = sourceViewController.toDo {
      
      if let selectedIndexPath = tableView.indexPathForSelectedRow {
        // Update an existing todo.
        toDoList[selectedIndexPath.row] = toDo
        tableView.reloadRows(at: [selectedIndexPath], with: .none)
      }
      else {
        // Add a new todo.
        let newIndexPath = NSIndexPath(row: toDoList.count, section: 0)
        toDoList.append(toDo)
        tableView.insertRows(at: [newIndexPath as IndexPath], with: .bottom)
      }
      saveToDoList()
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "editItem" {
      let toDoDetailViewController = segue.destination as! DetailViewController
      
      // Get the cell that generated this segue.
      if let selectedToDoCell = sender as? UITableViewCell {
        let indexPath = tableView.indexPath(for: selectedToDoCell)!
        let selectedToDo = toDoList[indexPath.row]
        toDoDetailViewController.toDo = selectedToDo
      }
    }
    else if segue.identifier == "addItem" {
    }
  }
  
  // MARK: NSCoding
  func saveToDoList() {
    let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(toDoList, toFile: ToDo.archiveURL.path)
    if !isSuccessfulSave {
      print("Failed to save ToDo list...")
    }
  }
  
  func loadToDoList() -> [ToDo]? {
    return NSKeyedUnarchiver.unarchiveObject(withFile: ToDo.archiveURL.path) as? [ToDo]
  }

}
