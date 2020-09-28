//
//  ViewController.swift
//  To-Do-List
//
//  Created by Yatharth Mahawar on 06/09/20.
//  Copyright © 2020 Yatharth Mahawar. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework

class TodoViewController: UITableViewController{
    
    let realm = try! Realm()
    var itemsArray: Results<Item>?
    var selectedCategory : Category? {
        didSet{
            loadData()
        }
    }
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        tableView.rowHeight = 80
        
        
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GoToCell", for: indexPath) as! SwipeTableViewCell
            if let items = itemsArray?[indexPath.row] {
            cell.textLabel?.text = items.title
            cell.accessoryType = items.done ? .checkmark : .none
                if let itemArrayCount = itemsArray?.count {
            guard let backGroundColor = selectedCategory?.color else {fatalError()}
                    cell.textLabel?.textColor = ContrastColorOf(UIColor(hexString: backGroundColor)!, returnFlat: true)
            cell.backgroundColor = UIColor(hexString: backGroundColor)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(itemArrayCount))
                    
                }
        }
        else {
            cell.textLabel?.text = "No Items Added"
        }
        cell.delegate = self
        return cell
        
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let item = itemsArray?[indexPath.row] {
            do {
                try self.realm.write{
                    item.done = !item.done
                }
            }
            catch {
                print("error saving \(error)")
            }
            
        }
        self.tableView.reloadData()
    }
    
    
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        var text_Field = UITextField()
        let message = UIAlertController(title: "Add new item", message:"add new item in the list", preferredStyle: UIAlertController.Style.alert)
        message.addTextField { (textField) in
            textField.placeholder = "Enter your item"
            text_Field = textField
            
        }
        
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write{
                        let newItem = Item()
                        newItem.title = text_Field.text!
                        newItem.date = Date()
                        currentCategory.items.append(newItem)
                    }
                    
                }
                
                catch {
                    print("error saving items \(error)")
                }
                
            }
            
            
            self.tableView.reloadData()
            
        }
        let cancel  = UIAlertAction(title: "Cancel", style: .default) { (action) in
            print("cancel")
            
        }
        message.addAction(action)
        message.addAction(cancel)
        present(message, animated: true, completion: nil)
    }
    
    
    func saveItem(item:Item) {
        
        do {
            try realm.write{
                realm.add(item)
            }
        }
        catch {
            print("hello error\(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadData() {
        do {
            itemsArray = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        }
        
        self.tableView.reloadData()
    }
    
}

extension TodoViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        itemsArray = itemsArray?.filter("title CONTAINS[cd] %@",searchBar.text!).sorted(byKeyPath: "date", ascending: true)
        tableView.reloadData()
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadData()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
}

extension TodoViewController: SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            if let itemToDelete = self.itemsArray?[indexPath.row] {
                do {
                    try self.realm.write{
                        self.realm.delete(itemToDelete)
                    }
                }
                catch {
                    print("error deleting item \(error)")
                }
            }
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
    
}

