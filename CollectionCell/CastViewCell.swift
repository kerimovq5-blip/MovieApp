//
//  CastViewCell.swift
//  MovieApp
//
//  Created by Kerimov Qehreman on 16.07.26.
//



import UIKit

final class CastViewCell: UICollectionViewCell {
    
    
     static let Identifier: String = "CastViewCell"
    
    private lazy var castImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 50
        return imageView
    }()
    
    private lazy var namelabel : UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    override func prepareForReuse() {
            super.prepareForReuse()
            castImageView.image = nil
            namelabel.text = nil
        }
    private func configureView() {
        contentView.addSubviews( castImageView , namelabel)
        
        castImageView
            .top(contentView.topAnchor).0
            .leading(contentView.leadingAnchor).0
            .trailing(contentView.trailingAnchor).0
            .height(100)
            
            
        
        namelabel
            .top(castImageView.bottomAnchor , 6).0
            .leading(contentView.leadingAnchor).0
            .trailing(contentView.trailingAnchor).0
            .bottom(contentView.bottomAnchor)
    }
    func configure(with member : CastDto) {
        castImageView.image = nil
        namelabel.text = member.name
        guard let url = member.profileUrl else { return }
        
        
        NetworkManager.shared.loadData(urlString:  url.absoluteString ){
            [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let data):
                DispatchQueue.main.async{
                    self.castImageView.image = UIImage(data: data)
                }
            case .failure(let error):
                print (error.localizedDescription)
                
            }
         }
    }
}
