//
//  LoadingView.swift
//  MovieApp
//
//  Created by Kerimov Qehreman on 29.06.26.
//
import UIKit

final class LoadingView: UIView {
    private let activityIndicator: UIActivityIndicatorView = {
        
        let view = UIActivityIndicatorView(style: .large)
        view.color = .systemGray
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        addSubview(activityIndicator)
        activityIndicator
            .centerY(centerYAnchor).0
            .centerX(centerXAnchor).0
            .width(50).0
            .height(50)
            
    }
    
    func startAnimating() {
        activityIndicator.startAnimating()
    }
    func stopAnimating() {
        activityIndicator.stopAnimating()
    }
}
