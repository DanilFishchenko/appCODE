//
//  StorageManager.swift
//  appCODE
//
//  Created by Danil Fishchenko on 25.08.2022.
//

import RealmSwift

//создаем объект базы данных
let realm = try! Realm()


class StorageManager {
    static func saveObject(_ place:Place){
        try! realm.write{
            realm.add(place)
        }
        
    }
    
}
