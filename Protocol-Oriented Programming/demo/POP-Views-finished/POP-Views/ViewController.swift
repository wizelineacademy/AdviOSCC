//
//  ViewController.swift
//  POP-Views
//
//  Created by Thien Liu on 7/22/17.
//  Copyright © 2017 Thien Liu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var userNameTextField: AnimatableTextField!
    @IBOutlet weak var passwordTextField: AnimatableTextField!
    @IBOutlet weak var signInButton: AnimatableButton!
    
    @IBOutlet weak var errorLabel: AnimatableLabel!
    
    @IBAction func signIn(_ sender: UIButton) {
        userNameTextField.shake()
        passwordTextField.shake()
        signInButton.shake()
        errorLabel.flash()
    }

}

