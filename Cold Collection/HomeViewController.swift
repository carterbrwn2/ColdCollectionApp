//
//  HomeViewController.swift
//  Cold Collection
//
//  Created by Carter Brown on 7/30/18.
//  Copyright © 2018 Carter Brown. All rights reserved.
//

import UIKit

// Global variables to hold JSON data

// Artist Data ---------------------------------
struct Artists: Decodable {
    var bios:[bio]
}

struct bio: Decodable {
    let name: String
    let bio: String
    let spotifyLink: String
    let amLink: String
    let aviPath: String
}

var ARTIST_BIOS:Artists = Artists(bios: [])
var ARTIST_ID = -1

// ---------------------------------------------

// Song Image Data -----------------------------
struct ImagePaths: Decodable {
    var paths: [String: String] = [:]
}

var PATH_MAP:ImagePaths = ImagePaths(paths: [:])

// ---------------------------------------------

// Event Data ----------------------------------
struct EventData: Decodable {
    var events:[String: [event]]
}

struct event: Decodable {
    let artistName: String
    let eventType: String
    let title: String
    let eventTime: String
    let eventLength: Int
}

var EVENT_MAP:EventData = EventData(events: [String:[event]]())

// ---------------------------------------------

class HomeViewController: UIViewController {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load JSON Data
        getArtistData()
        getSongImageData()
        getEventData()
        
        // Init side menu
        sideMenus()
        customizeNavBar()

        // Start snowing
        initSnow()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initSnow() {
        let emitter = Emitter.get(with: #imageLiteral(resourceName: "icons8-snowflake-64"))
        emitter.emitterPosition = CGPoint(x: view.frame.width / 2, y: 0)
        emitter.emitterSize = CGSize(width: view.frame.width, height: 2)
        view.layer.addSublayer(emitter)
    }
    
    // Gets data from artists.json
    func getArtistData() {
        ARTIST_BIOS.bios.removeAll()
        
        /* ********
         To retrieve artists.JSON from Firebase
         **********

        let jsonUrlString = "https://firebasestorage.googleapis.com/v0/b/cold-collection.appspot.com/o/artists.json?alt=media&token=ae82b467-1686-4763-9a83-f5dbdf83217e"
        guard let url = URL(string: jsonUrlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            guard let data = data else { return }
            do {
                let bioArray = try
                    JSONDecoder().decode(Artists.self, from: data)
                for bio in bioArray.bios {
                    ARTIST_BIOS.bios.append(bio)
                }
            } catch let jsonErr {
                print("Error", jsonErr)
            }
        }.resume()
 
        */
        
        /* ********
         To retrieve artists.JSON from Data folder
        ********** */

        let folderURL = URL(fileURLWithPath: Bundle.main.resourcePath!)
        do {
            let jsonPath = try FileManager.default.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            for folder in jsonPath {
                if folder.absoluteString.contains("Data") {
                    for file in try FileManager.default.contentsOfDirectory(at: folder, includingPropertiesForKeys: nil, options: .skipsHiddenFiles) {
                        if file.absoluteString.contains("artists.json") {
                            let data = try Data(contentsOf: file)
                            let bioArray = try
                                JSONDecoder().decode(Artists.self, from: data)
                            for bio in bioArray.bios {
                                ARTIST_BIOS.bios.append(bio)
                            }
                        }
                    }
                }
            }
        } catch {
            print("Error")
        }
 
 
    }
    
    // Gets data from imagePaths.json
    func getSongImageData() {
        PATH_MAP.paths.removeAll()
        
        /* ********
         To retrieve imagePaths.JSON from Firebase
         **********
        let jsonUrlString = "https://firebasestorage.googleapis.com/v0/b/cold-collection.appspot.com/o/imagePaths.json?alt=media&token=c7692711-dc71-4dd5-b553-c50369ae5539"
        guard let url = URL(string: jsonUrlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            guard let data = data else { return }
            do {
                let imgMap = try
                    JSONDecoder().decode(ImagePaths.self, from: data)
                for pair in imgMap.paths {
                    PATH_MAP.paths[pair.key] = pair.value
                }
            } catch let jsonErr {
                print("Error", jsonErr)
            }
        }.resume()
        
        */
        
    /* ********
     To retrieve imagePaths.JSON from Data folder
    ********** */
 
        let folderURL = URL(fileURLWithPath: Bundle.main.resourcePath!)
        do {
            let jsonPath = try FileManager.default.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            for folder in jsonPath {
                if folder.absoluteString.contains("Data") {
                    for file in try FileManager.default.contentsOfDirectory(at: folder, includingPropertiesForKeys: nil, options: .skipsHiddenFiles) {
                        if file.absoluteString.contains("imagePaths.json") {
                            let data = try Data(contentsOf: file)
                            let imgMap = try
                                JSONDecoder().decode(ImagePaths.self, from: data)
                            for pair in imgMap.paths {
                                PATH_MAP.paths[pair.key] = pair.value
                            }
                        }
                    }
                }
            }
        } catch {
            print("Error")
        }
    }
    
    // Gets data from events.json
    func getEventData() {
        EVENT_MAP.events.removeAll()

        /* ********
         To retrieve events.JSON from Firebase
         **********
        let jsonUrlString = "https://firebasestorage.googleapis.com/v0/b/cold-collection.appspot.com/o/events.json?alt=media&token=466a78bf-c029-4a26-a9c4-fadd91cc54f2"
        guard let url = URL(string: jsonUrlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            guard let data = data else { return }
            do {
                let evntMap = try
                    JSONDecoder().decode(EventData.self, from: data)
                for pair in evntMap.events {
                    EVENT_MAP.events[pair.key] = pair.value
                }
            } catch let jsonErr {
                print("Error", jsonErr)
            }
        }.resume()
        
        */
        
        
        /* ********
         To retrieve events.JSON from Data folder
         ********** */
         
        let folderURL = URL(fileURLWithPath: Bundle.main.resourcePath!)
        do {
            let jsonPath = try FileManager.default.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            for folder in jsonPath {
                if folder.absoluteString.contains("Data") {
                    for file in try FileManager.default.contentsOfDirectory(at: folder, includingPropertiesForKeys: nil, options: .skipsHiddenFiles) {
                        if file.absoluteString.contains("events.json") {
                            let data = try Data(contentsOf: file)
                            let evntMap = try
                                JSONDecoder().decode(EventData.self, from: data)
                            for pair in evntMap.events {
                                EVENT_MAP.events[pair.key] = pair.value
                            }
                        }
                    }
                }
            }
        } catch {
            print("Error")
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
