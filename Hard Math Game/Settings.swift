//
//  Settings.swift
//  Hard Math Game
//
//  Created by Asliddin Rasulov on 2/27/20.
//  Copyright © 2020 Asliddin Rasulov. All rights reserved.
//

import UIKit
import MessageUI

class Settings: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var soundSwitch: UISwitch!
    @IBOutlet weak var timerSwitch: UISwitch!
    
    var sound: Bool = true
    var timer: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.font = titleLabel.font.withSize(view.frame.height / 25)
        
        if UserDefaults.standard.bool(forKey: "voice") {
            soundSwitch.setOn(true, animated: true)
            soundSwitch.thumbTintColor = .systemRed
        } else {
            soundSwitch.setOn(false, animated: true)
            soundSwitch.thumbTintColor = .white
        }
        if UserDefaults.standard.bool(forKey: "showTimer") {
            timerSwitch.setOn(true, animated: true)
            timerSwitch.thumbTintColor = .systemRed
        } else {
            timerSwitch.setOn(false, animated: true)
            timerSwitch.thumbTintColor = .white
        }
    }
    
    @IBAction func back(_ sender: UIButton) {
        if UserDefaults.standard.bool(forKey: "voice") {
            playSoundWith(fileName: "Back", fileExtinsion: "wav")
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "menu") as! Home
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func soundSwitchAction(_ sender: UISwitch) {
        if soundSwitch.isOn {
            sound = true
            playSoundWith(fileName: "Back", fileExtinsion: "wav")
            soundSwitch.thumbTintColor = .systemRed
        } else {
            sound = false
            soundSwitch.thumbTintColor = .white
        }
        UserDefaults.standard.set(sound, forKey: "voice")
    }
    
    @IBAction func timerSwitchAction(_ sender: UISwitch) {
        if UserDefaults.standard.bool(forKey: "voice") {
            playSoundWith(fileName: "Back", fileExtinsion: "wav")
        }
        if timerSwitch.isOn {
            timer = true
            timerSwitch.thumbTintColor = .systemRed
        } else {
            timer = false
            timerSwitch.thumbTintColor = .white
        }
        UserDefaults.standard.set(timer, forKey: "showTimer")
    }
    
    @IBAction func sounds(_ sender: UIButton) {
        if soundSwitch.isOn {
            soundSwitch.setOn(false, animated: true)
            playSoundWith(fileName: "Back", fileExtinsion: "wav")
            sound = false
            soundSwitch.thumbTintColor = .white
        } else {
            soundSwitch.setOn(true, animated: true)
            sound = true
            soundSwitch.thumbTintColor = .systemRed
        }
        UserDefaults.standard.set(sound, forKey: "voice")
    }
    
    @IBAction func timer(_ sender: UIButton) {
        if UserDefaults.standard.bool(forKey: "voice") {
            playSoundWith(fileName: "Back", fileExtinsion: "wav")
        }
        if timerSwitch.isOn {
            timerSwitch.setOn(false, animated: true)
            timer = false
            timerSwitch.thumbTintColor = .white
        } else {
            timerSwitch.setOn(true, animated: true)
            timer = true
            timerSwitch.thumbTintColor = .systemRed
        }
        UserDefaults.standard.set(timer, forKey: "showTimer")
    }
    @IBAction func mail(_ sender: UIButton) {
        showMailComposer()
    }
    
    func showMailComposer() {
        if UserDefaults.standard.bool(forKey: "voice") {
            playSoundWith(fileName: "Back", fileExtinsion: "wav")
        }
        guard MFMailComposeViewController
            .canSendMail() else {
            return
        }
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = self
        composer.setToRecipients(["asliddinrasulov3@gmail.com"])
        composer.setSubject("SUGGESTION")
        composer.setMessageBody("SUGGESTION : ", isHTML: false)
        
        present(composer, animated: true, completion: nil)
    }
}

extension Settings: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if let _ = error {
            controller.dismiss(animated: true, completion: nil)
        }
        
        switch result {
        case .cancelled:
            print("Cancelled")
        case .failed:
            print("Failed")
        case .saved:
            print("Saved")
        case .sent:
            print("Email sent")
            
        default: break
            
        }
        
        controller.dismiss(animated: true, completion: nil)
    }
}
