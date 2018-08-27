//
//  MusicViewController.swift
//  Cold Collection
//
//  Created by Carter Brown on 7/30/18.
//  Copyright © 2018 Carter Brown. All rights reserved.
//

import UIKit

class MusicViewController: UITabBarController {

    @IBOutlet weak var myTabBar: UITabBar!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Configure tab bar
        myTabBar.tintColor = UIColor.white
        myTabBar.barTintColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 1)
        
        sideMenus()
        customizeNavBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // If a song is playing, show player first
    override func viewWillAppear(_ animated: Bool) {
        if isPlaying {
            selectedIndex = 1
        }
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
