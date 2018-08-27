//
//  PlayerViewController.swift
//  Cold Collection
//
//  Created by Carter Brown on 6/26/18.
//  Copyright © 2018 Carter Brown. All rights reserved.
//

import UIKit
import AVFoundation

class PlayerViewController: UIViewController {
    
    @IBOutlet weak var songLabel: UILabel!
    @IBOutlet weak var songImage: UIImageView!
    @IBOutlet weak var playPauseButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Initiate AVAudioSession Category
        initAVAudioSession()
        // Get the album art for the currently playing song
        getSongImage(songIdentifier: songs[songId])
    }
    
    func initAVAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: .mixWithOthers)
            print("Playback OK")
            try AVAudioSession.sharedInstance().setActive(true)
            print("Session is Active")
        } catch {
            print(error)
        }
    }
    
    // Update 'play/pause' button text
    override func viewDidAppear(_ animated: Bool) {
        if isPlaying {
            playPauseButton.setTitle(" PAUSE ", for: UIControlState.normal)
        } else {
            playPauseButton.setTitle(" PLAY ", for: UIControlState.normal)
        }
        songLabel.text = songs[songId]
    }
    
    // Handle audio, button text when 'play/pause' button is touched
    @IBAction func pausePlay(_ sender: Any) {
        let button = sender as! UIButton
        if isPlaying {
            audioPlayer.pause()
            button.setTitle(" PLAY ", for: UIControlState.normal)
            isPlaying = false
        } else {
            if songId == 0 {
                playThis(thisSong: songs[songId])
            } else {
                audioPlayer.play()
            }
            isPlaying = true
            button.setTitle(" PAUSE ", for: UIControlState.normal)
        }
    }
    
    // Hnadle audio when 'prev' button is touched
    @IBAction func prev(_ sender: Any) {
        if songId >= 1 {
            songId -= 1
        } else {
            songId = songs.count-1
        }
        playThis(thisSong: songs[songId])
    }
    
    // Handle audio when 'next' button is touched
    @IBAction func next(_ sender: Any) {
        if songId < songs.count-1 {
            songId += 1
        } else {
            songId = 0
        }
        playThis(thisSong: songs[songId])
    }
    
    // Change audio volume to slider volume
    @IBAction func slider(_ sender: UISlider) {
        audioPlayer.volume = sender.value
    }
    
    // Play song function
    func playThis(thisSong: String) {
        do {
            let audioPath = Bundle.main.path(forResource: thisSong, ofType: "mp3", inDirectory: "Songs")!
            try audioPlayer = AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioPath))
            audioPlayer.play()
        } catch {
            print("Error")
        }
        
        songLabel.text = songs[songId]
        isPlaying = true
        playPauseButton.setTitle(" PAUSE ", for: UIControlState.normal)
        getSongImage(songIdentifier: songs[songId])
    }
    
    // Get the album art to display
    func getSongImage(songIdentifier: String) {
        songImage.image = UIImage.init(named: PATH_MAP.paths[songs[songId]]!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

