//
//  checkLists.swift
//  CheckLists
//
//  Created by Hui Chih Wang on 2021/4/12.
//

import Foundation

class CheckLists {
    public var listNum: Int {
        lists.count
    }
    
    private var lists = [CheckList]()
    
    init() {
        let list1 = CheckList(name: "Today")
        list1.addNewItem(Item(label: "sex"))
        list1.addNewItem(Item(label: "fitness factory"))
        list1.addNewItem(Item(label: "leetcode"))
        
        let list2 = CheckList(name: "Tomorrow")
        list2.addNewItem(Item(label: "Swim"))
        list2.addNewItem(Item(label: "ios learn"))
        list2.addNewItem(Item(label: "support customer"))
        
        lists = [
        list1, list2,
        ]
    }
    
    public func createNewList(name: String) {
        lists.append(CheckList(name: name))
    }
    
    public func removeList(by index: Int) {
        if (0..<lists.count).contains(index) {
            lists.remove(at: index)
        }
    }
    
    public func getListIndex(for list: CheckList) -> Int? {
        return lists.firstIndex(of: list)
    }
    
    public func getList(by index: Int) -> CheckList? {
        return (0..<lists.count).contains(index) ? lists[index] : nil
    }
}
