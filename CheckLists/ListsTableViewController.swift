//
//  ListsTableViewController.swift
//  CheckLists
//
//  Created by Hui Chih Wang on 2021/4/6.
//

import UIKit

class ListsTableViewController: UITableViewController {
    private let items = CheckList()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
//        navigationController?.navigationBar.prefersLargeTitles = true;
        

    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if let addItemController = segue.destination as? ItemDetailViewController {
            addItemController.delegate = self
            
            if (segue.identifier == "EditItem") {
                if let chosenCell = sender as? UITableViewCell, let chosenPath = tableView.indexPath(for: chosenCell) {
                    addItemController.itemToEdit = items.get(by: chosenPath.row)
                }
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
        return items.itemNum
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LIST_ITEM", for: indexPath)

        // Configure the cell...
        if let item = items.get(by: indexPath.row) {
//            cell.textLabel?.text = item.label
            configureCell(in: cell, with: item)
        }
        
        return cell
    }
    
    // table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) {
            items.toggleItem(by: indexPath.row)
            
            if let item = items.get(by: indexPath.row) {
                configureCell(in: cell, with: item)
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func configureCell(in cell: UITableViewCell, with item: Item) {
        if let checkMarkLabel = cell.viewWithTag(1001) as? UILabel {
            checkMarkLabel.text = item.isDone ? "✓" : ""
        }
        
        if let nameLabel = cell.viewWithTag(1000) as? UILabel {
            nameLabel.text = item.label
        }
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            items.deleteItems(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            print("insert new item")
        }
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
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

extension ListsTableViewController: ItemDetailViewDelegate {
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: Item) {
        insertItemIntoTable(item: item)
        navigationController?.popViewController(animated: true)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditting item: Item) {
        editItemInTable(item: item)
        navigationController?.popViewController(animated: true)
    }
    
    private func insertItemIntoTable(item: Item) {
        items.addNewItem(item)
        tableView.insertRows(at: [IndexPath(row: items.itemNum - 1, section: 0)], with: .automatic)
    }
    
    private func editItemInTable(item: Item) {
        items.updateItem(item)
        
        if let index = items.getIndex(with: item), let cellFound = tableView.cellForRow(at: IndexPath(row: index, section: 0)) {
            configureCell(in: cellFound, with: item)
        }
    }
}
