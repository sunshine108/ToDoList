//
//  ViewController.swift
//  ToDoList
//
//  Created by LillyC on 9/30/18.
//  Copyright © 2018 LillyC. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    var itemArray = ["Go Shopping", "Do Grocery", "Pickup kids"]
    let useDefault = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        if let items = useDefault.array(forKey: "ToDoItemArray") as? [String]{
            itemArray = items
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if
            (tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark) {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var alertTextField = UITextField()
        let alert = UIAlertController(title: "Add New List", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            self.itemArray.append(alertTextField.text!)
            self.useDefault.set(self.itemArray, forKey: "ToDoItemArray")
            self.tableView.reloadData()
        }
        alert.addAction(action)
        alert.addTextField { (alertText) in
            alertText.placeholder = "Enter New Item"
            alertTextField = alertText
        }
        present(alert, animated: true, completion: nil)
    }
    
    


}

