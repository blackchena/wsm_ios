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

    @IBOutlet weak var requestTimeTitleLabel: LocalizableLabel!
    @IBOutlet weak var leaveTypeLabel: LocalizableLabel!
    @IBOutlet weak var requestTimeLabel: LocalizableLabel!
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var requestTypeImageView: UIImageView!
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var seperatorLineView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        circleView.setCircleView()
    }

    func updateRequestLeaveCell(request: RequestLeaveModel) {
        leaveTypeLabel.text = request.leaveType?.name
        requestTimeLabel.text = request.getRequestTimeString()
        statusImageView.image = request.status?.getIcon()
    }

    func updateRequestOffCell(request: RequestOffModel) {
        requestTimeTitleLabel.text = LocalizationHelper.shared.localized("date_of_creation")
        leaveTypeLabel.textColor = .darkGray
        seperatorLineView.backgroundColor = UIColor.red
        requestTypeImageView.image = UIImage(named: "ic_day_off")

        requestTimeLabel.text = request.createdAt?.toString(dateFormat: AppConstant.onlyDateFormat)
        statusImageView.image = request.status?.getIcon()
    }
}
