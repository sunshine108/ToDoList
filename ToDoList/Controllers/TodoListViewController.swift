//
//  ViewController.swift
//  ToDoList
//
//  Created by LillyC on 9/30/18.
//  Copyright © 2018 LillyC. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController{
    
    var realm = try! Realm()
    var toDoItems: Results<Item>?
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
   
    
    override func viewDidLoad() {
      super.viewDidLoad()
        loadItems()
        let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(dataFilePath)
        
        
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        if let item = toDoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = (item.done) ? .checkmark : .none
        }
        else{
            cell.textLabel?.text = "No item added"
        }
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = toDoItems?[indexPath.row]{
            do{
                try realm.write {
                   //realm.delete(item)
                    item.done = !item.done
                }
            }
            catch{
                print("Error Update item \(error)")
            }
            tableView.reloadData()
        }
       
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var alertTextField = UITextField()
        let alert = UIAlertController(title: "Add New List", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if let currentCatetory = self.selectedCategory{
                do{
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = alertTextField.text!
                        newItem.dateCreated = Date()
                        currentCatetory.items.append(newItem)
                    }
                }
                catch{
                    print("Error writing to realm \(error)")
                }
                self.tableView.reloadData()
            }
          
        }
       alert.addAction(action)
        alert.addTextField { (alertText) in
            alertText.placeholder = "Enter New Item"
            alertTextField = alertText
        }
        present(alert, animated: true, completion: nil)
    }

    func loadItems(){
         toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
         tableView.reloadData()
   }

}
extension TodoListViewController:UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: false)
         tableView.reloadData()

    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchBar.text?.count==0){
           loadItems()
            DispatchQueue.main.async {
               searchBar.resignFirstResponder()  
            }
           
        }
    }
}

