//
//  ArtistListViewController.swift
//  Cold Collection
//
//  Created by Carter Brown on 7/30/18.
//  Copyright © 2018 Carter Brown. All rights reserved.
//

import UIKit

class ArtistListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var bioList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Remove table separators
        bioList.separatorStyle = .none
        
        // Set up side bar menu
        sideMenus()
        customizeNavBar()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Get number of artists
        return ARTIST_BIOS.bios.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bioCell", for: indexPath)
        
        // Set label to artist name
        cell.textLabel?.text = ARTIST_BIOS.bios[indexPath.row].name
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.font = UIFont(name: "Arial-BoldItalicMT", size: 17)
        
        // Set artist icon
        let iconName = ARTIST_BIOS.bios[indexPath.row].aviPath+"small.png"
        cell.imageView?.image = UIImage.init(named: iconName)
        
        return cell
    }
    
    // Set height of each cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    // When an artist is selected load their bio
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ARTIST_ID = indexPath.row
        performSegue(withIdentifier: "ListToArtist", sender: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
     sideMenus() and customizeNavBar() set up the side menu --------------------------------------------
     */
    func sideMenus() {
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = 70
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    func customizeNavBar() {
        navigationController?.navigationBar.tintColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        navigationController?.navigationBar.barTintColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 1)

        navigationController?.navigationBar.titleTextAttributes = [kCTForegroundColorAttributeName: UIColor.white] as [NSAttributedStringKey : Any]
    }
    
    // -------------------------------------------------------------------------------------------------

}
