//
//  Product.swift
//  TheFashionist
//
//  Created by Ozgur Hayat on 04/11/2020.
//

import Foundation
import FirebaseFirestore

struct Product {
    var name: String
    var id: String
    var category: String
    var price: Double
    var productDescription: String
    var imageUrl: String
    var timeStamp: Timestamp
    var stock: Int
    
    init(
        name: String,
        id: String,
        category: String,
        price: Double,
        productDescription: String,
        imageUrl: String,
        timeStamp: Timestamp = Timestamp(),
        stock: Int = 0
        ) {
        self.name = name
        self.id = id
        self.category = category
        self.price = price
        self.productDescription = productDescription
        self.imageUrl = imageUrl
        self.timeStamp = timeStamp
        self.stock = stock
    }
    
    init(data: [String: Any]) {
        name = data["name"] as? String ?? ""
        id = data["id"] as? String ?? ""
        category = data["category"] as? String ?? ""
        price = data["price"] as? Double ?? 0.0
        productDescription = data["productDescription"] as? String ?? ""
        imageUrl = data["imageUrl"] as? String ?? ""
        timeStamp = data["timeStamp"] as? Timestamp ?? Timestamp()
        stock = data["stock"] as? Int ?? 0
    }
    
    static func modelToData(product: Product) -> [String: Any] {
        
        let data : [String: Any] = [
            "name" : product.name,
            "id" : product.id,
            "category" : product.category,
            "price" : product.price,
            "productDescription" : product.productDescription,
            "imageUrl" : product.imageUrl,
            "timeStamp" : product.timeStamp,
            "stock" : product.stock
        ]
        
        return data
    }
}

extension Product : Equatable {
    static func ==(lhs: Product, rhs: Product) -> Bool {
        return lhs.id == rhs.id
    }
}
