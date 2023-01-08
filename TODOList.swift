//
//  TODOItem.swift
//  Pomodoro Timer
//
//  Created by Galen Han on 8/9/22.
//

import SwiftUI

class TODOList: ObservableObject {
    
    static var TODOs: [String] = ["Work on app", "Read book",]
    
    static func createTODOList() -> ItemList<String> {
        ItemList<String>(numberOfItems: TODOs.count) { index in
            TODOs[index]
        }
    }
    
    @Published private var model: ItemList<String> =
    createTODOList()
    
    var items: Array<ItemList<String>.TODOItem> {
        return model.items
    }
    
    func mark(_ item: ItemList<String>.TODOItem) {
        model.mark(item)
    }
    
    func add(_ content: String) {
        model.add(content)
    }
}
