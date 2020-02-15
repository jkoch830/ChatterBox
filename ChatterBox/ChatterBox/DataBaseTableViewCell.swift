//
//  DataBaseTableViewCell.swift
//  ChatterBox
//
//  Created by Edward on 2/15/20.
//  Copyright © 2020 Edward. All rights reserved.
//

import UIKit

class DataBaseTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
