//
//  StorageManager.swift
//  appCODE
//
//  Created by Danil Fishchenko on 25.08.2022.
//

import RealmSwift

//создаем объект базы данных
let realm = try! Realm()


//менеджер хранилища. В этом классе прописываем методы обращения к БД и потом через это класс обращаемся к этим методам (добавления и удаления)
class StorageManager {
    //сохранение объекта в БД
    static func saveObject(_ place:Place){
        try! realm.write{
            realm.add(place)
        }
        
    }
    //удаление объекта из БД
    static func deleteObject(_ place:Place){
        try! realm.write{
            realm.delete(place)
    }
    
}
    
}
