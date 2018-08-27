//
//  BioViewController.swift
//  Cold Collection
//
//  Created by Carter Brown on 7/31/18.
//  Copyright © 2018 Carter Brown. All rights reserved.
//

import UIKit

class BioViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var spotifyLabel: LinkUILabel!
    @IBOutlet weak var amLabel: LinkUILabel!
    @IBOutlet weak var bioLabel: UITextView!
    
    @IBOutlet weak var aviView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customizeNavBar()
        updateArtist()
            }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Update the artist view with info on who was selected
    func updateArtist() {
        nameLabel.text = ARTIST_BIOS.bios[ARTIST_ID].name
        spotifyLabel.url = ARTIST_BIOS.bios[ARTIST_ID].spotifyLink
        spotifyLabel.text = ARTIST_BIOS.bios[ARTIST_ID].spotifyLink
        amLabel.url = ARTIST_BIOS.bios[ARTIST_ID].amLink
        amLabel.text = ARTIST_BIOS.bios[ARTIST_ID].amLink
        bioLabel.text = ARTIST_BIOS.bios[ARTIST_ID].bio
        let imageName = ARTIST_BIOS.bios[ARTIST_ID].aviPath+"big.png"
        aviView.image = UIImage.init(named: imageName)
        
    }
    
    // Set style of nav bar ----------------------------------------------------------------------------
    
    func customizeNavBar() {
        navigationController?.navigationBar.tintColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        navigationController?.navigationBar.barTintColor = UIColor(red: 25/255, green: 25/255, blue: 25/255, alpha: 1)

        navigationController?.navigationBar.titleTextAttributes = [kCTForegroundColorAttributeName: UIColor.white] as [NSAttributedStringKey : Any]
    }
    
    // -------------------------------------------------------------------------------------------------

}
