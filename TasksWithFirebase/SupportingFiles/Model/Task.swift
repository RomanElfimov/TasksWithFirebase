//
//  Task.swift
//  TasksWithFirebase
//
//  Created by Роман Елфимов on 06.05.2020.
//  Copyright © 2020 Роман Елфимов. All rights reserved.
//

import Foundation
import Firebase

struct Task {
    let title: String
    //человек, которому присвоена задача
    let userId: String
    //свойство нужно для того чтобы добраться до объекта
    let ref: DatabaseReference?
    var completed: Bool = false
    
    //Создать объект локально
    init(title: String, userId: String) {
        self.title = title
        self.userId = userId
        self.ref = nil
    }
    
    //Извлечь объект из базы данных // snapshot - это и есть вложенный json
    init(snapshot: DataSnapshot) {
        //когда получаем текущее значение хранящееся в базе, получаем snapshot
        
        //тип ключа - String, тип значения любой
        let snapshotValue = snapshot.value as! [String: AnyObject]
        title = snapshotValue["title"] as! String
        userId = snapshotValue["userId"] as! String
        completed = snapshotValue["completed"] as! Bool
        ref = snapshot.ref
    }
    
    func convertToDictionary() -> Any {
        return ["title": title, "userId": userId, "completed": completed]
    }
}
