//
//  MemeExtensions.swift
//  MemeMe
//
//  Created by juan on 9/26/19.
//  Copyright © 2019 jarcos. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    
    func setMemeFormatString() {
        let memeTextAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 20)!,
            NSAttributedString.Key.strokeWidth: -3.0
        ]
        
        let myAttrString = NSAttributedString(string: (self.text ?? ""), attributes: memeTextAttributes)
        
        self.attributedText = myAttrString
    }
}
