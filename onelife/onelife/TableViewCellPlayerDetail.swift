//
//  TableViewCellPlayerDetail.swift
//  onelife
//
//  Created by Andy Bartlett on 27/03/2016.
//  Copyright © 2016 Andy Bartlett. All rights reserved.
//

import UIKit

class TableViewCellPlayerDetail: UITableViewCell {

    @IBOutlet weak var statNameLabel: UILabel!
    @IBOutlet weak var statValueLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
