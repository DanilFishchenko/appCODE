//
//  NewTableViewController.swift
//  appCODE
//
//  Created by Danil Fishchenko on 08.08.2022.
//

import UIKit

class NewTableViewController: UITableViewController, UINavigationControllerDelegate {

    var imageIsChanged = false
    var editingPlace: Place?
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var placeImage: UIImageView!
    
    @IBOutlet weak var placeType: UITextField!
    @IBOutlet weak var placeName: UITextField!
    
    @IBOutlet weak var placeLocation: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: CGRect(x: 0,
                                                         y: 0,
                                                         width: tableView.frame.size.width,
                                                         height: 1))
        saveButton.isEnabled = false
        
        //наблюдатель изменения текстового поля. вызывает метод селектора при каждом изменении текстового поля
        placeName.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        setupEditScreen()
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
    //сохранение объекта в базу даннных (с проверкой наличия фото)
    
    func savePlace() {
        //проверка на наличие картинки после imagePickerController
        var image: UIImage?
        if imageIsChanged {
            image = placeImage.image //если изменилась, присваиваем фото из пикера
        } else {
            image = #imageLiteral(resourceName: "imagePlaceholder") // если не менялась, присваиваем из галереи
        }
        let imageData = image?.pngData()// переводим картинку в формат для БД
        
       //создаем экземпляр места, записываем в него поля текстовые
        let newPlace = Place(name: placeName.text!,
                             location: placeLocation.text,
                             type: placeType.text,
                             imageData: imageData)
        
        //если редактируем то обновляем данные в базе
        if editingPlace !== nil{
            try! realm.write{
                editingPlace?.name = newPlace.name
                editingPlace?.location = newPlace.location
                editingPlace?.type = newPlace.type
                editingPlace?.imageData = newPlace.imageData
            }
            //если место новое то добавляем данные в базу
        } else {
            StorageManager.saveObject(newPlace)
            }
            
        }
    
 //приватный метод настройки экрана детальных записей
    private func setupEditScreen() {
        //если редактируем, то выводи поля выбранной ячейки и картинку и вызываем настройку навигации
        if editingPlace !== nil{
            guard let data = editingPlace?.imageData, let image = UIImage(data: data) else { return }
            placeImage.image = image
            placeImage.contentMode = .scaleAspectFill
            placeName.text = editingPlace?.name
            placeType.text = editingPlace?.type
            placeLocation.text = editingPlace?.location
            imageIsChanged = true
            setupNavigationBar()
            
            
        }
    }
   //настраиваем навигацию вверху (кнопки и их отображение)
    private func setupNavigationBar(){
        navigationItem.leftBarButtonItem = nil
        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        title = editingPlace?.name
        saveButton.isEnabled = true
    }
    
//кнопка Cancel (Возврат без сохранения)
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true)
    }

}
// MARK: Text field delegate
extension NewTableViewController: UITextFieldDelegate {
    
    // Скрываем клавиатуру по нажатию на Done
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    
    // Метод для отслеживания изменения поля textField - вызывается при изменении в каждом символе
    @objc private func textFieldChanged() {
        
        if placeName.text?.isEmpty == false {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }

}
//создаем и показываем picker
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
    //настраиваем picker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        placeImage.image = info[.editedImage] as? UIImage
        placeImage.contentMode = .scaleAspectFill
        placeImage.clipsToBounds = true
        imageIsChanged = true
        dismiss(animated: true)
    }

}
