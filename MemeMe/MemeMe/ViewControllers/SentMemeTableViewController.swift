//
//  SentMemeTableViewController.swift
//  MemeMe
//
//  Created by juan on 9/18/19.
//  Copyright © 2019 jarcos. All rights reserved.
//

import UIKit

class SentMemeTableViewController: UITableViewController {
    
    var memes: [MemeModel] {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("memes.count: \(memes.count)")
        self.tableView.reloadData()
    }
    
    
    
    @IBAction func showMemeEditor(_ sender: UIBarButtonItem) {
        let memeVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MemeViewController") as? MemeViewController
        self.navigationController?.pushViewController(memeVC!, animated: true)
        
    }
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeCell", for: indexPath)
            as! MemeTableViewCell
        
        let meme = self.memes[(indexPath as NSIndexPath).row]
        
        cell.labelTop.text = meme.topText ?? ""
        
        if let imageMeme = meme.memedImage {
            cell.imageMeme.image = imageMeme
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let meme = self.memes[(indexPath as NSIndexPath).row]
        let memeDetailVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MemeDetailViewController") as? MemeDetailViewController
        memeDetailVC?.meme = meme
        
        self.navigationController?.pushViewController(memeDetailVC!, animated: true)
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
