//
//  User.swift
//  TasksWithFirebase
//
//  Created by Роман Елфимов on 06.05.2020.
//  Copyright © 2020 Роман Елфимов. All rights reserved.
//

import Foundation
import Firebase

struct AppUser {
    let uid: String
    let email: String
    
    //Инициализатор нужен для того, чтобы можно было извлечь идентификатор пользователя и его email и работать с ними локально
    init(user: User) {
        self.uid = user.uid
        self.email = user.email!
    }
}
