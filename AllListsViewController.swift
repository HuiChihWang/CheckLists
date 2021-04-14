//
//  ListsViewController.swift
//  CheckLists
//
//  Created by Hui Chih Wang on 2021/4/12.
//

import UIKit

class AllListsViewController: UITableViewController {

    static let cellIdentifier = "LIST_INFO"
    static let showCheckListIdentifier = "ShowChecklist"
    static let addCheckListIdentifier = "addList"
    static let editCheckListIdentifier = "editList"
    static let cachePageKey = "OriginalList"
    
    let checkLists = CheckLists()
    var cacheListIndex: Int {
        set {
            UserDefaults.standard.setValue(newValue, forKey: AllListsViewController.cachePageKey)
        }
        
        get {
            UserDefaults.standard.integer(forKey: AllListsViewController.cachePageKey)
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        // register cell
        
        // load previous selected list
        if (cacheListIndex != -1 && cacheListIndex < checkLists.listNum) {
            performSegue(withIdentifier: AllListsViewController.showCheckListIdentifier, sender: checkLists.getList(by: cacheListIndex))
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // reload table
        tableView.reloadData()
        // no any seleted list
        cacheListIndex = -1
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if (segue.identifier == AllListsViewController.showCheckListIdentifier) {
            if let controller = segue.destination as? ListViewController, let sender = sender as? CheckList {
                controller.currentList = sender
            }
        }
        
        if (segue.identifier == AllListsViewController.addCheckListIdentifier) {
            if let controller = segue.destination as? ListDetailViewController {
                controller.delegate = self
            }
        }
        
        if (segue.identifier == AllListsViewController.editCheckListIdentifier) {
            if let controller = segue.destination as? ListDetailViewController, let selectedList = sender as? CheckList {
                controller.editList = selectedList
                controller.delegate = self
            }
        }
        
        
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return checkLists.listNum
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        
        cell = tableView.dequeueReusableCell(withIdentifier: AllListsViewController.cellIdentifier)
                
        if (cell == nil) {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: AllListsViewController.cellIdentifier)
        }
        
        // Configure the cell...
        if let list = checkLists.getList(by: indexPath.row) {
            cell?.accessoryType = .detailDisclosureButton
            cell?.textLabel?.text = list.name
            
            let remainingLabel: String!
            if (list.itemNum == 0) {
                remainingLabel = "(no item)"
            }
            else {
                if (list.remainingItemNum == 0) {
                    remainingLabel = "All Done"
                }
                else {
                    remainingLabel = "\(list.remainingItemNum) Remaining"
                }
            }
            cell?.detailTextLabel?.text = remainingLabel
        }

        return cell ?? UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        if let selectedList = checkLists.getList(by: indexPath.row) {
            performSegue(withIdentifier: AllListsViewController.editCheckListIdentifier, sender: selectedList)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectItem = checkLists.getList(by: indexPath.row)
        cacheListIndex = indexPath.row
        performSegue(withIdentifier: AllListsViewController.showCheckListIdentifier, sender: selectItem)
    }
    
    private func insertRowInTable(cellForRowAt indexPath: IndexPath) {
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    

    /*
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
}

extension AllListsViewController: ListDetailViewDelegate {
    func listDetailView(_ listDetailView: ListDetailViewController, didFinishAdding listName: String) {
        checkLists.createNewList(name: listName)
        insertRowInTable(cellForRowAt: IndexPath(row: checkLists.listNum - 1, section: 0))
        navigationController?.popViewController(animated: true)
    }
    
    func listDetailView(_ listDetailView: ListDetailViewController, didFinishEditing checkList: CheckList) {
        if let index = checkLists.getListIndex(for: checkList), let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) {
            cell.textLabel?.text = checkList.name
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    func listDetailViewDidCancel(_ listDetailView: ListDetailViewController) {
        navigationController?.popViewController(animated: true)

    }
}
