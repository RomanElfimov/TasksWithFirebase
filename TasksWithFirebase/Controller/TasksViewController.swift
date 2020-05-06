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

    //MARK: - TableView Outlet
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    //MARK: - Action
    @IBAction func addTapped(_ sender: UIBarButtonItem) {
        
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
