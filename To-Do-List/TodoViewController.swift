//
//  ViewController.swift
//  To-Do-List
//
//  Created by Yatharth Mahawar on 06/09/20.
//  Copyright © 2020 Yatharth Mahawar. All rights reserved.
//

import UIKit

class TodoViewController: UITableViewController{

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }

    
    var itemsArray = ["1","2","3","4"]
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GoToCell", for: indexPath)
        cell.textLabel?.text = itemsArray[indexPath.row]

        
        return cell
       
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if self.tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            self.tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else {
            self.tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
    }
    
  
    @IBAction func addItem(_ sender: UIBarButtonItem) {
            var item = ""
            let message = UIAlertController(title: "Add new item", message:"add new item in the list", preferredStyle: UIAlertController.Style.alert)
            message.addTextField { (textField) in
                textField.placeholder = "Enter your item"
               
            }
        
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
                                print("hello")
                               
                                }
        let cancel  = UIAlertAction(title: "Cancel", style: .default) { (action) in
                                 print("cancel")
                                 
                             }
        message.addAction(action)
        message.addAction(cancel)
        present(message, animated: true, completion: nil)
}
           
            
       
            
       
        
        }
    

    


