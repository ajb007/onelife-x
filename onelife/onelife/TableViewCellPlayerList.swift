//
//  TableViewCellPlayerList.swift
//  onelife
//
//  Created by Andy Bartlett on 26/03/2016.
//  Copyright © 2016 Andy Bartlett. All rights reserved.
//

import UIKit

class TableViewCellPlayerList: UITableViewCell {
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var playerTypeLabel: UILabel!
    @IBOutlet weak var playerLevelLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
