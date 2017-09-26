//
//  ViewController.swift
//  wsm
//
//  Created by nguyen.van.hung on 9/18/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

class LoginViewController: BaseViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var backgroundView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        //dummy
        emailTextField.text = "le.quang.dao@framgia.com.edev"
        passwordTextField.text = "123456"

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = backgroundView.frame
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.colors = [UIColor.init(hexString: "#67BBB4").cgColor,
                                UIColor.init(hexString: "#228E83").cgColor]
        backgroundView.layer.addSublayer(gradientLayer)

        emailTextField.setLeftImage(size: emailTextField.frame.height,
                                    image: "ic_personal_information",
                                    color: UIColor.white)
        passwordTextField.setLeftImage(size: emailTextField.frame.height,
                                    image: "ic_password",
                                    color: UIColor.white)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginButtonClick(_ sender: Any) {
        login(with: emailTextField.text!, password: passwordTextField.text!)
    }
    @IBAction func forgotButtonClick(_ sender: Any) {
    }
}

extension LoginViewController: LoginControllerType {
    func didLoginSuccess() {
        AppDelegate.initRootViewControllerIfDidLogin()
    }
}
