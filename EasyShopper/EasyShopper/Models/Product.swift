//
//  Product.swift
//  EasyShopper
//
//  Created by Cem Lapovski on 2020-06-30.
//

import Alamofire

struct Product {

    var id: String
    var name: String
    var barcode: String
    var description: String
    var image_url: String
    var retail_price: Int
    var cost_price: Int?
    
    init?(value: [String:Any]) {
        guard   let id = value["id"] as? String,
                let name = value["name"] as? String,
                let barcode = value["barcode"] as? String,
                let description = value["description"] as? String,
                let image_url = value["image_url"] as? String,
                let retail_price = value["retail_price"] as? Int
            else { return nil }
        
        if let cost_price = value["cost_price"] as? Int {
            self.cost_price = cost_price
        }
            
        self.id = id
        self.name = name
        self.barcode = barcode
        self.description = description
        self.image_url = image_url
        self.retail_price = retail_price
        
    }
}
