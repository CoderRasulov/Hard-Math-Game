//
//  Results.swift
//  Hard Math Game
//
//  Created by Asliddin Rasulov on 2/27/20.
//  Copyright © 2020 Asliddin Rasulov. All rights reserved.
//

import UIKit

class Results: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var totalSatarsFont: UILabel!
    @IBOutlet weak var totalCardsFont: UILabel!
    
    @IBOutlet weak var totalStars: UILabel!
    @IBOutlet weak var totalCards: UILabel!
    
    var titles: [String] = ["Let`s start", "1, 2, 3, 4", "Get 24", "Minus", "Lucky 7", "Devide to 1"]
    
    var countStars: Int = 0
    var countCards: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.font = titleLabel.font.withSize(view.frame.height / 20)
        totalSatarsFont.font = totalSatarsFont.font.withSize(view.frame.height / 30)
        totalCardsFont.font = totalCardsFont.font.withSize(view.frame.height / 30)
        
        for i in titles.indices {
            countStars += UserDefaults.standard.integer(forKey: "stars\(titles[i])")
            countCards += UserDefaults.standard.integer(forKey: "cards\(titles[i])")
        }
        totalStars.text = "\(countStars)"
        totalCards.text = "\(countCards)"
    }
    
    @IBAction func back(_ sender: UIButton) {
        if UserDefaults.standard.bool(forKey: "voice") {
            playSoundWith(fileName: "Back", fileExtinsion: "wav")
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "menu") as! Home
        present(vc, animated: true, completion: nil)
    }
}
