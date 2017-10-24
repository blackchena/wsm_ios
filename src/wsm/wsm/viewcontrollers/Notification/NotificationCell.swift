//
//  NotificationCell.swift
//  wsm
//
//  Created by framgia on 10/20/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import UIKit
import InAppLocalize

class NotificationCell: UITableViewCell {

    @IBOutlet weak var typeImageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func updateCell(notification: NotificationModel) {
        messageLabel.text = notification.message
        timeLabel.text = notification.createAt?.toString(dateFormat: LocalizationHelper.shared.localized("date_time_format"))
        typeImageView.image = notification.trackableType.getIcon()
        backgroundColor = notification.read == true ? .clear : UIColor.init(hexString: "#DEF1EF")
    }
}
