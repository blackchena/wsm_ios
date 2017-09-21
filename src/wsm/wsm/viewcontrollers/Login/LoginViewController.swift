//
//  ViewController.swift
//  wsm
//
//  Created by nguyen.van.hung on 9/18/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //dummy
        emailTextField.text = "nguyen.le.si.nguyen@framgia.com.edev"
        passwordTextField.text = "123456"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func loginButtonClick(_ sender: Any) {
        login(with: emailTextField.text!, password: passwordTextField.text!)
    }
}

extension LoginViewController: LoginControllerType {
    func didLogin(with user: User?) {
        let navigationController = getStoryboardController(identifier: "NavigationController")
        let mainViewController = getStoryboardController(identifier: "MainViewController")
        let timeSheetVc = getStoryboardController(identifier: "TimeSheetViewController")

        guard let mainNav = navigationController as? NavigationController else {
            return
        }

        mainNav.setViewControllers([timeSheetVc], animated: false)

        guard let mainVc = mainViewController as? MainViewController else {
            return
        }

        mainVc.rootViewController = mainNav

        if let window = UIApplication.shared.delegate?.window {
            window!.rootViewController = mainViewController
            UIView.transition(with: window!,
                              duration: 0.3,
                              options: [.transitionCrossDissolve],
                              animations: nil, completion: nil)
        }
    }
}
