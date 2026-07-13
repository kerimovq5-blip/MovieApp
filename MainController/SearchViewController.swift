//
//  SearchViewController.swift
//  MovieApp
//
//  Created by Kerimov Qehreman on 27.06.26.
//

import UIKit

final class SearchViewController: UIViewController {
    
    private lazy var searchTextField: UITextField = {
        let textfield = UITextField()
        textfield.layer.cornerRadius = 12
        textfield.layer.masksToBounds = true
        textfield.backgroundColor = .searchBackground
        textfield.textColor = .black
        textfield.tintColor = .searchcolor
        textfield.attributedPlaceholder = NSAttributedString(
            string: "Search",
            attributes: [.foregroundColor: AssetColors.searchcolor.color]
        )

        let leftPadding = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 1))
        textfield.leftView = leftPadding
        textfield.leftViewMode = .always

        let iconView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        iconView.tintColor = .searchcolor
        iconView.contentMode = .scaleAspectFit
        iconView.frame = CGRect(x: 8, y: 10, width: 20, height: 20)

        let rightContainer = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        rightContainer.addSubview(iconView)
        textfield.rightView = rightContainer
        textfield.rightViewMode = .always

        return textfield
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
       // tableView.register(SearchCell.self, forCellReuseIdentifier: SearchCell.identifier)
        return tableView
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setConstraints()
        setupNavigationBar()
    }
    private func setupNavigationBar() {
        title = "Search"
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        
    }

    
    private func setUp(){
        view.backgroundColor = .mainBackground
        
        view.addSubviews(searchTextField)
    }
    private func setConstraints(){
        searchTextField
            .top(view.safeAreaLayoutGuide.topAnchor , 20 ).0
            .leading(view.leadingAnchor, 20).0
            .trailing(view.trailingAnchor, -20).0
            .height(50)
        
    }
}

