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
    
    // Создаем наблюдателя
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ref.observe(.value) { [weak self] (snapshot) in
            
            var _tasks = Array<Task>()
            for item in snapshot.children {
                //Получаем task
                let task = Task(snapshot: item as! DataSnapshot)
                _tasks.append(task)
            }
            
            self?.tasks = _tasks
            self?.tableView.reloadData()
        }
    }
    
    //Удаляем наблюдателя по выходу
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ref.removeAllObservers()
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
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.backgroundColor = .clear
        cell.textLabel?.textColor = .white
        
        let task = tasks[indexPath.row]
        let taskTitle = task.title
        cell.textLabel?.text = taskTitle
        
        let isCompleted = task.completed
        toggleCompetion(cell, isCompleted: isCompleted)
        
        return cell
    }
    
    // Editing
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = tasks[indexPath.row]
            // Удалить объект
            task.ref?.removeValue()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        let task = tasks[indexPath.row]
        let isCompleted = !task.completed
        
        toggleCompetion(cell, isCompleted: isCompleted)
        //Передаем изменения в базу данных
        task.ref?.updateChildValues(["completed": isCompleted])
    }
        
    // Отрисовать галочку
    func toggleCompetion(_ cell: UITableViewCell, isCompleted: Bool) {
        cell.accessoryType = isCompleted ? .checkmark : .none
    }
    
}
