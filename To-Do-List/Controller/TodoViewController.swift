//
//  ViewController.swift
//  To-Do-List
//
//  Created by Yatharth Mahawar on 06/09/20.
//  Copyright © 2020 Yatharth Mahawar. All rights reserved.
//

import UIKit
import CoreData

class TodoViewController: UITableViewController{
    
    var itemsArray = [Item]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes

        
        
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GoToCell", for: indexPath)
        cell.textLabel?.text = itemsArray[indexPath.row].title
        
        cell.accessoryType = itemsArray[indexPath.row].done ? .checkmark : .none
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        itemsArray[indexPath.row].done = !itemsArray[indexPath.row].done
        self.saveItem()
        
    }
    
    
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        var text_Field = UITextField()
        let message = UIAlertController(title: "Add new item", message:"add new item in the list", preferredStyle: UIAlertController.Style.alert)
        message.addTextField { (textField) in
            textField.placeholder = "Enter your item"
            text_Field = textField
            
        }
        
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            let newItem = Item(context: self.context)
            newItem.title = text_Field.text!
            newItem.done = false
            self.itemsArray.append(newItem)
            self.saveItem()
            
            
            
        }
        let cancel  = UIAlertAction(title: "Cancel", style: .default) { (action) in
            print("cancel")
            
        }
        message.addAction(action)
        message.addAction(cancel)
        present(message, animated: true, completion: nil)
    }
    
    
    func saveItem() {
        
        do {
            try context.save()
        }
        catch {
            print("hello error\(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadData(with request:NSFetchRequest<Item> = Item.fetchRequest()){
        
        
        do {
            
            itemsArray = try context.fetch(request)
        }
            
        catch {
            print(error)
        }
        
        self.tableView.reloadData()
    }
    
}

extension TodoViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request:NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate = NSPredicate(format: "title contains [cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadData(with: request)
       
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
