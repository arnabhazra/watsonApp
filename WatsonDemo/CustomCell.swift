//
//  CustomCell.swift
//  WatsonDemo
//
//  Created by Arnab Hazra on 6/12/16.
//  Copyright © 2016 Arnab. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {

    @IBOutlet weak var labelTypeOne: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
