//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Fiza Rasool on 17/05/19.
//  Copyright © 2019 Fiza Rasool. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework


class CategoryViewController: SwipeTableViewController{
    
    var textField = UITextField()
    let realm = try! Realm()
    
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var categoryArray : Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategory()
        
        
    }

    
    //MARK: TableView DataSource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let categorySelected = categoryArray?[indexPath.row] {
        
            cell.textLabel?.text = categorySelected.name ?? "No Categories Added Yet"
            
            guard let categoryColor = UIColor(hexString: categorySelected.catColor) else {fatalError()}
            
            cell.backgroundColor =  categoryColor
            
            cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
        }
        
        return cell
        
    }       
    //MARK : TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        let destinationVC = segue.destination as! ToDoListViewController

        if let indexPath = tableView.indexPathForSelectedRow {

            destinationVC.selectedCategory = categoryArray?[indexPath.row]

            
        }
    }
    
    
    //Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        
        
        let alert = UIAlertController(title: "Add A New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add category", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = self.textField.text!
            newCategory.catColor = UIColor.randomFlat.hexValue()
//            self.categoryArray.append(newCategory)
            
            self.save(category : newCategory)
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add a new category"
            self.textField = alertTextField
            
//            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tableViewTapped))
//
//            self.tableView.addGestureRecognizer(tapGesture)

            
        
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (cancelAction) in
            print("This is cancel action")
        }
        
        alert.addAction(action)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
        
        
        
    }
    
//    @objc func tableViewTapped() {
//
//        textField.endEditing(true)
//
//    }
//
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        print("Get rid of alert!")
//        guard let window :UIWindow = UIApplication.shared.keyWindow , var topVC = window.rootViewController?.presentedViewController else {return}
//        while topVC.presentedViewController != nil  {
//            topVC = topVC.presentedViewController!
//        }
//        if topVC.isKind(of: UIAlertController.self) {
//            topVC.dismiss(animated: false, completion: nil)
//        }
//    }

    
    //Data Manipulation methods
    
    func save(category : Category) {
        
        do {
            try realm.write {
                realm.add(category)
            }
        }
        catch {
            print("Error saving category \(error)")
        }
        tableView.reloadData()
        
    }
    
    func loadCategory() {

        categoryArray = realm.objects(Category.self)
        
//        let request : NSFetchRequest<Category> = Category.fetchRequest()
//        do {
//            categoryArray = try context.fetch(request)
//        }
//        catch {
//            print("Error loading context \(error)")
//        }
//        
//        tableView.reloadData()
//        
    }
    
    
    
    //MARK : - Delete data from swipe
    
    override func updateModel(at indexPath: IndexPath) {
        super.updateModel(at: indexPath)
        
        if let categoryForDeletion = self.categoryArray?[indexPath.row] {
                do {
                    try self.realm.write {
                        self.realm.delete(categoryForDeletion)
                    }
                } catch {
                    print("Error deleting category : \(error)")
                }
            }
    }
    
}



