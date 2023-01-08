//
//  TODOItem.swift
//  Pomodoro Timer
//
//  Created by Galen Han on 8/9/22.
//

import Foundation

struct ItemList<ItemContent> {
    private(set) var items: Array<TODOItem>
    private(set) var counter = 0
    
    mutating func mark(_ item: TODOItem) {
        //let chosenIndex = index(of: item)
        let chosenIndex = items.firstIndex(where: { $0.id == item.id })
        items.remove(at: chosenIndex!)
    }
    
    mutating func add(_ content: ItemContent) {
        items.append(TODOItem(content: content, id: counter))
        counter += 1
    }
    
//    func index(of item: TODOItem) -> Int {
//        for index in 0..<items.count {
//            if items[index].id == item.id {
//                return index
//            }
//        }
//        return -1
//    }
    
    
    init(numberOfItems: Int, createItemContent: (Int) ->
         ItemContent) {
        items = Array<TODOItem>()
        for index in 0..<numberOfItems {
            let content = createItemContent(index)
            items.append(TODOItem(content: content, id:counter))
            counter += 1
        }
    }
    
    
    
    
    
    
    
    struct TODOItem: Identifiable {
        var content: ItemContent
        var id: Int
        
    }

}



