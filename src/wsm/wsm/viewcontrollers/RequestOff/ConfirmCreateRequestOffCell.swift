//
//  ConfirmCreateRequestOffCell.swift
//  wsm
//
//  Created by Lê Thanh Quang on 10/17/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import UIKit

class ConfirmCreateRequestOffCell: UITableViewCell {

    //MARK: IBOutlet
    @IBOutlet weak var iconImgView: UIImageView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func updateCell(item: DetailModel) {
        headerLabel.text = item.header
        valueLabel.text = item.value

        let image = UIImage(named: item.imageName)
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        iconImgView.image = tintedImage
        iconImgView.tintColor = UIColor.appBarTintColor

        valueLabel.textColor = item.valueColor ?? .black
    }
}
