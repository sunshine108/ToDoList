//
//  CategoryViewController.swift
//  ToDoList
//
//  Created by LillyC on 10/22/18.
//  Copyright © 2018 LillyC. All rights reserved.
//

import UIKit
import CoreData
class CategoryViewController: UITableViewController {
    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
     //MARK - Tableview Datasoure method
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryItem", for: indexPath)
        cell.textLabel?.text = categoryArray[indexPath.row].name
        return cell
    }
    //MARK - Tableview Data Manipulation method
    func saveCategories(){
        do{
            try context.save()
        }
        catch{
            print("Error Saving Category \(error)")
        }
        tableView.reloadData()
    }
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()){
        do{
            categoryArray = try context.fetch(request)
        }
        catch{
            print("Error loading categories \(error)")
        }
        
    }
    //MARK - Add new category
    @IBAction func addButtonPress(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            let newCat = Category(context: self.context)
            newCat.name = textField.text!
            self.categoryArray.append(newCat)
            self.saveCategories()
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
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
   
   
    
    
    
}
