//
//  SideBarViewController.swift
//  Cold Collection
//
//  Created by Carter Brown on 8/8/18.
//  Copyright © 2018 Carter Brown. All rights reserved.
//

import UIKit

class SideBarViewController: UITableViewController {
    
    @IBOutlet var myTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set style of side bar
        myTableView.backgroundColor = UIColor(red: 35/255, green: 35/255, blue: 35/255, alpha: 1)
        myTableView.separatorStyle = .none
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Height of side bar rows
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }

}
