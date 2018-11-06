//
//  CategoryViewController.swift
//  ToDoList
//
//  Created by LillyC on 10/22/18.
//  Copyright © 2018 LillyC. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    var realm = try! Realm()
    var categoryArray: Results<Category>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
     //MARK - Tableview Datasoure method
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryItem", for: indexPath)
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Cateogory Added Yet"
        return cell
    }
    //MARK - Tableview Data Manipulation method
    func save(category: Category){
        do{
            try realm.write{
                realm.add(category)
            }
        }
        catch{
            print("Error Saving Category \(error)")
        }
        tableView.reloadData()
    }
   func loadCategories(){
        categoryArray = realm.objects(Category.self)
        tableView.reloadData()
   }
    //MARK - Add new category
    @IBAction func addButtonPress(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            let newCat = Category()
            newCat.name = textField.text!
            
            self.save(category: newCat)
        }
        alert.addAction(action)
        alert.addTextField { (alertText) in
            alertText.placeholder = "Enter New Category"
            textField = alertText
            
        }
        present(alert, animated: true, completion: nil)
        
    }
   //MARK - Tableview  delegate method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }
    
   
   
    
    
    
}
