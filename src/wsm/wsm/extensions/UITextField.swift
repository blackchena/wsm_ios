//
//  UITextField.swift
//  wsm
//
//  Created by framgia on 9/21/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation

extension UITextField {
    var string: String { return text ?? "" }
    func setLeftImage(size: CGFloat, image: String, color: UIColor) {
        let lView = UIView(frame: CGRect(x: 0, y: 0, width: size, height: size))
        let image = UIImage(named: image)
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: tintedImage)

        imageView.frame = CGRect(x: 0, y: 0, width: size - 5, height: size - 5)
        imageView.tintColor = color

        lView.addSubview(imageView)

        leftView = lView
        leftViewMode = .always
    }
}
