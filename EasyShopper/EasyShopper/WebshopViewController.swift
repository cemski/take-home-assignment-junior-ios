//
//  Webshop.swift
//  EasyShopper
//
//  Created by Cem Lapovski on 2020-06-30.
//

import UIKit

class WebshopViewController: UIViewController {
    
    var basketDelegate: ShoppingBasketDelegate?
    private var delegate: ProductCellDelegate?
    
    private var titleLabel: UILabel!
    private var subtitleLabel: UILabel!
    private var cartTotal: UILabel!
    private var cartButton: UIButton!
    private var descriptionLabel: UILabel!
    private var collectionView: UICollectionView!
    var basket: ShoppingBasket = ShoppingBasket() {
        didSet {
            guard cartTotal != nil else { return }
            cartTotal.text = "\(basket.total) DKK"
        }
    }
    private var products: [Product] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkManager().fetchOnlineStock { result in
            switch result {
            case .success(let products):
                self.products = products
            case .failure(let error):
                print(error)
            }
        }
        self.setupLabels()
        self.setupCollectionView()
        self.setupConstraints()
        delegate = self
        view.backgroundColor = .white
    }
    
    fileprivate func setupLabels(){
        titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black
        titleLabel.text = "Webshop"
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(titleLabel)
        
        cartButton = UIButton()
        let cartSymbol = UIImage(systemName: "cart.fill")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        cartButton.setImage(cartSymbol, for: .normal)
        cartButton.addTarget(self, action: #selector(showCheckout), for: .touchUpInside)
        cartButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(cartButton)
        
        cartTotal = UILabel()
        cartTotal.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        cartTotal.textAlignment = .center
        cartTotal.textColor = .black
        cartTotal.text = basket.items.isEmpty ? "0 DKK" : "\(basket.total) DKK"
        cartTotal.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(cartTotal)
    }
    
    fileprivate func setupConstraints(){
        NSLayoutConstraint.activate([
                titleLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
                titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
                titleLabel.heightAnchor.constraint(equalToConstant: 20),
                
                cartButton.topAnchor.constraint(equalTo: titleLabel.topAnchor),
                cartButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -25),
                cartButton.heightAnchor.constraint(equalToConstant: 20),
                
                cartTotal.topAnchor.constraint(equalTo: titleLabel.topAnchor),
                cartTotal.trailingAnchor.constraint(equalTo: cartButton.leadingAnchor, constant: -10),
                cartTotal.heightAnchor.constraint(equalToConstant: 20),
                
                collectionView.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 20),
                collectionView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
                collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            ])
    }
}

extension WebshopViewController {
    @objc func showCheckout(){
    
        basketDelegate?.saveBasket(products: basket.items, total: basket.total)
        dismiss(animated: true, completion: nil)
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.allowsMultipleSelection = true
        collectionView.isScrollEnabled = true
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        collectionView.register(ProductCell.self, forCellWithReuseIdentifier: "ProductCell")
    }
}

extension WebshopViewController: UICollectionViewDelegate {
    
}

extension WebshopViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductCell
        cell.delegate = self
        cell.configureCell(product: products[indexPath.item], isCheckout: false)
        return cell
    }
}


extension WebshopViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width-30, height: 130)
    }
}

extension WebshopViewController: ProductCellDelegate {
    func didRemove(product: Product) {
        if let index = basket.items.firstIndex(where: { $0.id  == product.id }) {
            basket.items.remove(at: index)
            basket.total -= product.retail_price
        }
    }
    
    func didAdd(product: Product) {
        basket.items.append(product)
        basket.total += product.retail_price
    }
}
