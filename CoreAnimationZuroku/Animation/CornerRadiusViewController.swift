//
//  CornerRadiusViewController.swift
//  CoreAnimationZuroku
//
//  Created by teruto.yamasaki on 2021/10/17.
//

import UIKit

/// Layers support a corner radius.
class CornerRadiusViewController: UIViewController {

    private let imageView = UIImageView()
    private let label = UILabel()
    private let slider = UISlider()
    private let sliderRange: ClosedRange<Float> = 0...250

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "CornerRadius"
        view.backgroundColor = .systemBackground

        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 11).isActive = true
        imageView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -11).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        imageView.backgroundColor = .systemGray5
        imageView.image = UIImage(named: "sampleImage")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true

        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant:  11).isActive = true
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.backgroundColor = .systemBackground

        slider.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(slider)
        slider.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 44).isActive = true
        slider.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -44).isActive = true
        slider.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -44).isActive = true

        let initialValue = sliderRange.upperBound / 4
        slider.minimumValue = sliderRange.lowerBound
        slider.maximumValue = sliderRange.upperBound
        slider.setValue(initialValue, animated: false)
        slider.isContinuous = true
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)

        label.text = String(format: "%.1f", initialValue)
        imageView.layer.cornerRadius = CGFloat(initialValue)
    }

    @objc private func sliderValueChanged(_ sender: UISlider) {
        imageView.layer.cornerRadius = CGFloat(sender.value)
        label.text = String(format: "%.1f", CGFloat(sender.value))
    }
}
