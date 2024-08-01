//
//  QuoteLoadViewController.swift
//  Joke
//
//  Created by Anastasiya on 29.07.2024.
//

import UIKit
//import RealmSwift

class QuoteLoadViewController: UIViewController {
    
    var refreshAllQuote: ()-> Void = {}
    
    var refreshGroupQuote: ()-> Void = {}
    
    private lazy var quoteLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 10
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var loadQuoteButton: CustomButton = {
        let button = CustomButton(title: "Загрузить цитату", titleColor: .systemBlue){
            self.getQuote()
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addSubviews()
        setupConstraints()
        
    }
    
    func setupView(){
        view.backgroundColor = .systemBackground
        title = "Рандомная цитата"
    }
    
    func addSubviews(){
        view.addSubview(quoteLabel)
        view.addSubview(loadQuoteButton)
    }
    
    func setupConstraints(){
        let safeAreaLayoutGuide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            quoteLabel.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor, constant: -32),
            quoteLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            quoteLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            loadQuoteButton.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            loadQuoteButton.topAnchor.constraint(equalTo: quoteLabel.bottomAnchor, constant: 32),
        ])
    }
    
    func getQuote(){
        NetworkManager.getQuote(){ result in
            switch result{
            case .success(let item):
                QuoteManager.addQuote(quote: item)
                DispatchQueue.main.async{ [weak self] in
                    self?.quoteLabel.text = item.value
                    print(item.categories)
//                    self?.refreshAllQuote()
//                    self?.refreshGroupQuote()
                }
            case .failure(let error):
                print(error)
                break
            }
        }
    }


}
