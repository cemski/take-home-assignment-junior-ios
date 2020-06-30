//
//  ShoppingBasket.swift
//  EasyShopper
//
//  Created by Cem Lapovski on 2020-06-30.
//

import Foundation

protocol ShoppingBasketDelegate {
    func saveBasket(products: [Product], total: Int)
}

struct ShoppingBasket {
    var items: [Product]
    var total: Int

    
    init() {
        items = []
        total = 0
    }
}
