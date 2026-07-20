//
//  ImageViewCollectionCell.swift
//  MovieApp
//
//  Created by Kerimov Qehreman on 29.06.26.
//

import UIKit

final class ImageViewCollectionCell: UICollectionViewCell {
    private lazy var imageViewCollection : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        return imageView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepareForReuse() {
            super.prepareForReuse()
            imageViewCollection.image = nil
            
        }
    private func configureView() {
        contentView.addSubviews(imageViewCollection )
        imageViewCollection
            .top(contentView.topAnchor).0
            .leading(contentView.leadingAnchor).0
            .trailing(contentView.trailingAnchor).0
            .bottom(contentView.bottomAnchor)
        
    }
    func configure(data : String?) {
        guard let data else { return }
        imageViewCollection.image = nil
       
        NetworkManager.shared.loadData(urlString: data, completion:{
            [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let data):
                DispatchQueue.main.async{
                    self.imageViewCollection.image = UIImage(data: data)
                    
                }
            case .failure(let error):
                print (error.localizedDescription)
                
            }
         } )
    }
}

