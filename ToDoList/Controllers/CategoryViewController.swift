//
//  CategoryViewController.swift
//  ToDoList
//
//  Created by LillyC on 10/22/18.
//  Copyright © 2018 LillyC. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework


class CategoryViewController: SwipeCellViewController{
    var realm = try! Realm()
    var categoryArray: Results<Category>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
    }
     //MARK - Tableview Datasoure method
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let color = categoryArray?[indexPath.row].color {
            if let uiColor = UIColor(hexString: color){
                cell.backgroundColor = uiColor
                cell.textLabel?.textColor = ContrastColorOf(uiColor, returnFlat: true)
                cell.textLabel?.text = categoryArray![indexPath.row].name
            }
        }
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
    override func updateModel(at indexPath: IndexPath) {
        if let CategoryForDeletion = self.categoryArray?[indexPath.row]{
            do{
                try self.realm.write {
                    self.realm.delete(CategoryForDeletion)
                }
            }
            catch{
                print ("Error Deleting Category \(error)")
            }
            
        }
    }
    //MARK - Add new category
    @IBAction func addButtonPress(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            let newCat = Category()
            newCat.name = textField.text!
            newCat.color = UIColor.randomFlat.hexValue()
            
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

