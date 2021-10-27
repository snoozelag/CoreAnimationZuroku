//
//  GradientViewController.swift
//  CoreAnimationZuroku
//
//  Created by teruto.yamasaki on 2021/10/17.
//

import UIKit

class GradientViewController: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()

        title = "CAGradientLayer"
        view.backgroundColor = .white

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        // horizontal
//        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
//        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.colors = [UIColor.red.cgColor,
                                UIColor.orange.cgColor,
                                UIColor.yellow.cgColor,
                                UIColor.green.cgColor,
                                UIColor.blue.cgColor,
                                UIColor.purple.cgColor]

        view.layer.addSublayer(gradientLayer)
    }
}
