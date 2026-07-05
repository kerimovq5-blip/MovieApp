//
//  UIview_Extensions.swift
//  MovieApp
//
//  Created by Kerimov Qehreman on 29.06.26.
//

import UIKit

extension UIView {
    func showLoading() {
        subviews.forEach {
            if let loadingView = $0 as? LoadingView{
                loadingView.stopAnimating()
                loadingView.removeFromSuperview()
            }
        }
        let loadingView = LoadingView()
        addSubview(loadingView)
        loadingView
            .centerX(centerXAnchor).0
            .centerY(centerYAnchor).0
            .width(50).0
            .height(50)
        loadingView.startAnimating()
    }
    
    func hideLoading() {
        subviews.forEach {
            if let loadingView = $0 as? LoadingView{
                loadingView.stopAnimating()
                loadingView.removeFromSuperview()
            }
        } 
    }
}

