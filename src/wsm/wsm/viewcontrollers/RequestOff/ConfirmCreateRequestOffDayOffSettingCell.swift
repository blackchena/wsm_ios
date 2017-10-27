//
//  ConfirmCreateRequestOffDayOffSettingCell.swift
//  wsm
//
//  Created by Lê Thanh Quang on 10/18/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import UIKit

class ConfirmCreateRequestOffDayOffSettingCell: UITableViewCell {

    //MARK: IBOutlet
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var valueLable: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    public func updateCell(item: DetailModel) {
        titleLable.text = item.header
        valueLable.text = item.value
    }

}
