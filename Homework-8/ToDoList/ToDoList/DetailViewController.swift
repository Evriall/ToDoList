//
//  DetailViewController.swift
//  ToDoList
//
//  Created by Sergey Guznin on 09.12.16.
//  Copyright © 2016 Sergey Guznin. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITextFieldDelegate {
// MARK: - Properties
  var toDo: ToDo?
// MARK: - Outlet
  @IBOutlet weak var saveButton: UIBarButtonItem!
  
  @IBOutlet weak var textFieldName: UITextField!
  
  @IBOutlet weak var textViewDescription: UITextView!
  
  @IBOutlet weak var labelDate: UILabel!
  
  // MARK: - Action
  @IBAction func cancel(_ sender: UIBarButtonItem) {
    let isPresentingInAddItem = presentingViewController is UINavigationController
    if isPresentingInAddItem {
      dismiss(animated: true, completion: nil)
    }
    else {
      navigationController!.popViewController(animated: true)
    }
  }
  
  @IBAction func save(_ sender: UIBarButtonItem) {
  }
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldName.delegate = self
        // Set up views if editing an existing Meal.
        if let toDo = toDo {
          navigationItem.title = toDo.name
          textFieldName.text   = toDo.name
          textViewDescription.text = toDo.desc
          let dayTimePeriodFormatter = DateFormatter()
          dayTimePeriodFormatter.dateFormat = "dd-MMMM-yyyy"
          labelDate.text = dayTimePeriodFormatter.string(from: toDo.date)
          self.view.backgroundColor = toDo.isDone ? UIColor.lightGray : UIColor.white
        }
        checkValidToDoName()
    }
  // MARK: UITextFieldDelegate
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    // Hide the keyboard.
    textFieldName.resignFirstResponder()
    return true
  }
  func textFieldDidEndEditing(_ textField: UITextField) {
    checkValidToDoName()
    navigationItem.title = textField.text
  }
  func textFieldDidBeginEditing(_ textField: UITextField) {
    // Disable the Save button while editing.
    saveButton.isEnabled = false
  }
  func checkValidToDoName() {
    // Disable the Save button if the text field is empty.
    let text = textFieldName.text ?? ""
    saveButton.isEnabled = !text.isEmpty
  }
  
  // MARK: Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if saveButton === sender as? UIBarButtonItem{
      let name = textFieldName.text ?? ""
      let desc = textViewDescription.text ?? ""
      let date = toDo?.date ?? Date()
      let isDone = toDo?.isDone ?? false
      
      // Set the meal to be passed to ListTableViewController after the unwind segue.
      toDo = ToDo(name: name, desc: desc, date: date, isDone: isDone)
    }
  }

}
