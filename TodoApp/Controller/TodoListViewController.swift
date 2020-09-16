//
//  TodoListViewController.swift
//  TodoApp
//
//  Created by Prosper Evergreen on 02.09.2020.
//  Copyright © 2020 proSPEC. All rights reserved.
//

import UIKit
import RealmSwift
import CoreData


class TodoListViewController: UITableViewController{
    
    //create Real instance
    let realm = try! Realm()
    
    //init array of NSManagedObject
    var itemArr : Results<Item>?
    
    var selectedCategory : Category?{
        didSet{
            itemNavTitleBar.title = selectedCategory?.name
            loadItems()
        }
    }
    
    @IBOutlet weak var itemNavTitleBar: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    // MARK: - Table view data source
    
    //func to create number of cells to be used
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return itemArr?.count ?? 1
    }
    
    //func to create each cell and load data
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.tbItemCellId, for: indexPath)
        if let item = itemArr?[indexPath.row]{
            cell.textLabel?.text = item.title
            cell.accessoryType = item.isDone ? .checkmark : .none
        }else{
            cell.textLabel?.text = "No Item Added"
        }
        
        
        return cell
    }
    
    //func to run when cell is clicked
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        do {
            try self.realm.write{
                // Alternative update item
                if (itemArr?[indexPath.row].isDone)! {
                    tableView.cellForRow(at: indexPath)?.accessoryType = .none
                    itemArr?[indexPath.row].isDone =  false
                }else{
                    tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
                    itemArr?[indexPath.row].isDone =  true
                }
                //alternative update
//                itemArr?[indexPath.row].isDone = !(itemArr?[indexPath.row].isDone)!
            }
        } catch {
            print("Error onWrite Realm: \(error)")
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    // add new item
    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
        
        // create textfield to retreive alert string
        var textField = UITextField()
        
        // create alert VC
        let alert = UIAlertController(title: K.alertVCItemTitle, message: "", preferredStyle: .alert)
        
        // add and set alert textfield
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = K.alertItemPlaceholder
            textField = alertTextField
        }
        
        //create action button and set action function
        let alertAddAction = UIAlertAction(title: K.alertActionItemTitle, style: .default) { (alertAddAction) in
            
            if let itemTitle = textField.text{
                if itemTitle != ""{
                    do {
                        try self.realm.write{
                            let newItem = Item()
                            newItem.title = itemTitle
                            newItem.createdItem = Date()
                            self.selectedCategory?.childItem.append(newItem)
                        }
                    } catch {
                        print("Error onWrite Realm: \(error)")
                    }
                }
            }
            self.tableView.reloadData()
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
    
    //function to save context data to model of core data
    func saveItems(item: Item) {
        do {
            try realm.write{
                realm.add(item)
            }
        } catch {
            print("error saving context: \(error)")
        }
        
        tableView.reloadData()
    }
    
    //func to fetch data to context to be loaded
    func loadItems(predicate: NSPredicate? = nil) {
        
        // let category = realm.objects(Category.self).filter("name == %@", selectedCategory?.name)
        itemArr = selectedCategory?.childItem.sorted(byKeyPath: "title", ascending: true)
        if predicate != nil {
            itemArr = itemArr?.filter(predicate!)
        }
        tableView.reloadData()
    }
    
}

//MARK: - Search Bar setup using Delegate protocol

extension TodoListViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        // sets the query rules for the fetcher
        let searchPredicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text ?? "*")

        // loads the data to the context
        loadItems(predicate: searchPredicate)
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
}
