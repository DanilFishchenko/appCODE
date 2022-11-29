//
//  RatingControl.swift
//  appCODE
//
//  Created by Danil Fishchenko on 28.11.2022.
//

import UIKit
import SwiftUI

@IBDesignable class RatingControl :UIStackView {
    //MARK: Init
    private var ratingButtons = [UIButton]()
    
    var rating = 0
      
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        setupButtons()
    }
    
    required init(coder: NSCoder) {
        super .init(coder: coder)
        setupButtons()
    }
    
    //MARK: Methods
    @objc func ratingButtonTapped(button:UIButton){
        print ("Button Tapped 👍 \(button)")
    }
    
    private func setupButtons() {
        
        //Создаём 5 кнопок
        for _ in 0..<5 {
        //Создать кнопку
        let button = UIButton()
        //Покрасить кнопку
        button.backgroundColor = .red
        //Констрейнты
        // Откючить автоконстрейнты (внутри стекВью не работает по умолчанию? в остальных местах нужно выключать вручную)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        //Высота и ширина кнопки
        button.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
        button.widthAnchor.constraint(equalToConstant: 44.0).isActive = true
        button.addTarget(self, action: #selector(ratingButtonTapped(button:)), for: .touchUpInside)
        
        //Добавить объект на вью
        addArrangedSubview(button)
        //добавить кнопку в массив кнопок
        ratingButtons.append(button)
            
        }
        self.spacing = 8.0
                
   
    }
    
      
}
