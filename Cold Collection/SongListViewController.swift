//
//  SongListViewController.swift
//  Cold Collection
//
//  Created by Carter Brown on 6/26/18.
//  Copyright © 2018 Carter Brown. All rights reserved.
//

import UIKit
import AVFoundation

// Globals to handle data between SongListVC and PlayerVC
var songs:[String] = []
var audioPlayer = AVAudioPlayer()
var player = AVPlayer()
var songId = 0
var isPlaying = false

class SongListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var myTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Style table view
        myTableView.backgroundColor = UIColor.black
        
        getSongNames()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    // Height of each cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    // Configure each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        
        cell.textLabel?.text = songs[indexPath.row]
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.font = UIFont(name: "Arial-BoldItalicMT", size: 17)
        cell.backgroundColor = UIColor.black
        
        return cell
    }
    
    // Play song that was selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        do {
            let audioPath = Bundle.main.path(forResource: songs[indexPath.row], ofType: "mp3", inDirectory: "Songs")!
            try audioPlayer = AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioPath))
            audioPlayer.play()
            isPlaying = true
            songId = indexPath.row
            performSegue(withIdentifier: "songsToPlayer", sender: nil)
        } catch {
            print("Error")
        }
    }

    // Get list of songs
    func getSongNames() {
        songs.removeAll()
        let folderURL = URL(fileURLWithPath: Bundle.main.resourcePath!)
        do {
            let songPath = try FileManager.default.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            for folder in songPath {
                if folder.absoluteString.contains("Songs") {
                    for song in try FileManager.default.contentsOfDirectory(at: folder, includingPropertiesForKeys: nil, options: .skipsHiddenFiles) {
                        if song.absoluteString.contains(".mp3") {
                            var songString = song.absoluteString
                            let findName = songString.components(separatedBy: "/")
                            songString = findName[findName.count-1]
                            songString = songString.replacingOccurrences(of: ".mp3", with: "")
                            songs.append(songString)
                        }
                    }
                }
            }
            myTableView.reloadData()
        } catch {
            print("Error")
        }
    }
}

