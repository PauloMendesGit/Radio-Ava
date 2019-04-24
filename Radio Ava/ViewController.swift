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
    var isPlaying = false

    
    @IBOutlet weak var nowPlaying: UILabel!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var stopBtn: UIButton!
    
    @IBAction func playBtn(_ sender: AnyObject) {
        // If we destroyed the player, make a new setupAudioContent()
        if (audioPlayer == nil) {
            isPlaying = false
            setupAudioContent()
        }
        
        if (isPlaying == false) {
            isPlaying = true
            audioPlayer?.play()
            playBtn.setImage(UIImage(named: "btn-pause"), for: .normal)
        } else {
            isPlaying = false
            audioPlayer?.pause()
            playBtn.setImage(UIImage(named: "btn-play"), for: .normal)
        }
    }
    
    // We have to destroy the player to stop it - There is no stop() method
    @IBAction func stopBtn(_ sender: Any) {
        audioPlayer = nil
        playBtn.setImage(UIImage(named: "btn-play"), for: .normal)
    }
    
    
    @IBAction func facebookBtn(_ sender: Any) {
        // We should change this to open the app instead
        // socialMediaBtnPressed(social: "fb", profile: "user?username=radioava.global", socialUrl: "https://www.facebook.com/radioavaglobal/?ref=br_rs")
        
        if let url = URL(string: "https://www.facebook.com/radioavaglobal/?ref=br_rs") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    @IBAction func instagramBtn(_ sender: Any) {
        socialMediaBtnPressed(social: "Instagram", profile: "user?username=radioava.global", socialUrl: "https://www.instagram.com/radioava.global/?hl=en")
    }

    @IBAction func websiteBtn(_ sender: Any) {
        if let url = URL(string: "http://radioava.global/") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    
    @IBAction func shareBtn(_ sender: Any) {
        self.shareButtonPressed()
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
        
        guard let url2 = URL(string: "http://185.118.112.12:8029/currentsong?sid=1")
            else { return }
        
        audioPlayer = AVPlayer(url: url as URL)
        
        do {
            let myHTMLString = try String(contentsOf: url2, encoding: .ascii)
            print("HTML : \(myHTMLString)")
        } catch let error {
            print("Error: \(error)")
        }
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
            if (self.audioPlayer == nil) {
                self.isPlaying = false
                self.setupAudioContent()
            }
            
            self.isPlaying = true
            self.audioPlayer?.play()
            self.playBtn.setImage(UIImage(named: "btn-pause"), for: .normal)
            return .success
        }
        
        // Add handler for Pause Command
        comandCenter.pauseCommand.addTarget { [unowned self] event in
            self.isPlaying = false
            self.audioPlayer?.pause()
            self.playBtn.setImage(UIImage(named: "btn-play"), for: .normal)
            return .success
        }
    }
    
    
    func shareButtonPressed() {
        
        let firstActivityItem = "Share"
        let secondActivityItem : NSURL = NSURL(string: "https://play.google.com/store/apps/details?id=pt.switchcase.radioava")!
        // If you want to put an image
        //      let image : UIImage = UIImage(named: "image.jpg")!
        
        let activityViewController : UIActivityViewController = UIActivityViewController(
            //            activityItems: [firstActivityItem, secondActivityItem, image], applicationActivities: nil)
            activityItems: [firstActivityItem, secondActivityItem], applicationActivities: nil)
        
        // This lines is for the popover you need to show in iPad
        //        activityViewController.popoverPresentationController?.sourceView = (sender as! UIButton)
        
        // This line remove the arrow of the popover to show in iPad
        //        activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.allZeros
        //        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
        
        // Anything you want to exclude
        activityViewController.excludedActivityTypes = [
            UIActivity.ActivityType.postToWeibo,
            UIActivity.ActivityType.print,
            UIActivity.ActivityType.assignToContact,
            UIActivity.ActivityType.saveToCameraRoll,
            UIActivity.ActivityType.addToReadingList,
            UIActivity.ActivityType.postToFlickr,
            UIActivity.ActivityType.postToVimeo,
            UIActivity.ActivityType.postToTencentWeibo
        ]
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    private func socialMediaBtnPressed(social: String, profile: String, socialUrl: String){
        
        let appName = social
        let appScheme = "\(appName)://"+"\(profile)"
        let appSchemeURL = URL(string: appScheme)
        let canOpenURL = UIApplication.shared.canOpenURL(appSchemeURL!)
        print("profile --- " + profile)
        print(appScheme)
        print(appSchemeURL!)
        print(canOpenURL)
        
        //if let appURL = URL(string: appScheme){
            
            if UIApplication.shared.canOpenURL(appSchemeURL! as URL) {
                UIApplication.shared.open(appSchemeURL!, options: [:], completionHandler: nil)
            }
            else {
               // this will show and error if the user does not have the app installed
               // let alert = UIAlertController(title: "\(appName) Error...", message: "\(appName) is not installed on this device.", preferredStyle: .alert)
               // alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
               // self.present(alert, animated: true, completion: nil)
                
               // if the user does not have the app installed. open on the web
                if let url = URL(string: socialUrl) {
                    UIApplication.shared.open(url, options: [:])
                }
            }
        //}
    }

}
