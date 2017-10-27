//
//  StatisticDetailCell.swift
//  wsm
//
//  Created by framgia on 10/24/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import UIKit

class StatisticGroupCell: UITableViewCell {

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var approveTitleLabel: UILabel!
    @IBOutlet weak var rejectTitleLabel: UILabel!
    @IBOutlet weak var approveValueLable: UILabel!
    @IBOutlet weak var rejectValueLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func updateCell(group: GroupStatisticsModel) {
        headerLabel.text = group.title
        if group.detail.count >= 2,
            let approveVal = group.detail[0].value,
            let rejectVal = group.detail[1].value {
            approveTitleLabel.text = group.detail[0].title
            approveValueLable.text = "\(approveVal)"
            rejectTitleLabel.text = group.detail[1].title
            rejectValueLabel.text = "\(rejectVal)"
        }
    }
}
