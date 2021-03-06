//
//  Games.swift
//  Hard Math Game
//
//  Created by Asliddin Rasulov on 2/26/20.
//  Copyright © 2020 Asliddin Rasulov. All rights reserved.
//

import UIKit

class Bonus: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var firstType: UILabel!
    @IBOutlet weak var secondType: UILabel!
    
    @IBOutlet var numbersCollection: [MDCFloatingButton]!
    
    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet weak var goalValue: UILabel!
    
    @IBOutlet weak var hintButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    
    var calc = Calc()
    
    var types: [String]?
    var numbers: [Int]?
    
    var result: String?
    var levelsTitle: String?
    var computeLabel: String?
    var timer: String?
    
    var buttonCenter: CGPoint?
    var checkLocation: CGPoint?
    
    var timerTest: Timer?
    
    var pushed: Bool = true
    var forHelp: Bool = true
    var oneHelp: Bool = true
    
    var time: Double = 0.0
    
    var seconds: Int = 0
    var mark: Int = 0
    var push: Int = 0
    
    var multiply: [MDCFloatingButton] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.bool(forKey: "showTimer") {
            timerLabel.isHidden = false
        } else {
            timerLabel.isHidden = true
        }
        
        titleLabel.text = "Bonus"
        
        goalValue.text = result
        
        timer = time.printSecondsToHoursMinutesSeconds()
        if timer == "n/a" {
            timer = "0"
        }
        
        timerLabel.text = timer
        
        titleLabel.font = titleLabel.font.withSize(view.frame.height / 20)
        goalLabel.font = goalLabel.font.withSize(view.frame.height / 20)
        goalValue.font = goalValue.font.withSize(view.frame.height / 15)
        firstType.font = firstType.font.withSize(view.frame.height / 15)
        secondType.font = secondType.font.withSize(view.frame.height / 15)
        timerLabel.font = timerLabel.font.withSize(view.frame.height / 30)
        
        if levelsTitle == "Let`s start" || levelsTitle == "1, 2, 3, 4" || levelsTitle == "Get 24" {
            firstType.text = "+"
            secondType.text = "×"
        } else
        if levelsTitle == "Minus" {
            firstType.text = "-"
            secondType.text = "×"
        } else
        if levelsTitle == "Lucky 7" {
            firstType.text = "+"
            secondType.text = "÷"
        } else {
            firstType.text = "-"
            secondType.text = "÷"
        }
        
        types = [firstType.text!, secondType.text!]
        
        if numbers == nil {
            getNumbers()
            getGoal()
        } else {
            for i in 0..<numbersCollection.count {
                numbersCollection[i].setTitle("\(numbers![i])", for: .normal)
            }
        }
        
        for i in 0..<numbersCollection.count {
            
//            numbersCollection[i].setTitleFont(numbersCollection[i].titleLabel?.font.withSize(view.frame.height / 25), for: .normal)
//            
//            numbersCollection[i].setBorderWidth(4, for: .normal)
//            numbersCollection[i].setBorderColor(UIColor.white, for: .normal)
            
            let pan = UIPanGestureRecognizer(target: self, action: #selector(Tutorial.panButton(pan:)))
            numbersCollection[i].addGestureRecognizer(pan)
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(Tutorial.tapView(tap:)))
            view.addGestureRecognizer(tap)
        }
        
        timerTest = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (sec) in
            self.time += sec.timeInterval
            self.timer = self.time.printSecondsToHoursMinutesSeconds()
            self.seconds += 1
            self.timerLabel.text = self.timer
        }
    }

    @IBAction func numberActions(_ sender: MDCFloatingButton) {
        if UserDefaults.standard.bool(forKey: "voice") {
            playSoundWith(fileName: "Back", fileExtinsion: "wav")
        }
        sender.layer.borderColor = UIColor.systemRed.cgColor
        push += 1
        secondType.textColor = .systemRed
        multiply.append(sender)
        
        if push == 2 && secondType.text == "×" {
            if multiply[0].center != multiply[1].center {
                checkOperand()
            } else {
                secondType.textColor = .systemRed
                push = 1
                multiply.remove(at: 1)
            }
        } else
        if push == 2 && secondType.text == "÷" {
            if Int(multiply[0].currentTitle!)! != 0 && Int(multiply[1].currentTitle!)! != 0 {
                forHelp = Int(multiply[0].currentTitle!)! % Int(multiply[1].currentTitle!)! == 0 || Int(multiply[1].currentTitle!)! % Int(multiply[0].currentTitle!)! == 0
            } else {
                forHelp = false
            }
            
            if forHelp && multiply[0].center != multiply[1].center {
                checkOperand()
            } else
            if !forHelp && multiply[0].center != multiply[1].center {
                for i in numbersCollection.indices {
                    numbersCollection[i].layer.borderColor = UIColor.white.cgColor
                    secondType.textColor = .lightGray
                    push = 0
                    multiply.removeAll()
                }
            } else
            if forHelp && multiply[0].center == multiply[1].center {
                secondType.textColor = .systemRed
                push = 1
                multiply.remove(at: 1)
            }
        }
        checkWin()
    }
    func checkOperand() {
        for i in numbersCollection.indices {
            if multiply[0].center == numbersCollection[i].center {
                numbersCollection[i].isHidden = true
                numbersCollection.remove(at: i)
                break
            }
        }
        for i in numbersCollection.indices {
            if multiply[1].center == numbersCollection[i].center {
                let str = multiply[0].currentTitle! + secondType.text! + multiply[1].currentTitle!
                numbersCollection[i].setTitle(compute(text: str), for: .normal)
                break
            }
        }
        for i in numbersCollection.indices {
            numbersCollection[i].layer.borderColor = UIColor.white.cgColor
            secondType.textColor = .lightGray
            push = 0
            multiply.removeAll()
        }
    }
    @objc func tapView(tap: UITapGestureRecognizer) {
        if push > 0 {
            for i in numbersCollection.indices {
                numbersCollection[i].layer.borderColor = UIColor.white.cgColor
            }
            secondType.textColor = .lightGray
            push = 0
            multiply.removeAll()
        }
    }
    @objc func panButton(pan: UIPanGestureRecognizer) {
        if UserDefaults.standard.bool(forKey: "voice") {
            playSoundWith(fileName: "Back", fileExtinsion: "wav")
        }
        secondType.textColor = .lightGray
        multiply.removeAll()
        push = 0
        
        let button = pan.view as? MDCFloatingButton
                
        button?.layer.borderColor = UIColor.systemRed.cgColor
        
        if pan.state == .began {
            firstType.textColor = .systemRed
            buttonCenter = button?.center
        } else
        if pan.state == .ended || pan.state == .failed || pan.state == .cancelled {
            firstType.textColor = .lightGray
            if checkLocation != button?.center {
                for i in numbersCollection.indices {
                    if checkLocation == numbersCollection[i].center {
                        let str = button!.currentTitle! + firstType.text! + numbersCollection[i].currentTitle!
                        numbersCollection[i].setTitle(compute(text: str), for: .normal)
                        button?.isHidden = true
                        break
                    }
                }
            } else {
                numbersCollection.append(button!)
                button?.center = buttonCenter!
            }
            
            for i in numbersCollection.indices {
                numbersCollection[i].layer.borderColor = UIColor.white.cgColor
            }
            checkWin()
        } else {
            
            let location = pan.location(in: view)
            button?.center = location
            
            for i in numbersCollection.indices {
                if numbersCollection[i].center == location {
                    numbersCollection.remove(at: i)
                    break
                }
            }
            
            for i in numbersCollection.indices {
                numbersCollection[i].layer.borderColor = UIColor.white.cgColor
            }
            
            checkLocation = location
            
            for i in numbersCollection.indices {
                if sqrt(pow(location.x - numbersCollection[i].center.x, 2) + pow(location.y - numbersCollection[i].center.y, 2)) < button!.frame.width {
                    numbersCollection[i].layer.borderColor = UIColor.systemRed.cgColor
                    checkLocation = numbersCollection[i].center
                    break
                } else {
                    numbersCollection[i].layer.borderColor = UIColor.white.cgColor
                }
            }
        }
    }
    
    @IBAction func refreshBurrons(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Bonus") as! Bonus
        vc.time = time
        vc.result = result
        vc.numbers = numbers
        vc.seconds = seconds
        vc.oneHelp = oneHelp
        vc.levelsTitle = levelsTitle
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func helpButton(_ sender: UIButton) {
        if oneHelp {
            for i in numbersCollection.indices {
                if numbersCollection[i].currentTitle == doubleToString(result: helpNumbers[0]) {
                    numbersCollection[i].layer.borderColor = UIColor.green.cgColor
                    break
                }
            }
            for i in numbersCollection.indices {
                if numbersCollection[i].currentTitle == doubleToString(result: helpNumbers[1]) {
                    numbersCollection[i].layer.borderColor = UIColor.green.cgColor
                    break
                }
            }
            if "\(helpOperations[0])" == firstType.text {
                firstType.textColor = .systemGreen
            } else {
                secondType.textColor = .systemGreen
            }
            oneHelp = false
        }
        
    }
    
    func checkWin() {
        if numbersCollection.count == 1 && numbersCollection[0].currentTitle == goalValue.text {
            
            timerTest!.invalidate()
            
            numbersCollection[0].isHidden = true
            
            timer = timerLabel.text
            
            if UserDefaults.standard.integer(forKey: "timer\(levelsTitle!)bonus") > seconds || UserDefaults.standard.integer(forKey: "timer\(levelsTitle!)bonus") == 0 {
                UserDefaults.standard.set(seconds, forKey: "timer\(levelsTitle!)bonus")
            }
            
            if seconds <= 20 {
                timer = "Time: < 20s"
                mark = 3
            } else
            if seconds <= 60 {
                timer = "Time: < 60s"
                mark = 2
            } else {
                timer = "Game complated"
                mark = 1
            }
            let timeLabel = UILabel(frame: CGRect(x: 0, y: 0.6 * view.frame.height - 20, width: 0.5 * view.frame.width, height: 0.05 * view.frame.height))
            timeLabel.textColor = .systemRed
            timeLabel.textAlignment = .center
            timeLabel.font = UIFont(name: "Chalkboard SE", size: view.frame.height / 50)
            timeLabel.text = timer
            view.addSubview(timeLabel)
            
            let markOne = UILabel(frame: CGRect(x: 0.6 * view.frame.width, y: 0.6 * view.frame.height - 20, width: 20, height: 0.05 * view.frame.height))
            markOne.text = "★"
            markOne.textColor = .systemRed
            markOne.textAlignment = .center
            markOne.font = UIFont(name: "Chalkboard SE", size: view.frame.height / 50)
            view.addSubview(markOne)

            let markTwo = UILabel(frame: CGRect(x: 0.6 * view.frame.width + 25, y: 0.6 * view.frame.height - 20, width: 20, height: 0.05 * view.frame.height))
            if mark == 1 {
                markTwo.text = "☆"
                markTwo.textColor = .lightGray
            } else {
                markTwo.text = "★"
                markTwo.textColor = .systemRed
            }
            markTwo.textAlignment = .center
            markTwo.font = UIFont(name: "Chalkboard SE", size: view.frame.height / 50)
            view.addSubview(markTwo)
            let markThree = UILabel(frame: CGRect(x: 0.6 * view.frame.width + 50, y: 0.6 * view.frame.height - 20, width: 20, height: 0.05 * view.frame.height))
            if mark == 1 || mark == 2 {
                markThree.text = "☆"
                markThree.textColor = .lightGray
            } else {
                markThree.text = "★"
                markThree.textColor = .systemRed
            }
            markThree.textAlignment = .center
            markThree.font = UIFont(name: "Chalkboard SE", size: view.frame.height / 50)
            view.addSubview(markThree)
            
            helpNumbers.removeAll()
            helpOperations.removeAll()
            
            if numbersCollection[0].currentTitle == goalValue.text {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "Levels") as! Levels
                    vc.title = self.levelsTitle
                    self.present(vc, animated: true, completion: nil)
                }
            }
        }
    }
    
    func getNumbers() {
        if levelsTitle == "1, 2, 3, 4" {
            let nums1 = getNumbersInRange(min: 1, max: 4, count: 2)
            let nums2 = getNumbersInRange(min: 1, max: 4, count: 3)
            numbers = nums1 + nums2
        } else {
            numbers = getNumbersInRange(min: 1, max: 20, count: 5)
        }

        for i in 0..<numbersCollection.count {
            numbersCollection[i].setTitle("\(numbers![i])", for: .normal)
        }
    }
    
    func getGoal() {
        
        var str: String = "\(numbers![0])"
        
        for i in 1..<numbers!.count {
            str += (types!.randomElement()! + "\(numbers![i])")
        }
        
        if levelsTitle == "Devide to 1" {
            if result(text: str) == 1 {
                goalValue.text = result
            } else {
                helpNumbers.removeAll()
                helpOperations.removeAll()
                getNumbers()
                getGoal()
            }
        } else
        if levelsTitle == "Lucky 7" {
            if result(text: str) == 7 {
                goalValue.text = result
            } else {
                helpNumbers.removeAll()
                helpOperations.removeAll()
                getNumbers()
                getGoal()
            }
        } else
        if levelsTitle == "Get 24" {
            if result(text: str) == 24 {
                goalValue.text = result
            } else {
                helpNumbers.removeAll()
                helpOperations.removeAll()
                getNumbers()
                getGoal()
            }
        } else
        if result(text: str) <= 120 {
            goalValue.text = result
        } else {
            helpNumbers.removeAll()
            helpOperations.removeAll()
            getGoal()
        }
        
    }
    func compute(text: String) -> String {
        var compute = ""
        do {
            compute = try calc.compute(str: text).result
        } catch {}
        
        return compute
    }
    func result(text: String) -> Int {
        
        do {
            result = try calc.compute(str: text).result
        } catch {}
        
        let forDivision = (abs(Int(helpNumbers[0])) % abs(Int(helpNumbers[1])) != 0) && abs(Int(helpNumbers[0])) >= abs(Int(helpNumbers[1])) || (abs(Int(helpNumbers[1])) % abs(Int(helpNumbers[0])) != 0) && abs(Int(helpNumbers[0])) <= abs(Int(helpNumbers[1]))
        
        if (result != "1" || !text.contains("÷") || forDivision) && levelsTitle == "Devide to 1" {
            helpNumbers.removeAll()
            helpOperations.removeAll()
            getNumbers()
            getGoal()
        }
        if (result != "7" || !text.contains("÷") || forDivision) && levelsTitle == "Lucky 7" {
            helpNumbers.removeAll()
            helpOperations.removeAll()
            getNumbers()
            getGoal()
        }
        if !text.contains("×") && levelsTitle != "Devide to 1" && levelsTitle != "Lucky 7" {
            helpNumbers.removeAll()
            helpOperations.removeAll()
            getNumbers()
            getGoal()
        }
        
        return Int(result!)!
    }
    
    @IBAction func back(_ sender: UIButton) {
        if UserDefaults.standard.bool(forKey: "voice") {
            playSoundWith(fileName: "Back", fileExtinsion: "wav")
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Levels") as! Levels
        vc.title = levelsTitle
        helpNumbers.removeAll()
        helpOperations.removeAll()
        present(vc, animated: true, completion: nil)
    }
}
