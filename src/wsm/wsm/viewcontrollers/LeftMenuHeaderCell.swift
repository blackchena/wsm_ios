//
//  LeftMenuHeaderCell.swift
//  wsm
//
//  Created by framgia on 9/21/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import UIKit

class LeftMenuHeaderCell: UIView {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = backgroundView.frame
        gradientLayer.colors = [UIColor(red: 101/255, green: 125/255, blue: 156/255, alpha: 1).cgColor,
                                UIColor(red: 36/255, green: 153/255, blue: 136/255, alpha: 1).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        backgroundView.layer.addSublayer(gradientLayer)

        avatarImageView.circleImage()
        avatarImageView.backgroundColor = UIColor.white
    }

    @IBAction func logoutBtnClick(_ sender: Any) {
    }
}
