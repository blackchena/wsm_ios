//
//  ConfirmCreateOtCell.swift
//  wsm
//
//  Created by framgia on 9/26/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import UIKit

class ConfirmCreateRequestCell: UITableViewCell {
    
    @IBOutlet weak var iconImgView: UIImageView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func updateCell(item: ConfirmRequestItem) {
        headerLabel.text = item.header
        valueLabel.text = item.value

        let image = UIImage(named: item.imageName)
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        iconImgView.image = tintedImage
        iconImgView.tintColor = UIColor.appBarTintColor
    }
}
