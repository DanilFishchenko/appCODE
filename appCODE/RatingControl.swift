//
//  RatingControl.swift
//  appCODE
//
//  Created by Danil Fishchenko on 28.11.2022.
//

import UIKit
import SwiftUI

@IBDesignable class RatingControl :UIStackView {

    //MARK: Declaration
    var rating = 0 {
        didSet {
            updateButtonSelectionState()
        }
    }
    
    private var ratingButtons = [UIButton]()
    
    @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0){
        didSet {
            setupButtons()
        }
    }
    
    @IBInspectable var starCount: Int = 5 {
        didSet {
            setupButtons()
        }
    }
    
    
    //MARK: Init
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
        print ("Button Tapped 👍 \(ratingButtons.firstIndex(of: button)!)")
        guard let index = ratingButtons.firstIndex(of: button) else { return }
        var selectedRaiting = index + 1
        
        if selectedRaiting == rating{
            rating = 0
        } else {
            rating = selectedRaiting
        }
    }
    
    private func setupButtons() {
        
        //если уже что-то есть то удаляем это из массива и
        for button in ratingButtons {
            removeArrangedSubview(button)
            removeFromSuperview()
        }
        ratingButtons.removeAll()
        
        //Звезды
        let bundle = Bundle(for: type(of: self))
        let filledStar = UIImage(named: "filledStar",
                                 in: bundle,
                                 compatibleWith: self.traitCollection)
        
        let emptyStar = UIImage(named: "emptyStar",
                                in: bundle,
                                compatibleWith: self.traitCollection)
        
        let hilitedStar = UIImage(named: "hilitedStar",
                                  in: bundle,
                                  compatibleWith: self.traitCollection)
        
        
        //Создаём 5 кнопок
        for _ in 0..<starCount {
        //Создать кнопку
        let button = UIButton()
        //Покрасить кнопку
            button.setImage(emptyStar, for: .normal)
            button.setImage(filledStar, for: .selected)
            button.setImage(hilitedStar, for: .highlighted)
            button.setImage(hilitedStar, for: [.highlighted, .selected])
            
        //Констрейнты
        // Откючить автоконстрейнты (внутри стекВью не работает по умолчанию? в остальных местах нужно выключать вручную)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        //Высота и ширина кнопки
        button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
        button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
        button.addTarget(self, action: #selector(ratingButtonTapped(button:)), for: .touchUpInside)
        
        //Добавить объект на вью
        addArrangedSubview(button)
        //добавить кнопку в массив кнопок
        ratingButtons.append(button)
            
        }
        updateButtonSelectionState()
    }
    
    private func updateButtonSelectionState(){
        for (index, button) in ratingButtons.enumerated(){
            button.isSelected = index < rating
        }
    }
}
