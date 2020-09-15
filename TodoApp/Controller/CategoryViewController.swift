//
//  CategoryViewController.swift
//  TodoApp
//
//  Created by Prosper Evergreen on 06.09.2020.
//  Copyright © 2020 proSPEC. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    //to get model context of core data from appDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //init array of NSManagedObject
    var categoryArr = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Load data on load view
        loadCategory()
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categoryArr.count
    }
    
    //func to create each cell and load data
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.tbCategoryCellId, for: indexPath)
        let category = categoryArr[indexPath.row]
        cell.textLabel?.text = category.name
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
            destinationVC.selectedCategory = categoryArr[indexPath.row]
            print(categoryArr[indexPath.row])
        }
    }
    
    //function to dave context data to model of core data
    func saveCategory() {
        do {
            try context.save()
        } catch {
            print("error saving context: \(error)")
        }
        
        tableView.reloadData()
    }
    
    //func to fetch data to context to be loaded
    func loadCategory(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categoryArr = try context.fetch(request)
        } catch {
            print("error on fetch data \(error)")
        }
        
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
                    let category = Category(context: self.context)
                    category.name = itemTitle
                    self.categoryArr.append(category)
                    
                    self.saveCategory()
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
    
    
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
