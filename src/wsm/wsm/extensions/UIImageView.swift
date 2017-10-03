//
//  UIImageView.swift
//  wsm
//
//  Created by framgia on 9/21/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation

extension UIImageView {
    func downloadImageFrom(url: URL, contentMode: UIViewContentMode) {
        URLSession.shared.dataTask(with: url, completionHandler: { (data, _, _) -> Void in
            DispatchQueue.main.async {
                self.contentMode =  contentMode
                if let data = data {
                    self.image = UIImage(data: data)
                }
            }
        }).resume()
    }

    func circleImage() {
        layer.borderWidth = 0.5
        layer.masksToBounds = false
        layer.borderColor = UIColor.gray.cgColor
        layer.cornerRadius = frame.height/2
        clipsToBounds = true
    }

    func setImage(image: UIImage?, withColor: UIColor? = nil) {
        if let image = image {
            let tintedImage = image.withRenderingMode(.alwaysTemplate)
            self.image = tintedImage
            if let withColor = withColor {
                self.tintColor = withColor
            }
        }
    }
}
