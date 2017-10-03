//
//  TimeSheetDetailViewCell.swift
//  wsm
//
//  Created by Lê Thanh Quang on 10/2/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import UIKit

class TimeSheetDetailViewCell: UITableViewCell {

    //MARK: IBOutlets
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var dayTitleLable: UILabel!
    @IBOutlet weak var morningValueLable: UILabel!
    @IBOutlet weak var afternoonValueLable: UILabel!
    @IBOutlet weak var otValueLable: UILabel!
    @IBOutlet weak var morningContainerView: CardView!
    @IBOutlet weak var afternoonContainerView: CardView!
    @IBOutlet weak var otContainerView: CardView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.isHidden = true
        iconImageView.setImage(image: UIImage(named: "ic_clock_2.png"), withColor: UIColor(hexString: "#069285"))
    }

    func setTimeSheetDayModel(timeSheet: TimeSheetDayModel?) {
        if let timeSheet = timeSheet {
            self.isHidden = false

            dayTitleLable.text = timeSheet.date?.toString(dateFormat: AppConstant.DateFormatEEEDisplay)

            morningContainerView.backgroundColor = timeSheet.morningColorDisplay
            afternoonContainerView.backgroundColor = timeSheet.afternoonColorDisplay

            morningValueLable.text = timeSheet.morningTextDisplay ?? " "
            afternoonValueLable.text = timeSheet.afternoonTextDisplay ?? " "

            if let otTime = timeSheet.hoursOverTime,
                otTime > 0 {
                otValueLable.text = "OT: \(otTime)"
                otContainerView.isHidden = false
            } else {
                otContainerView.isHidden = true
            }
        }
    }
}
