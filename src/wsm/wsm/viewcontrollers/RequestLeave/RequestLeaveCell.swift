//
//  RequestLeaveCell.swift
//  wsm
//
//  Created by framgia on 10/6/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import UIKit
import InAppLocalize

class RequestLeaveCell: UITableViewCell {

    @IBOutlet weak var leaveTypeLabel: LocalizableLabel!
    @IBOutlet weak var requestTimeLabel: LocalizableLabel!
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var circleView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        circleView.layer.cornerRadius = circleView.frame.height/2
    }

    func updateCell(request: RequestLeaveModel) {
        leaveTypeLabel.text = request.leaveType?.name
        requestTimeLabel.text = request.getRequestTimeString()
        statusImageView.image = request.getStatusImage()
    }
}
