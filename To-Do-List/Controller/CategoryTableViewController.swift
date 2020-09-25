//
//  CategoryTableViewController.swift
//  To-Do-List
//
//  Created by Yatharth on 9/24/20.
//  Copyright © 2020 Yatharth Mahawar. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {

    var categories = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        loadData()


    }
    
    @IBAction func addCategory(_ sender: UIBarButtonItem) {
        var text_Field = UITextField()
        let message = UIAlertController(title: "Add Category", message: "Add New Category in the List", preferredStyle: UIAlertController.Style.alert)
            message.addTextField { (textField) in
            textField.placeholder = "Hello"
                text_Field = textField
                self.saveItem()
        }
        
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            let newItem = Category(context: self.context)
            newItem.name = text_Field.text!
            self.categories.append(newItem)
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
            print("Saving data error\(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadData(with request:NSFetchRequest<Category> = Category.fetchRequest()){
        
        
        
        do {
            
            categories = try context.fetch(request)
        }
            
        catch {
            print(error)
        }
        
        self.tableView.reloadData()
    }
    

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "GoToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoViewController
        if let indexPath = tableView.indexPathForSelectedRow {
        destinationVC.selectedCategory = categories[indexPath.row]
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell",for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        categories.count
    }



}
