//
//  Levels.swift
//  Hard Math Game
//
//  Created by Asliddin Rasulov on 2/26/20.
//  Copyright © 2020 Asliddin Rasulov. All rights reserved.
//

import UIKit

class Levels: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet var cardMarks: [UILabel]!
    
    @IBOutlet weak var countStars: UILabel!
    @IBOutlet weak var countCards: UILabel!
    
    @IBOutlet weak var bonusButton: MDCFloatingButton!
    @IBOutlet weak var bonusBlock: UIView!
    
    var countStar: Int = 0
    var countCard: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaults.standard.bool(forKey: "lockBonus\(title!)") {
            bonusBlock.isHidden = true
        } else {
            bonusBlock.isHidden = false
        }
        
        titleLabel.text = title
        titleLabel.font = titleLabel.font.withSize(view.frame.height / 20)
        countStars.font = countStars.font.withSize(view.frame.height / 40)
        countCards.font = countCards.font.withSize(view.frame.height / 40)
        bonusButton.layer.cornerRadius = bonusButton.frame.height / 2
        checkCardMarks(cardMarks: cardMarks)
    }
    
    @IBAction func back(_ sender: UIButton) {
        if UserDefaults.standard.bool(forKey: "voice") {
            playSoundWith(fileName: "Back", fileExtinsion: "wav")
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "menu") as! Home
        present(vc, animated: true, completion: nil)
    }
    @IBAction func goBonus(_ sender: MDCFloatingButton) {
        if UserDefaults.standard.bool(forKey: "lockBonus\(title!)") {
            if UserDefaults.standard.bool(forKey: "voice") {
                playSoundWith(fileName: "Back", fileExtinsion: "wav")
            }
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "Bonus") as! Bonus
            vc.levelsTitle = title
            present(vc, animated: true, completion: nil)
        }
    }
    func checkStarMarks(kIndex: Int, starMarks: [UILabel]) {
        
        let timer = UserDefaults.standard.integer(forKey: "timer\(title!)\(kIndex)")
    
        if timer <= 20 && timer != 0 {
            for i in 0...2 {
                starMarks[i].text = "★"
                starMarks[i].textColor = .systemRed
            }
            countStar += 3
        } else
        if timer <= 60 && timer != 0 {
            for i in 0...1 {
                starMarks[i].text = "★"
                starMarks[i].textColor = .systemRed
            }
            countStar += 2
        } else
        if timer > 60 && timer != 0 {
            starMarks[0].text = "★"
            starMarks[0].textColor = .systemRed
            countStar += 1
        }
        countStars.text = "\(countStar)" + " / 27"
        UserDefaults.standard.set(countStar, forKey: "stars\(title!)")
    }
    func checkCardMarks(cardMarks: [UILabel]) {
        
        let timer = UserDefaults.standard.integer(forKey: "timer\(title!)bonus")
    
        if timer <= 20 && timer != 0 {
            for i in 0...2 {
                cardMarks[i].text = "◆"
                cardMarks[i].textColor = .systemRed
            }
            countCard = 3
        } else
        if timer <= 60 && timer != 0 {
            for i in 0...1 {
                cardMarks[i].text = "◆"
                cardMarks[i].textColor = .systemRed
            }
            countCard = 2
        } else
        if timer > 60 && timer != 0 {
            cardMarks[0].text = "◆"
            cardMarks[0].textColor = .systemRed
            countCard = 1
        }
        
        countCards.text = "\(countCard) / 3"
        UserDefaults.standard.set(countCard, forKey: "cards\(title!)")
    }
}


extension Levels: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LevelsCell", for: indexPath) as! LevelsCell
        if UserDefaults.standard.integer(forKey: "timer\(title!)\(indexPath.row)") > 0 || indexPath.row == 0 {
            cell.blockView.isHidden = true
        } else {
            cell.blockView.isHidden = false
        }
        cell.lvlLabel.text = "Game \(indexPath.row + 1)"
        cell.lvlLabel.font = cell.lvlLabel.font.withSize(view.frame.height / 40)
        checkStarMarks(kIndex: indexPath.row + 1, starMarks: cell.starMarks)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (0.9 * view.frame.width - 40) / 3
        return CGSize(width: width, height: width)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if UserDefaults.standard.integer(forKey: "timer\(title!)\(indexPath.row)") > 0 || indexPath.row == 0 {
            if UserDefaults.standard.bool(forKey: "voice") {
                playSoundWith(fileName: "Back", fileExtinsion: "wav")
            }
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "Games") as! Games
            vc.level = indexPath.row
            vc.levelsTitle = title
            present(vc, animated: true, completion: nil)
        }
    }
}
