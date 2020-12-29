//
//  MDCFloatingButton.swift
//  Hard Math Game
//
//  Created by Asliddin Rasulov on 29/12/20.
//  Copyright © 2020 Asliddin Rasulov. All rights reserved.
//

import UIKit

class MDCFloatingButton: UIButton {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 4
        layer.cornerRadius = UIScreen.main.bounds.height * 0.06
    }
}
