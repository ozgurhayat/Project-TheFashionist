//
//  CardItemCell.swift
//  TheFashionist
//
//  Created by Ozgur Hayat on 10/11/2020.
//

import UIKit

protocol CartItemDelegate : class {
    func removeItem(product: Product)
}

class CartItemCell: UITableViewCell {

    // Outlets
    @IBOutlet weak var productImg: RoundedImageView!
    @IBOutlet weak var productTitleLbl: UILabel!
    @IBOutlet weak var removeItemBtn: UIButton!
    
    // Variables
    private var item: Product!
    weak var delegate : CartItemDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(product: Product, delegate: CartItemDelegate) {
        self.delegate = delegate
        self.item = product
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        
        if let price = formatter.string(from: product.price as NSNumber) {
            productTitleLbl.text = "\(product.name) \(price)"
        }
        
        if let url = URL(string: product.imageUrl) {
            productImg.kf.setImage(with: url)
        }
    }

    
    @IBAction func removeItemClicked(_ sender: Any) {
        delegate?.removeItem(product: item)
    }
}
