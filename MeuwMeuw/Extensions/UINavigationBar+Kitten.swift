//
//  UINavigationBar+Kitten.swift
//  MeuwMeuw
//
//  Created by Vingle on 2018. 8. 15..
//  Copyright © 2018년 Geektree0101. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationBar {
    func transparente(buttonColor: UIColor = .white) {
        self.tintColor = buttonColor
        self.setBackgroundImage(UIImage(), for: .default)
        self.shadowImage = UIImage()
        self.isTranslucent = true
    }
}
