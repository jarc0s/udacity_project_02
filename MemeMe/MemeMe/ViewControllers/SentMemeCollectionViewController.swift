//
//  SentMemeCollectionViewController.swift
//  MemeMe
//
//  Created by juan on 9/25/19.
//  Copyright © 2019 jarcos. All rights reserved.
//

import Foundation
import UIKit

class SentMemeCollectionViewController: UICollectionViewController {
    
    var memes: [MemeModel] {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView.reloadData()
    }
    
    
    @IBAction func showMemeEditor(_ sender: UIBarButtonItem) {
        let memeVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MemeViewController") as? MemeViewController
        self.navigationController?.pushViewController(memeVC!, animated: true)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "memeCollectionCell", for: indexPath) as! MemeCollectionViewCell
        let meme = self.memes[(indexPath as NSIndexPath).row]
        
        cell.labelTop.text = meme.topText ?? ""
        cell.labelTop.setMemeFormatString()
        cell.labelBottom.text = meme.bottomText ?? ""
        cell.labelBottom.setMemeFormatString()
        
        if let memeImage = meme.originalImage {
            cell.memeImage.image = memeImage
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {
        let meme = self.memes[(indexPath as NSIndexPath).row]
        let memeDetailVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MemeDetailViewController") as? MemeDetailViewController
        memeDetailVC?.meme = meme
        self.navigationController?.pushViewController(memeDetailVC!, animated: true)
    }
    
}
