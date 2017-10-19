//
//  ProfileHeaderCell.swift
//  wsm
//
//  Created by framgia on 10/17/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import UIKit
import InAppLocalize

class ProfileHeaderView: UIView {

    @IBOutlet weak var coverView: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var changePasswordView: CardView!

    var changePasswordButtonAction: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // Performs the initial setup.
    private func setupView() {
        if let view = Bundle.main.loadNibNamed("ProfileHeaderView", owner: self, options: nil)?.first as? UIView {
            view.frame = bounds
            // Auto-layout stuff.
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            // Show the view.
            addSubview(view)

            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = coverView.frame
            gradientLayer.colors = [UIColor(red: 142, green: 184, blue: 181).cgColor,
                                    UIColor(red: 36, green: 153, blue: 136).cgColor]
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
            coverView.layer.addSublayer(gradientLayer)

            changePasswordView.setCircleView()
            avatarImageView.circleImage()

            let profile = UserServices.getLocalUserProfile()
            if let url = profile?.getAvatarURL() {
                avatarImageView.downloadImageFrom(url: url, contentMode: .scaleToFill)
            }
            nameLabel.setTextPartBold(boldText: LocalizationHelper.shared.localized("name") + ": ",
                                      normalText: profile?.name ?? LocalizationHelper.shared.localized("empty_information"))
            emailLabel.setTextPartBold(boldText: LocalizationHelper.shared.localized("email") + ": ",
                                       normalText: profile?.email ?? LocalizationHelper.shared.localized("empty_information"))
            countryLabel.setTextPartBold(boldText: LocalizationHelper.shared.localized("nationlaty") + ": ",
                                         normalText: profile?.generalInfo?.nationality ?? LocalizationHelper.shared.localized("empty_information"))
            genderLabel.setTextPartBold(boldText: LocalizationHelper.shared.localized("gender") + ": ",
                                        normalText: profile?.gender ?? LocalizationHelper.shared.localized("empty_information"))
            birthdayLabel.setTextPartBold(boldText: LocalizationHelper.shared.localized("birthday") + ": ",
                                          normalText: profile?.birthday?.toString(dateFormat: LocalizationHelper.shared.localized("date_format")) ?? LocalizationHelper.shared.localized("empty_information"))
        }
    }
    
    @IBAction func changePasswordButtonClick(_ sender: Any) {
        changePasswordButtonAction?()
    }
}
