//
//  CategoryViewController.swift
//  TodoApp
//
//  Created by Prosper Evergreen on 06.09.2020.
//  Copyright © 2020 proSPEC. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class CategoryViewController: UITableViewController {
    
    //to get model context of core data from appDelegate
    let realm = try! Realm()
    
    //init array of NSManagedObject
    var categoryArr :Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Load data on load view
        loadCategory()
        
        tableView.rowHeight = 80.0
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categoryArr?.count ?? 1
    }
    
    //func to create each cell and load data
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.tbCategoryCellId, for: indexPath) as! SwipeTableViewCell
        if let category = categoryArr?[indexPath.row] {
            cell.textLabel?.text = category.name
        } else {
            cell.textLabel?.text = "No Category Added"
        }
        cell.delegate = self
        return cell
    }
    
    //func to run when cell is clicked
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.categoryToItemSegue, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categoryArr?[indexPath.row]
        }
    }
    
    //function to dave context data to model of core data
    func save(category: Category) {
        do {
            try realm.write{
                realm.add(category)
            }
        } catch {
            print("error saving context: \(error)")
        }
        
        tableView.reloadData()
    }
    
    //func to fetch data to context to be loaded
    func loadCategory() {
        categoryArr = realm.objects(Category.self)
        tableView.reloadData()
        
    }
    
    //MARK: - Alert View
    
    // add new Category button
    @IBAction func addCategoryPressed(_ sender: UIBarButtonItem) {
        
        //create textfield to retreive alert string
        var textField = UITextField()
        
        //create alert VC
        let alert = UIAlertController(title: K.alertVCCategoryTitle, message: "", preferredStyle: .alert)
        
        
        //add and set alert textfield
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = K.alertCategoryPlaceholder
            textField = alertTextField
        }
        
        //create action button and set action function
        let alertAddAction = UIAlertAction(title: K.alertActionCategoryTitle, style: .default) { (alertAddAction) in
            
            if let itemTitle = textField.text{
                if itemTitle != ""{
                    let newCategory = Category()
                    newCategory.name = itemTitle
                    newCategory.createdCategory = Date()
                    self.save(category: newCategory)
                }
            }
        }
        
        //add action button to alert
        alert.addAction(alertAddAction)
        
        //set up cancel button
        let alertCancelAction = UIAlertAction(title: K.alertCancelTitle, style: .cancel, handler: nil)
        
        //add cancel button to alert
        alert.addAction(alertCancelAction)
        
        //show alert
        present(alert, animated: true, completion: nil)
    }
}

extension CategoryViewController: SwipeTableViewCellDelegate{
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            if let categoryForDeletion = self.categoryArr?[indexPath.row]{
                do{
                    try self.realm.write{
                        self.realm.delete(categoryForDeletion)
                    }
                }catch{
                    print("Error on delete Category: \(error)")
                }
            }
            
            tableView.reloadData()
        }

        // customize the action appearance
        deleteAction.image = UIImage(systemName: "trash")

        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
//        options.transitionStyle = .border
        return options
    }
    
}
