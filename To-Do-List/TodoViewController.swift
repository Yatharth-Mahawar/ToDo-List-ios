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
    }

    
    let itemsArray = ["1","2","3","4"]
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsArray.count
    }
    

}

