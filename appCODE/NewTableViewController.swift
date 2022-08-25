//
//  NewTableViewController.swift
//  appCODE
//
//  Created by Danil Fishchenko on 08.08.2022.
//

import UIKit

class NewTableViewController: UITableViewController, UINavigationControllerDelegate {
    @IBOutlet weak var imageOfPlace: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
      
    }
    //при нажатии на нулевую ячейку выпадает алерт с выбором фото и картинки
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            let cameraIcon = #imageLiteral(resourceName: "camera")
            let photoIcon = #imageLiteral(resourceName: "photo")
            //создаем алерт
            let actionSheet = UIAlertController(title: "Choose your option",
                                                message: "Please, check what you need to add the photo",
                                                preferredStyle: .actionSheet)
            //первая кнопка алерта
            let camera = UIAlertAction(title: "Camera", style: .default) { _ in
                self.chooseImagePicker(sourse: .camera)
            }
            camera.setValue(cameraIcon, forKey: "image")
            camera.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            //вторая кнопка алерта
            let photo = UIAlertAction(title: "Photo", style: .default) { [self] _ in
                self.chooseImagePicker(sourse: .photoLibrary)
            }
            photo.setValue(photoIcon, forKey: "image")
            //треться кнопка алерта
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            photo.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            
            //добавляем кнопки к алерту
            actionSheet.addAction(camera)
            actionSheet.addAction(photo)
            actionSheet.addAction(cancel)
            //показываем алерт
            present(actionSheet, animated: true)
        } else{
            view.endEditing(true)
        }
    }



}
extension NewTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
         
    }
}
extension NewTableViewController : UIImagePickerControllerDelegate {
    func chooseImagePicker(sourse: UIImagePickerController.SourceType){
        if UIImagePickerController.isSourceTypeAvailable(sourse){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate  = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = sourse
            present(imagePicker, animated: true, completion: nil)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageOfPlace.image = info[.editedImage] as? UIImage
        imageOfPlace.contentMode = .scaleAspectFill
        imageOfPlace.clipsToBounds = true
        dismiss(animated: true)
    }

}

