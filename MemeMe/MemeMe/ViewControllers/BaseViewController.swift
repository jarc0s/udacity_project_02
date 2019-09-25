//
//  BaseViewController.swift
//  MemeMe
//
//  Created by juan on 9/18/19.
//  Copyright © 2019 jarcos. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func showMemeEditor() {
        let memeVC : MemeViewController
        memeVC = storyboard?.instantiateViewController(withIdentifier: "MemeViewController") as! MemeViewController
        present(memeVC, animated: true, completion: nil)
    }
}
