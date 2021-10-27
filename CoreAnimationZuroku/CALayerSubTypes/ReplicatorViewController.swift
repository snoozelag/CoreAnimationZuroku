//
//  ReplicatorViewController.swift
//  CoreAnimationZuroku
//
//  Created by teruto.yamasaki on 2021/10/17.
//

import UIKit

class ReplicatorViewController: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()

        title = "CAReplicatorLayer"
        view.backgroundColor = .white

        let replicatorLayer = CAReplicatorLayer()
        replicatorLayer.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        replicatorLayer.position = view.center

        let circle = CALayer()
        circle.frame = CGRect(origin: .zero, size: CGSize(width: 10, height: 10))
        circle.backgroundColor = UIColor.blue.cgColor
        circle.cornerRadius = 5
        circle.position = CGPoint(x: 0, y: 50)
        replicatorLayer.addSublayer(circle)

        let fadeOut = CABasicAnimation(keyPath: "opacity")
        fadeOut.fromValue = 1
        fadeOut.toValue = 0
        fadeOut.duration = 1
        fadeOut.repeatCount = .greatestFiniteMagnitude
        circle.add(fadeOut, forKey: nil)

        let instanceCount = 12
        replicatorLayer.instanceCount = instanceCount
        replicatorLayer.instanceDelay = fadeOut.duration / CFTimeInterval(instanceCount)

        let angle = CGFloat.pi * 2 / CGFloat(instanceCount)
        replicatorLayer.instanceTransform = CATransform3DMakeRotation(angle, 0, 0, 1)
        view.layer.addSublayer(replicatorLayer)
    }
}
