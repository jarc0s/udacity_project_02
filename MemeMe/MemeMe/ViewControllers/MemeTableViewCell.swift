//
//  MemeTableViewCell.swift
//  MemeMe
//
//  Created by juan on 9/24/19.
//  Copyright © 2019 jarcos. All rights reserved.
//

import UIKit

class MemeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageMeme: UIImageView!
    @IBOutlet weak var labelTop: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
