//
//  NewTableViewController.swift
//  appCODE
//
//  Created by Danil Fishchenko on 08.08.2022.
//

import UIKit

class NewTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

      
    }



}
extension NewTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
         
    }
}
