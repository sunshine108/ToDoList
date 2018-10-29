//
//  ViewController.swift
//  ToDoList
//
//  Created by LillyC on 9/30/18.
//  Copyright © 2018 LillyC. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController{
    var itemArray = [Item]()
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
      super.viewDidLoad()
        //loadItems()
        let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(dataFilePath)
        
        
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].title
        if itemArray[indexPath.row].done == true {
            cell.accessoryType = .checkmark
        }
        else{
            cell.accessoryType = .none
        }
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       context.delete(itemArray[indexPath.row])
       itemArray.remove(at: indexPath.row)
     //   itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItems()
       
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var alertTextField = UITextField()
        let alert = UIAlertController(title: "Add New List", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            let alertItem = Item(context: self.context)
            alertItem.title = alertTextField.text!
            alertItem.done = false
            alertItem.parentCategory = self.selectedCategory
            self.itemArray.append(alertItem)
            self.saveItems()
        }
        alert.addAction(action)
        alert.addTextField { (alertText) in
            alertText.placeholder = "Enter New Item"
            alertTextField = alertText
        }
        present(alert, animated: true, completion: nil)
    }
    func saveItems(){
        
        do {
            try context.save()
        }
        catch{
          print("Error saving context \(error)")
        }
        tableView.reloadData()
    }
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()){
        do {
            itemArray = try context.fetch(request)
        }
        catch {
            print ("Error fetching request \(error)")
        }
         tableView.reloadData()
    }

}
extension TodoListViewController:UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItems(with: request)
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

