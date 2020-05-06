//
//  TasksViewController.swift
//  TasksWithFirebase
//
//  Created by Роман Елфимов on 06.05.2020.
//  Copyright © 2020 Роман Елфимов. All rights reserved.
//

import UIKit
import Firebase

class TasksViewController: UIViewController {
    
    var user: AppUser!
    var ref: DatabaseReference!
    var tasks = Array<Task>()
    
    //MARK: - TableView Outlet
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Получаем текущего пользователя
        guard let currentUser = Auth.auth().currentUser else { return }
        user = AppUser(user: currentUser)
        //Поочередно добираемся до   users - user - tasks
        ref = Database.database().reference(withPath: "users").child(String(user.uid)).child("tasks")
    }
    
    //MARK: - Action
    @IBAction func addTapped(_ sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: "Новая задача", message: "Добавьте задачу", preferredStyle: .alert)
        alertController.addTextField()
        let save = UIAlertAction(title: "Сохранить", style: .default) { [weak self] _ in
            
            guard let textField = alertController.textFields?.first, textField.text != "" else { return }
            
            //Создаем задачу
            let task = Task(title: textField.text!, userId: (self?.user.uid)!)
            //Заголовок задачи используем в качестве папки в которой будет находиться эта задача
            let tasksRef = self?.ref.child(task.title.lowercased())
            //Поместить задачу task по адресу taskRef
            tasksRef?.setValue(task.convertToDictionary())
        }
        
        let cancel = UIAlertAction(title: "Отмена", style: .default, handler: nil)
        alertController.addAction(save)
        alertController.addAction(cancel)
        
        present(alertController, animated: true, completion: nil)
    }
    
    // Выходим из учетной записи
    @IBAction func signOutTapped(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error.localizedDescription)
        }
        dismiss(animated: true, completion: nil)
    }
    
}


//MARK: - Extension - UITableViewDelegate, UITableViewDataSource
extension TasksViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = "\(indexPath.row)"
        
        cell.backgroundColor = .clear
        
        return cell
    }
    
    
}
