//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by juan on 9/26/19.
//  Copyright © 2019 jarcos. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    @IBOutlet weak var memeImage: UIImageView!
    
    var meme: MemeModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let memeObj = meme, let memeImg = memeObj.memedImage {
            self.memeImage.image = memeImg
        }
        
    }
    
}
