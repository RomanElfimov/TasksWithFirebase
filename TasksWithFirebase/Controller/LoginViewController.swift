//
//  ViewController.swift
//  TasksWithFirebase
//
//  Created by Роман Елфимов on 06.05.2020.
//  Copyright © 2020 Роман Елфимов. All rights reserved.
//

import UIKit
import Firebase

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
        
        //При загрузке ярлык с предупреждениями прозрачный
        warnLabel.alpha = 0
        
        //Если пользователь зарегестрирован, пропускаем экран регистрации
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                self.performSegue(withIdentifier: "tasksSegue", sender: nil)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //При повторной загрузке экрана очищаем информацию о пользователе
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    
    //Какое предупреждение показать в warnLabel
    func displayWarningLabel(with text: String) {
        warnLabel.text = text
        
        //С анимацией 3 секунды curveEaseInOut
        UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [.curveLinear], animations: { [weak self] in
            self?.warnLabel.alpha = 1
        }) { [weak self] complete in
            self?.warnLabel.alpha = 0
        }
    }
    
    //MARK: - Actions
    @IBAction func loginTapped(_ sender: UIButton) {
        
        //Проверяем корректность введенных данных
        guard let email = emailTextField.text, let password = passwordTextField.text, email != "", password != "" else {
            //Общая ошибка
            displayWarningLabel(with: "Некорректные данные")
            return
        }
        
        //Логинимся
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (user, error) in
            //Если возникла ошибка
            if error != nil {
                self?.displayWarningLabel(with: "Возникла ошибка")
                return
            }
            
            //Проверяем существование пользователя
            //Пользователь есть
            if user != nil {
                self?.performSegue(withIdentifier: "tasksSegue", sender: nil)
                return
            }
            //Пользователя нет
            self?.displayWarningLabel(with: "Нет пользователя")
        }
    }
    

    @IBAction func registerTapped(_ sender: UIButton) {
        
        guard let email = emailTextField.text, let password = passwordTextField.text, email != "", password != ""
            else {
                displayWarningLabel(with: "Некорректные данные")
                return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] (user, error) in
            //Если нет ошибки и пользователь существует
            if error == nil {
                if user != nil {
                    self?.displayWarningLabel(with: "Успешно")
                    print("user is created")
                } else {
                    self?.displayWarningLabel(with: "Пользователь не создан")
                    print("user is not created")
                }
            } else {
                self?.displayWarningLabel(with: "Пользователь уже существует")
                print(error?.localizedDescription)
            }
        }
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
