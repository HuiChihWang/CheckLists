//
//  CheckList.swift
//  CheckLists
//
//  Created by Hui Chih Wang on 2021/4/6.
//

import Foundation

class CheckList {
    let name: String
    
    var list = [Item]()
    
    var itemNum: Int {
        list.count
    }
    
    private var dataPath: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        return paths[0].appendingPathComponent("checkLists.plist")
    }
    
    init(name: String) {
        self.name = name
//        loadCheckLists()
    }
    
    public func get(by index: Int) -> Item? {
        return (0..<list.count).contains(index) ? list[index] : nil
    }
    
    public func getIndex(with itemTarget: Item) -> Int? {
        return list.firstIndex { item in
            item.id == itemTarget.id
        }
    }
    
    public func toggleItem(by index: Int) {
        if (0..<list.count).contains(index) {
            list[index].toggle()
//            saveCheckLists()
        }
    }
    
    public func addNewItem(_ item: Item) {
        list.append(item)
//        saveCheckLists()
    }
    
    public func updateItem(_ item: Item) {
        if let index = getIndex(with: item) {
            list[index].label = item.label
        }
    }
    
    public func deleteItems(at index: Int) {
        if (0..<list.count).contains(index) {
            list.remove(at: index)
//            saveCheckLists()
        }
    }
    
}

extension CheckList {
    func saveCheckLists() {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(list)
            try data.write(to: dataPath, options: .atomic)
        } catch  {
            print("Error encoding item array: \(error.localizedDescription)")
        }
    }
    
    func loadCheckLists() {
        if let data = try? Data(contentsOf: dataPath) {
            let decoder = PropertyListDecoder()
            
            do {
                list = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error decoding item array: \(error.localizedDescription)")
            }
        }
    }
}

struct Item: Codable, Identifiable {
    var label: String
    var isDone: Bool
    var id = UUID()
    
    init(label: String, isDone: Bool = false) {
        self.label = label
        self.isDone = isDone
    }
    
    mutating func toggle() {
        isDone.toggle()
    }
}
