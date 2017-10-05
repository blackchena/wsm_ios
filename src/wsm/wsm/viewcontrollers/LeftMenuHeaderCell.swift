//
//  LeftMenuHeaderCell.swift
//  wsm
//
//  Created by framgia on 9/21/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import UIKit
import Moya

class LeftMenuHeaderCell: UIView {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    var logoutAction: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = backgroundView.frame
        gradientLayer.colors = [UIColor(red: 101/255, green: 125/255, blue: 156/255, alpha: 1).cgColor,
                                UIColor(red: 36/255, green: 153/255, blue: 136/255, alpha: 1).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        backgroundView.layer.addSublayer(gradientLayer)

        let currentUser = UserServices.getLocalUserProfile ()
        nameLabel.text = currentUser?.name
        emailLabel.text = currentUser?.email

        avatarImageView.circleImage()
        avatarImageView.backgroundColor = UIColor.white
        if let url = currentUser?.getAvatarURL() {
            avatarImageView.downloadImageFrom(url: url, contentMode: avatarImageView.contentMode)
        }
    }

    @IBAction func logoutBtnClick(_ sender: Any) {
        logoutAction?()
    }
}
