//
//  ViewController.swift
//  ToDoList
//
//  Created by LillyC on 9/30/18.
//  Copyright © 2018 LillyC. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework

class TodoListViewController: SwipeCellViewController{
    
    @IBOutlet weak var searchBar: UISearchBar!
    var realm = try! Realm()
    var catColor: String = ""
    var toDoItems: Results<Item>?
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    override func viewDidLoad() {
      super.viewDidLoad()
        tableView.rowHeight = 80
        loadItems()
        let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(dataFilePath)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        title = selectedCategory!.name
        guard let barColor = selectedCategory?.color else {fatalError()}
        updateNavBar(withHexCode: barColor)
    }
    override func viewWillDisappear(_ animated: Bool) {
        updateNavBar(withHexCode: "1D9BF6")
    }
    func updateNavBar(withHexCode colorHex: String){
        guard let navBar = navigationController?.navigationBar else { fatalError("Nav Bar does not exists")}
        guard let navBarColor = UIColor(hexString: colorHex) else{ fatalError()}
        navBar.barTintColor = navBarColor
        navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: ContrastColorOf(navBarColor, returnFlat: true)]
       navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
       searchBar.barTintColor = navBarColor
    }
    override func updateModel(at indexPath: IndexPath) {
        if let ItemForDeletion = self.toDoItems?[indexPath.row]{
            do{
                try self.realm.write {
                    self.realm.delete(ItemForDeletion)
                }
            }
            catch{
                print ("Error Deleting Category \(error)")
            }
            
        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = toDoItems?[indexPath.row] {
            //let color = UIColor.flatSkyBlue
            if let color = UIColor(hexString: catColor) {
            cell.backgroundColor = color.darken(byPercentage: (CGFloat)(indexPath.row)/(CGFloat)(toDoItems!.count))
            cell.textLabel?.text = item.title
            cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            
            cell.accessoryType = (item.done) ? .checkmark : .none
            }
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
         catColor = selectedCategory?.color ?? "#FFFFFF"
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

