//
//  ProductCell.swift
//  EasyShopper
//
//  Created by Cem Lapovski on 2020-06-30.
//

import UIKit
import Kingfisher

protocol ProductCellDelegate {
    func didAdd(product: Product)
    func didRemove(product: Product)
}

class ProductCell: UICollectionViewCell {
    
    var delegate: ProductCellDelegate?
    
    var titleLabel: UILabel!
    var subtitleLabel: UILabel!
    var productImageView: UIImageView!
    var plusButton: UIButton!
    var minusButton: UIButton!
    var product: Product!
    
   override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.masksToBounds = true
        self.setupViews()
        self.setupConstraints()

    }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    func configureCell(product: Product, isCheckout: Bool) {
        self.product = product
        titleLabel.text = product.name
        subtitleLabel.text = "\(product.retail_price) DKK"
        productImageView.kf.setImage(with: URL(string: product.image_url))
        plusButton.isHidden = isCheckout
        minusButton.isHidden = isCheckout
    }
}

extension ProductCell {
    
    @objc func didAdd(){
        delegate?.didAdd(product: product)
    }
    
    @objc func didRemove(){
        delegate?.didRemove(product: product)
    }
    
    private func setupViews() {
        
        titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(titleLabel)
        
        subtitleLabel = UILabel()
        subtitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        subtitleLabel.textAlignment = .right
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(subtitleLabel)
        
        productImageView = UIImageView()
        productImageView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(productImageView)
        
        productImageView = UIImageView()
        productImageView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(productImageView)
        
        plusButton = UIButton(type: .system)
        let plusSymbol = UIImage(systemName: "plus.circle")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        plusButton.setImage(plusSymbol, for: .normal)
        plusButton.addTarget(self, action: #selector(didAdd), for: .touchUpInside)
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(plusButton)
        
        minusButton = UIButton(type: .system)
        let minusSymbol = UIImage(systemName: "minus.circle")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        minusButton.setImage(minusSymbol, for: .normal)
        minusButton.addTarget(self, action: #selector(didRemove), for: .touchUpInside)
        minusButton.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(minusButton)
    }

    private func setupConstraints(){
        NSLayoutConstraint.activate([
            productImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            productImageView.widthAnchor.constraint(equalToConstant: 75),
            productImageView.heightAnchor.constraint(equalToConstant: 75),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant:  10),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            titleLabel.widthAnchor.constraint(equalToConstant: 200),
            
            subtitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            subtitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            plusButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -20),
            plusButton.trailingAnchor.constraint(equalTo: subtitleLabel.safeAreaLayoutGuide.leadingAnchor, constant: -30),
            plusButton.heightAnchor.constraint(equalToConstant: 20),
            
            minusButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 20),
            minusButton.trailingAnchor.constraint(equalTo: subtitleLabel.safeAreaLayoutGuide.leadingAnchor, constant: -30),
            minusButton.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}
