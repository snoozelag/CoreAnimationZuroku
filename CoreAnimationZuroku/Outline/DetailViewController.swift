//
//  DetailViewController.swift
//  CoreAnimationZuroku
//
//  Created by teruto.yamasaki on 2021/10/17.
//

import UIKit

class DetailViewController: UIViewController {

    private let descriptionLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        descriptionLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        descriptionLabel.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        descriptionLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true

        descriptionLabel.text = "CoreAnimationZuroku"
        descriptionLabel.textAlignment = .center
    }
}

