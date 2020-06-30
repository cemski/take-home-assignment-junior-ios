//
//  Checkout.swift
//  EasyShopper
//
//  Created by Cem Lapovski on 2020-06-30.
//

import UIKit

class CheckoutViewController: UIViewController {
    
    private var titleLabel: UILabel!
    private var subtitleLabel: UILabel!
    private var cartContentsLabel: UILabel!
    private var backButton: UIButton!
    private var descriptionLabel: UILabel!
    private var collectionView: UICollectionView!
    private var basket: ShoppingBasket = ShoppingBasket() {
        didSet {
            guard cartContentsLabel != nil, subtitleLabel != nil else { return }
            cartContentsLabel.text = basket.items.isEmpty ? "0 DKK" : "\(basket.total) DKK"
            subtitleLabel.text = basket.items.isEmpty ? "Your Cart is Empty" : ""
            products = basket.items
        }
    }
    
    
    private var products: [Product] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupCollectionView()
        self.setupLabels()
        self.setupConstraints()
        products = basket.items
        
        
        view.backgroundColor = .white
    }
    
    fileprivate func setupLabels(){
        titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black
        titleLabel.text = "Shopping Basket"
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(titleLabel)
        
        subtitleLabel = UILabel()
        subtitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        subtitleLabel.textAlignment = .center
        subtitleLabel.textColor = .black
        subtitleLabel.text = basket.items.isEmpty ? "Your Cart is Empty" : ""
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(subtitleLabel)
        
        
        backButton = UIButton()
        let backSymbol = UIImage(systemName: "arrow.left")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        backButton.setImage(backSymbol, for: .normal)
        backButton.addTarget(self, action: #selector(showWebshop), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(backButton)
        
        cartContentsLabel = UILabel()
        cartContentsLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        cartContentsLabel.textAlignment = .center
        cartContentsLabel.textColor = .black
        cartContentsLabel.text = basket.items.isEmpty ? "0 DKK" : "\(basket.total) DKK"
        cartContentsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(cartContentsLabel)
        
        
    }
    
    @objc func showWebshop() {
        let vc = WebshopViewController()
        vc.basketDelegate = self
        vc.basket = basket
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
        
    }
    
    fileprivate func setupConstraints(){
        NSLayoutConstraint.activate([
                titleLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
                titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
                titleLabel.heightAnchor.constraint(equalToConstant: 20),
                
                backButton.topAnchor.constraint(equalTo: titleLabel.topAnchor),
                backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 45),
                backButton.heightAnchor.constraint(equalToConstant: 20),
                
                cartContentsLabel.topAnchor.constraint(equalTo: titleLabel.topAnchor),
                cartContentsLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -45),
                cartContentsLabel.heightAnchor.constraint(equalToConstant: 20),
                
                subtitleLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
                subtitleLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
                
                collectionView.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 20),
                collectionView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
                collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            ])
    }
}

extension CheckoutViewController {
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

extension CheckoutViewController: UICollectionViewDelegate {
    
}

extension CheckoutViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductCell
        cell.configureCell(product: products[indexPath.item], isCheckout: true)
            
        return cell
    }
}


extension CheckoutViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width-30, height: 105)
    }
}

extension CheckoutViewController: ShoppingBasketDelegate {
    func saveBasket(products: [Product], total: Int) {
        self.basket.items = products
        self.basket.total = total
    }
}
