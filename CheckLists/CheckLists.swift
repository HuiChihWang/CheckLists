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
//        let list1 = CheckList(name: "Today")
//        list1.addNewItem(Item(label: "sex"))
//        list1.addNewItem(Item(label: "fitness factory"))
//        list1.addNewItem(Item(label: "leetcode"))
//
//        let list2 = CheckList(name: "Tomorrow")
//        list2.addNewItem(Item(label: "Swim"))
//        list2.addNewItem(Item(label: "ios learn"))
//        list2.addNewItem(Item(label: "support customer"))
//
//        lists = [
//        list1, list2,
//        ]
        
        loadCheckLists()
    }
    
    public func addNewList(list: CheckList) {
        lists.append(list)
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
    
    public func sortLists() {
        lists.sort { list1, list2 in
            return list1.name.localizedCompare(list2.name) == .orderedAscending
        }
    }
}

extension CheckLists {
    
    private func dataPath() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        return paths[0].appendingPathComponent("checkLists.plist")
    }
    
    func saveCheckLists() {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(lists)
            try data.write(to: dataPath(), options: .atomic)
            print("Save Current Data to \(dataPath())")
        } catch  {
            print("Error encoding item array: \(error.localizedDescription)")
        }

    }
    
    func loadCheckLists() {
        if let data = try? Data(contentsOf: dataPath()) {
            let decoder = PropertyListDecoder()
            
            do {
                lists = try decoder.decode([CheckList].self, from: data)
                sortLists()
                print("Load Current Data from \(dataPath())")
            } catch {
                print("Error decoding list array: \(error.localizedDescription)")
            }
        }
    }
}
