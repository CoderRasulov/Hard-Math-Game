//
//  Tutorial.swift
//  Hard Math Game
//
//  Created by Asliddin Rasulov on 2/27/20.
//  Copyright © 2020 Asliddin Rasulov. All rights reserved.
//

import UIKit

class Tutorial: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet weak var goalValue: UILabel!
    @IBOutlet weak var tutorialLabel: UILabel!
    @IBOutlet var numberButtons: [MDCFloatingButton]!
    
    var animation: Int = 0
    var pushshed: Int = 0
    var goal: String = "10"
    var tutorial: String?
    var buttonCenter: CGPoint?
    var checkLocation: CGPoint?
    var multiply: [MDCFloatingButton] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.font = titleLabel.font.withSize(view.frame.height / 20)
        goalLabel.font = goalLabel.font.withSize(view.frame.height / 20)
        goalValue.font = goalValue.font.withSize(view.frame.height / 15)
        
        tutorialLabel.text = tutorial
        goalValue.text = goal
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            if self.animation == 0 {
                UIView.animate(withDuration: 1, animations: {
                    self.tutorialLabel.transform = CGAffineTransform(scaleX: 1, y: 0.8)
                    self.animation = 1
                })
            } else {
                UIView.animate(withDuration: 1, animations: {
                    self.tutorialLabel.transform = CGAffineTransform(scaleX: 0.8, y: 1)
                    self.animation = 0
                })
            }
        }
        
        for i in 0..<numberButtons.count {
            
//            numberButtons[i].setTitleFont(numberButtons[i].titleLabel?.font.withSize(view.frame.height / 25), for: .normal)
//            
//            numberButtons[i].setBorderWidth(4, for: .normal)
//            numberButtons[i].setBorderColor(UIColor.white, for: .normal)
            if goal == "10" {
                let pan = UIPanGestureRecognizer(target: self, action: #selector(Tutorial.panButton(pan:)))
                numberButtons[i].addGestureRecognizer(pan)
            } else {
                let tap = UITapGestureRecognizer(target: self, action: #selector(Tutorial.tapView(tap:)))
                view.addGestureRecognizer(tap)
            }
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
    
    @IBAction func nummberAction(_ sender: MDCFloatingButton) {
        if UserDefaults.standard.bool(forKey: "voice") {
            playSoundWith(fileName: "Back", fileExtinsion: "wav")
        }
        if goal == "10" {
            return
        }
        sender.layer.borderColor = UIColor.systemRed.cgColor
        pushshed += 1
        multiply.append(sender)
        if pushshed == 2 && multiply[0].center != multiply[1].center {
            for i in numberButtons.indices {
                if multiply[0].center == numberButtons[i].center {
                    numberButtons[i].isHidden = true
                    numberButtons.remove(at: i)
                    break
                }
            }
            for i in numberButtons.indices {
                if multiply[1].center == numberButtons[i].center {
                    let result = Int(multiply[0].currentTitle!)! * Int(multiply[1].currentTitle!)!
                    numberButtons[i].setTitle("\(result)", for: .normal)
                    break
                }
            }
            for i in numberButtons.indices {
                numberButtons[i].layer.borderColor = UIColor.white.cgColor
                pushshed = 0
                multiply.removeAll()
            }
        } else
        if pushshed == 2 && multiply[0].center == multiply[1].center {
            pushshed = 1
            multiply.remove(at: 1)
        }
        if numberButtons.count == 1 {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "menu") as! Home
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    @objc func tapView(tap: UITapGestureRecognizer) {
        if pushshed > 0 {
            for i in numberButtons.indices {
                numberButtons[i].layer.borderColor = UIColor.white.cgColor
            }
            pushshed = 0
            multiply.removeAll()
        }
    }
    @objc func panButton(pan: UIPanGestureRecognizer) {
        if UserDefaults.standard.bool(forKey: "voice") {
            playSoundWith(fileName: "Back", fileExtinsion: "wav")
        }
        let button = pan.view as? MDCFloatingButton
                
        button?.layer.borderColor = UIColor.systemRed.cgColor
        
        if pan.state == .began {
            buttonCenter = button?.center
        } else
        if pan.state == .ended || pan.state == .failed || pan.state == .cancelled {
            if checkLocation != button?.center {
                for i in numberButtons.indices {
                    if checkLocation == numberButtons[i].center {
                        let result = Int(button!.currentTitle!)! + Int(numberButtons[i].currentTitle!)!
                        numberButtons[i].setTitle("\(result)", for: .normal)
                        button?.isHidden = true
                        break
                    }
                }
            } else {
                numberButtons.append(button!)
                button?.center = buttonCenter!
            }
            
            for i in numberButtons.indices {
                numberButtons[i].layer.borderColor = UIColor.white.cgColor
            }
            
            if numberButtons.count == 1 {
                numberButtons[0].isHidden = true
                let nextButton = UIButton(frame: CGRect(x: (view.frame.width - 0.15 * view.frame.height) / 2, y: 0.65 * view.frame.height, width: 0.15 * view.frame.height, height: 0.15 * view.frame.height))
                nextButton.layer.cornerRadius =  0.15 * view.frame.height / 2
                nextButton.backgroundColor = .white
                nextButton.setTitleColor(.systemRed, for: .normal)
                nextButton.layer.borderWidth = 4
                nextButton.layer.borderColor = UIColor.systemRed.cgColor
                nextButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: view.frame.height / 35)
                nextButton.setTitle("Next", for: .normal)
                nextButton.addTarget(self, action: #selector(nextAction), for: .touchUpInside)
                view.addSubview(nextButton)
            }
        } else {
            
            let location = pan.location(in: view)
            button?.center = location
            
            for i in numberButtons.indices {
                if numberButtons[i].center == location {
                    numberButtons.remove(at: i)
                    break
                }
            }
            
            for i in numberButtons.indices {
                numberButtons[i].layer.borderColor = UIColor.white.cgColor
            }
            
            checkLocation = location
            
            for i in numberButtons.indices {
                if sqrt(pow(location.x - numberButtons[i].center.x, 2) + pow(location.y - numberButtons[i].center.y, 2)) < button!.frame.width {
                    numberButtons[i].layer.borderColor = UIColor.systemRed.cgColor
                    checkLocation = numberButtons[i].center
                    break
                } else {
                    numberButtons[i].layer.borderColor = UIColor.white.cgColor
                }
            }

        }
    }
    @objc func nextAction() {
        if UserDefaults.standard.bool(forKey: "voice") {
            playSoundWith(fileName: "Back", fileExtinsion: "wav")
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Tutorial") as! Tutorial
        vc.tutorial = "To multiply, click two numbers"
        vc.goal = "24"
        present(vc, animated: true, completion: nil)
    }
    
}
