//
//  CategoryTableViewController.swift
//  To-Do-List
//
//  Created by Yatharth on 9/24/20.
//  Copyright © 2020 Yatharth Mahawar. All rights reserved.
//

import UIKit
import RealmSwift


class CategoryTableViewController: UITableViewController {

    var categories: Results<Category>?
    let realm = try! Realm()
    
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
                
        }
        
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            let newItem = Category()
            newItem.name = text_Field.text!
            self.save(category: newItem)

        }
        let cancel  = UIAlertAction(title: "Cancel", style: .default) { (action) in
            print("cancel")
            
        }
        message.addAction(action)
        message.addAction(cancel)
        present(message, animated: true, completion: nil)
            
        
    }
    
    
    func save(category:Category) {
        
        do {
            try realm.write {
                realm.add(category)
            }
        }
        catch {
            print("Saving data error\(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadData(){
        do {

            categories  = realm.objects(Category.self)
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
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell",for: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Category Added"
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        categories?.count ?? 1
    }



}
