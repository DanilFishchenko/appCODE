//
//  PlaceModel.swift
//  appCODE
//
//  Created by Danil Fishchenko on 05.08.2022.
//

import RealmSwift
import Foundation

class Place : Object {
    @objc dynamic var name = ""
    @objc dynamic var location: String?
    @objc dynamic var type: String?
    @objc dynamic var imageData: Data?
    @objc dynamic var date = Date()
    
    // инициализатор класса (назначенный, пожтому сначала надо вызвать инициализатор по умолчанию)
    convenience init(name:String, location:String?, type:String?, imageData:Data?){
        self.init()
        self.name = name
        self.location = location
        self.type = type
        self.imageData = imageData
    }
    
    
}
