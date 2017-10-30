//
//  StatisticCell.swift
//  wsm
//
//  Created by framgia on 10/24/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import UIKit

class StatisticCell: UITableViewCell {

    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var valueLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func updateCell(item: StatisticItemModel) {
        titleLable.text = item.title
        if let val = item.value {
            valueLabel.text = "\(val)"
        }
    }
}
