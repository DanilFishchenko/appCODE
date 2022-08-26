//
//  MainViewController.swift
//  appCODE
//
//  Created by Danil Fishchenko on 31.07.2022.
//

import UIKit
import RealmSwift
class MainViewController: UITableViewController {
    //создаем коллекцию элементов для заполнения результатами из базы данных
    var places: Results<Place>!

    override func viewDidLoad() {
        super.viewDidLoad()
        //Заполняем коллекцию из базы данных
        places = realm.objects(Place.self).sorted(byKeyPath: "name", ascending: true)
    }


    // MARK: - Table view data source


//    override func numberOfSections(in tableView: UITableView) -> Int {
//        places.count
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //количество ячеек=количеству записей из базы (если не 0)
        return places.isEmpty ? 0 : places.count
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //заполняем ячейки
        //создаем обычную ячейку, кастим её до нашего кастомного класса
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        
        //для ячейки присваиваем место из массива записей БД
        let place = places[indexPath.row]
        //раскидываем по полям
        cell.nameLabel.text = place.name
        cell.locationLabel.text = place.location
        cell.typeLabel.text = place.type
        cell.imageOfPlace.image = UIImage(data: place.imageData!)
        //скругляем картинку
        cell.imageOfPlace.layer.cornerRadius = cell.imageOfPlace.frame.size.height / 2
        cell.imageOfPlace.clipsToBounds = true
        //метод возвращает одну ячейку каждую итерацию по количеству ячеек из метода numberOfRowsInSection
        return cell
    }
    
    // MARK: Table view delegate
    //В этом методе
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let place = places[indexPath.row]
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete"){ (_, _) in
            StorageManager.deleteObject(place)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
        }
        return[deleteAction]
    }
    
  /*  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headerTitles[row]
    }
  
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    //при переходе по сигвею мы передаем объект из текущей ячейки через сегвей в новый вью контрллер
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //СИгвеев может быть много, поэтому мы проверяем его название, если это точто надо  то
        if segue.identifier == "showDetail"{
            //находим индекс нажатой ячейки
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            //берем из массива элемент по этому индексу
            let place = places[indexPath.row]
            
            //создаём абстрактный экземпляр класса, кастим(Через guard) до нужного NewTableViewController
            guard let newPlaceVC = segue.destination as? NewTableViewController else { return }
            //передаём объект в свойство экземпляра. Теперь он доступен в соседнем вьюконтроллере
            newPlaceVC.currentPlace = place
        }
    }

    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        //создаём абстрактный экземпляр класса, кастим до нужного NewTableViewController
        guard let newPlaceVC = segue.source as? NewTableViewController else { return }
        
        //вызываем сохранение данных при переходе от  NewPlaceVC на MainVC
        newPlaceVC.savePlace()
        tableView.reloadData()
    }
}
