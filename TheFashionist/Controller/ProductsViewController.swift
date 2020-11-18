//
//  ProductsViewController.swift
//  TheFashionist
//
//  Created by Ozgur Hayat on 04/11/2020.
//

import UIKit
import FirebaseFirestore

class ProductsViewController: UIViewController, ProductCellDelegate {

    // Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // Variables
    var products = [Product]()
    var category: Category!
    var listener: ListenerRegistration! //Continue to receive updates on our data.
    var db : Firestore!
    var showFavorites = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        tableView.delegate = self
        tableView.dataSource = self
        // Register and Present Nib for Tableview
        tableView.register(UINib(nibName: Identifiers.ProductCell, bundle: nil), forCellReuseIdentifier: Identifiers.ProductCell)
        
        setupQuery()
    }
    
    func setupQuery() {
        
        var ref: Query!
        if showFavorites {
            ref = db.collection("users").document(UserService.user.id).collection("favorites")
        } else {
            ref = db.products(category: category.id)
        }
        
        listener = ref.addSnapshotListener({ (snap, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
            }
            
            snap?.documentChanges.forEach({ (change) in
                let data = change.document.data()
                let product = Product.init(data: data)
                
                switch change.type {
                case .added:
                    self.onDocumentAdded(change: change, product: product)
                case .modified:
                    self.onDocumentModified(change: change, product: product)
                case .removed:
                    self.onDocumentRemoved(change: change)
                }
            })
        })
    }
    
    func productFavorited(product: Product) {
        if UserService.isGuest {
            self.simpleAlert(title: "Hi friend!", msg: "This is a user only feature, please create a registered user to take advantage of all our features.")
            return
        }
        
        UserService.favoriteSelected(product: product)
        guard let index = products.firstIndex(of: product) else { return }
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    func productAddToCart(product: Product) {
        if UserService.isGuest {
            self.simpleAlert(title: "Hi friend!", msg: "This is a user only feature, please create a registered user to take advantage of all our features.")
            return
        }
        
        StripeCart.addItemToCart(item: product)
    }
}

extension ProductsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func onDocumentAdded(change: DocumentChange, product: Product) {
        let newIndex = Int(change.newIndex)
        products.insert(product, at: newIndex)
        tableView.insertRows(at: [IndexPath(row: newIndex, section: 0)], with: .fade)
    }
    
    func onDocumentModified(change: DocumentChange, product: Product) {
        if change.oldIndex == change.newIndex {
            // Item changed, but remained in the same position
            let index = Int(change.newIndex)
            products[index] = product
            tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
        } else {
            // Item changed and changed position
            let oldIndex = Int(change.oldIndex)
            let newIndex = Int(change.newIndex)
            products.remove(at: oldIndex)
            products.insert(product, at: newIndex)
            tableView.moveRow(at: IndexPath(row: oldIndex, section: 0), to: IndexPath(row: newIndex, section: 0))
        }
    }
    
    func onDocumentRemoved(change: DocumentChange) {
        let oldIndex = Int(change.oldIndex)
        products.remove(at: oldIndex)
        tableView.deleteRows(at: [IndexPath(row: oldIndex, section: 0)], with: .left)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.ProductCell, for: indexPath) as?  ProductCell {
            
            cell.configureCell(product: products[indexPath.row], delegate: self)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ProductDetailVC()
        let selectedProduct = products[indexPath.row]
        vc.product = selectedProduct
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}
