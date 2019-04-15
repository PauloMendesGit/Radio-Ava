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
        setupMediaPlayerNotificationView()
        print(getSongTitle())
        // This might only work  10+
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error)
        }
        
        // MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
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
    
    func setupMediaPlayerNotificationView(){
        let comandCenter = MPRemoteCommandCenter.shared()
        
        comandCenter.previousTrackCommand.isEnabled = false
        comandCenter.nextTrackCommand.isEnabled = false
        
        // Add handler for Play Command
        comandCenter.playCommand.addTarget { [unowned self] event in
            self.audioPlayer?.play()
            return .success
        }
        
        // Add handler for Pause Command
        comandCenter.pauseCommand.addTarget { [unowned self] event in
            self.audioPlayer?.pause()
            return .success
        }
    }
    
/*    func setupNotificationView() {
        
        nowPlayingInfo = [String : Any]()
        
        nowPlayingInfo[MPMediaItemPropertyTitle] = "Song Name"
        nowPlayingInfo[MPMediaItemPropertyAlbumTitle] = "Album Name"
        nowPlayingInfo[MPMediaItemPropertyArtist] = "Artist Name"
        
        self.nowPlayingInfo?[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: img.size, requestHandler: { (size) -> UIImage in
            return img
        })
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
*/
    
}
