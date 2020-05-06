//
//  ViewController.swift
//  TasksWithFirebase
//
//  Created by Роман Елфимов on 06.05.2020.
//  Copyright © 2020 Роман Елфимов. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    //MARK: - Outlet
    @IBOutlet weak var warnLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }

    
    //MARK: - Actions
    @IBAction func loginTapped(_ sender: UIButton) {
    }
    
    @IBAction func registerTapped(_ sender: UIButton) {
    }
    

}


//MARK: - Extension - UITextField Delegate
extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            self.passwordTextField.becomeFirstResponder()
        } else {
            self.passwordTextField.resignFirstResponder()
        }
        return true
    }
}
