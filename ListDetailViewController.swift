//
//  ListDetailViewController.swift
//  CheckLists
//
//  Created by Hui Chih Wang on 2021/4/12.
//

import UIKit

protocol ListDetailViewDelegate {
    
    func listDetailView(_ listDetailView: ListDetailViewController, didFinishAdding checkList: CheckList)
    
    func listDetailView(_ listDetailView: ListDetailViewController, didFinishEditing checkList: CheckList)

    
    func listDetailViewDidCancel(_ listDetailView: ListDetailViewController)
}

class ListDetailViewController: UITableViewController {

    @IBOutlet weak var listNameInput: UITextField!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var iconName: UILabel!
    
    
    var delegate: ListDetailViewDelegate?
    var editList: CheckList?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//         self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        doneButton.isEnabled = false
        listNameInput.becomeFirstResponder()
        
        if let editList = editList {
            title = "Edit List"
            listNameInput.text = editList.name
            iconName.text = editList.catogory.rawValue
            iconImage.image = UIImage(systemName: editList.catogory.imageName)
        }
        else {
            title = "Add New List"
            let defaultCategory = ListCatogory.none
            iconName.text = defaultCategory.rawValue
            iconImage.image = UIImage(systemName: defaultCategory.imageName)
        }

    }
    
    
    @IBAction func cancel(_ sender: Any) {
        delegate?.listDetailViewDidCancel(self)
    }
    
    
    
    @IBAction func done(_ sender: Any) {
        if let editList = editList {
            editList.name = listNameInput.text!
            
            if let catogory = ListCatogory(rawValue: iconName.text!) {
                editList.catogory = catogory
            }
            
            delegate?.listDetailView(self, didFinishEditing: editList)
        }
        else {
            let newList = CheckList(name: listNameInput.text!)
            
            if let catogory = ListCatogory(rawValue: iconName.text!) {
                newList.catogory = catogory
            }
            
            delegate?.listDetailView(self, didFinishAdding: newList)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ListDetailViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // get current text
        let oldText = listNameInput.text!
        let stringRange = Range(range, in:oldText)!
        let newText = oldText.replacingCharacters(
          in: stringRange,
          with: string)

        // enable/disable done button
        doneButton.isEnabled = !newText.isEmpty
        
        return true
    }
}
