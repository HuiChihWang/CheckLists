//
//  CheckList.swift
//  CheckLists
//
//  Created by Hui Chih Wang on 2021/4/6.
//

import Foundation

class CheckList {
    var list: [Item]
    
    var itemNum: Int {
        list.count
    }
    
    init() {
        list = [
            Item(label: "Sex"),
            Item(label: "Excersise"),
            Item(label: "Write Leetcode"),
            Item(label: "Gathering"),
            Item(label: "KOR Drinking"),
        ]
    }
    
    public func get(by index: Int) -> Item? {
        return (0..<list.count).contains(index) ? list[index] : nil
    }
    
    public func getIndex(with itemTarget: Item) -> Int? {
        return list.firstIndex { item in
            item === itemTarget
        }
    }

    
    public func toggleItem(by index: Int) {
        if (0..<list.count).contains(index) {
            list[index].toggle()
        }
    }
    
    public func addNewItem(_ item: Item) {
        list.append(item)
    }
    
    public func deleteItems(at index: Int) {
        if (0..<list.count).contains(index) {
            list.remove(at: index)
        }
    }
    
}

class Item {
    var label: String
    var isDone: Bool
    
    init(label: String, isDone: Bool = false) {
        self.label = label
        self.isDone = isDone
    }
    
    func toggle() {
        isDone.toggle()
    }
    
}
