//
//  ViewController.swift
//  Radio Ava
//
//  Created by Paulo Mendes on 19/06/2018.
//  Copyright © 2018 SwitchCase. All rights reserved.


import UIKit
import AVFoundation
import AVKit
import MediaPlayer

class ViewController: UIViewController {
    
    private var audioPlayer: AVPlayer?
    @IBOutlet weak var nowPlaying: UILabel!
    
    @IBAction func playBtn(_ sender: AnyObject) {
        audioPlayer?.play()
        
    }
    
    @IBAction func stopBtn(_ sender: AnyObject) {
        self.audioPlayer?.pause()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAudioContent()
        print(getSongTitle())
    }
    
    private func setupAudioContent() {
        guard let url = URL(string: "http://185.118.112.12:8029/stream")
            else { return }
        
        audioPlayer = AVPlayer(url: url as URL)
        
    }
    
    func getSongTitle() -> String {
        guard let titleUrl = URL(string: "http://185.118.112.12:8029/currentsong?sid=1")
            else { return "No title available" }
        
        let currentSong = AVPlayer(url: titleUrl)
        let stringUrl = String(describing: currentSong)
        
        return stringUrl
    }
}
