//
//  ShapeViewController.swift
//  CoreAnimationZuroku
//
//  Created by teruto.yamasaki on 2021/10/17.
//

import UIKit

class ShapeViewController: UIViewController {

    private let numberOfPatternRange: ClosedRange<Float> = 1...24
    private let numberOfPatternSlider = UISlider()
    private let shapeLayer = CAShapeLayer()
    private let label = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "CAShapeLayer"
        view.backgroundColor = .white

        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40).isActive = true
        label.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40).isActive = true

        numberOfPatternSlider.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(numberOfPatternSlider)
        numberOfPatternSlider.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20).isActive = true
        numberOfPatternSlider.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        numberOfPatternSlider.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40).isActive = true
        numberOfPatternSlider.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40).isActive = true

        numberOfPatternSlider.minimumValue = numberOfPatternRange.lowerBound
        numberOfPatternSlider.maximumValue = numberOfPatternRange.upperBound
        numberOfPatternSlider.setValue(6, animated: false)
        numberOfPatternSlider.isContinuous = true
        numberOfPatternSlider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)

        let initialNumberOfPattern = 6
        shapeLayer.frame = view.bounds
        shapeLayer.position = view.center
        shapeLayer.path = createPath(numberOfPattern: initialNumberOfPattern)
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.fillColor = UIColor.yellow.cgColor
        shapeLayer.fillRule = .evenOdd
        view.layer.addSublayer(shapeLayer)

        label.text = "Number Of Pattern: \(initialNumberOfPattern)"
    }

    @objc private func sliderValueChanged(_ sender: UISlider) {
        let intValue = Int(sender.value)
        shapeLayer.path = createPath(numberOfPattern: intValue)
        label.text = "Number Of Pattern: \(intValue)"
    }

    private func createPath(numberOfPattern: Int) -> CGPath {
        let path: CGPath = {
            let path = CGMutablePath()
            stride(from: 0, to: CGFloat.pi * 2, by: CGFloat.pi / CGFloat(numberOfPattern)).forEach {
                angle in
                var transform = CGAffineTransform(rotationAngle: angle)         .concatenating(CGAffineTransform(translationX: view.bounds.size.width / 2, y: view.bounds.size.height / 2))
                let petal = CGPath(ellipseIn: CGRect(x: -20, y: 0, width: 40, height: 100),
                                   transform: &transform)
                path.addPath(petal)
            }
            return path
        }()
        return path
    }
}
