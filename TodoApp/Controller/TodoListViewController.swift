//
//  TodoListViewController.swift
//  TodoApp
//
//  Created by Prosper Evergreen on 02.09.2020.
//  Copyright © 2020 proSPEC. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController{
    
    //to get model context of core data from appDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //init array of NSManagedObject
    var itemArr = [Item]()
    
    var selectedCategory : Category?{
        didSet{
            itemNavTitleBar.title = selectedCategory?.name
            loadItems()
        }
    }
    
    @IBOutlet weak var itemNavTitleBar: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        get location of core data files
        //        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - Table view data source
    //
    //    override func numberOfSections(in tableView: UITableView) -> Int {
    //        // #warning Incomplete implementation, return the number of sections
    //        return itemArray.count
    //    }
    
    //func to create number of cells to be used
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return itemArr.count
    }
    
    //func to create each cell and load data
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.tbItemCellId, for: indexPath)
        let item = itemArr[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.isDone ? .checkmark : .none
        
        return cell
    }
    
    //func to run when cell is clicked
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //        //to update item using core data
        //        itemArr[indexPath.row].setValue(!itemArr[indexPath.row].isDone, forKey: "isDone")
        //
        //        //to delete item using core data
        //        context.delete(itemArr[indexPath.row])
        //        itemArr.remove(at: indexPath.row)
        
        //alternative update item
        if itemArr[indexPath.row].isDone {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            itemArr[indexPath.row].isDone =  false
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            itemArr[indexPath.row].isDone =  true
        }
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    // add new item
    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
        
        //create textfield to retreive alert string
        var textField = UITextField()
        
        //create alert VC
        let alert = UIAlertController(title: K.alertVCItemTitle, message: "", preferredStyle: .alert)
        
        //add and set alert textfield
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = K.alertItemPlaceholder
            textField = alertTextField
        }
        
        //create action button and set action function
        let alertAddAction = UIAlertAction(title: K.alertActionItemTitle, style: .default) { (alertAddAction) in
            
            if let itemTitle = textField.text{
                if itemTitle != ""{
                    let item = Item(context: self.context)
                    item.title = itemTitle
                    item.parentCategory = self.selectedCategory
                    self.itemArr.append(item)
                    
                    self.saveItems()
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
    
    //function to dave context data to model of core data
    func saveItems() {
        do {
            try context.save()
        } catch {
            print("error saving context: \(error)")
        }
        
        tableView.reloadData()
    }
    
    //func to fetch data to context to be loaded
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        }else{
            request.predicate = categoryPredicate
        }
        
        do {
            itemArr = try context.fetch(request)
        } catch {
            print("error on fetch data \(error)")
        }
        
        tableView.reloadData()
        
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

//MARK: - Search Bar setup using Delegate protocol

extension TodoListViewController: UISearchBarDelegate{
    
    //
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // creates fetch pointer of Item type
        let req: NSFetchRequest<Item> = Item.fetchRequest()
        
        // sets the query rules for the fetcher
        let searchPredicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text ?? "*")
        
        // sets the sort order
        req.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        // loads the data to the context
        loadItems(with: req, predicate: searchPredicate)
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
    
    //    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    //        if searchBar.text?.count == 0 {
    //            loadItems()
    //            searchBar.resignFirstResponder()
    //        }
    //    }
}
