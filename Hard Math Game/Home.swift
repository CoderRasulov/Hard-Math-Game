//
//  ViewController.swift
//  Hard Math Game
//
//  Created by Asliddin Rasulov on 2/25/20.
//  Copyright © 2020 Asliddin Rasulov. All rights reserved.
//

import UIKit
import AVFoundation

var audioPlayer: AVAudioPlayer!

func playSoundWith(fileName: String, fileExtinsion: String) -> Void {
    
    let audioSourceURL = Bundle.main.url(forResource: fileName, withExtension: fileExtinsion)
    
    do {
        audioPlayer = try AVAudioPlayer(contentsOf: audioSourceURL!)
    } catch {
        print(error)
    }
    audioPlayer.prepareToPlay()
    audioPlayer.play()
}

class Home: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet var countStars: [UILabel]!
    @IBOutlet var stars: [UILabel]!
    
    @IBOutlet var buttonsFont: [UIButton]!
    
    var titles: [String] = ["Let`s start", "1, 2, 3, 4", "Get 24", "Minus", "Lucky 7", "Devide to 1"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.font = titleLabel.font.withSize(view.frame.height / 20)
        for i in buttonsFont.indices {
            buttonsFont[i].titleLabel?.font = buttonsFont[i].titleLabel?.font.withSize(view.frame.height / 44)
        }
        for i in countStars.indices {
            countStars[i].font = countStars[i].font.withSize(view.frame.height / 40)
            stars[i].font = stars[i].font.withSize(view.frame.height / 40)
            
            if UserDefaults.standard.integer(forKey: "stars\(titles[i])") != 0 {
                stars[i].textColor = .systemRed
                countStars[i].text = UserDefaults.standard.string(forKey: "stars\(titles[i])")
            }
        }
        
    }
    
    @IBAction func goLevels(_ sender: UIButton) {
        if UserDefaults.standard.bool(forKey: "voice") {
            playSoundWith(fileName: "Back", fileExtinsion: "wav")
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Levels") as! Levels
        vc.title = sender.currentTitle!
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func goSettings(_ sender: UIButton) {
        if UserDefaults.standard.bool(forKey: "voice") {
            playSoundWith(fileName: "Back", fileExtinsion: "wav")
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Settings") as! Settings
        present(vc, animated: true, completion: nil)
    }
    @IBAction func goResults(_ sender: UIButton) {
        if UserDefaults.standard.bool(forKey: "voice") {
            playSoundWith(fileName: "Back", fileExtinsion: "wav")
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Results") as! Results
        present(vc, animated: true, completion: nil)
    }
    @IBAction func goTutorial(_ sender: UIButton) {
        if UserDefaults.standard.bool(forKey: "voice") {
            playSoundWith(fileName: "Back", fileExtinsion: "wav")
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Tutorial") as! Tutorial
        vc.tutorial = "To add, swipe one number onto another"
        present(vc, animated: true, completion: nil)
    }
}
