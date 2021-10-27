//
//  GravityViewController.swift
//  CoreAnimationZuroku
//
//  Created by teruto.yamasaki on 2021/10/17.
//

import UIKit

extension CALayerContentsGravity {

    static let allValues = [CALayerContentsGravity.center, .top, .bottom, .left, .right, .topRight, .bottomLeft, .bottomRight, .resize, .resizeAspect, .resizeAspectFill]

    var name: String {
        let index = Self.allValues.firstIndex(of: self)!
        return Self.names[index]
    }

    static let names = ["center", "top", "bottom", "left", "right", "topRight", "bottomLeft", "bottomRight", "resize", "resizeAspect", "resizeAspectFill"]
}

extension UIView.ContentMode {

    var name: String {
        return Self.names[rawValue]
    }

    static let names = ["scaleToFill", "scaleAspectFit", "scaleAspectFill", "redraw", "center", "top", "bottom", "left", "right", "topLeft", "topRight", "bottomLeft", "bottomRight"]
}

class GravityViewController: UIViewController {

    private let sampleView = SampleView()
    private let label = UILabel()
    private let slider = UISlider()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Contents Gravity"
        view.backgroundColor = .systemBackground

        sampleView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sampleView)
        sampleView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        sampleView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 11).isActive = true
        sampleView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -11).isActive = true
        sampleView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        sampleView.backgroundColor = .systemGray5

        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        label.topAnchor.constraint(equalTo: sampleView.bottomAnchor, constant:  11).isActive = true
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.text = CALayerContentsGravity.names[0]
        label.backgroundColor = .systemBackground

        slider.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(slider)
        slider.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 44).isActive = true
        slider.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -44).isActive = true
        slider.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -44).isActive = true

        slider.minimumValue = 0
        slider.maximumValue = Float(CALayerContentsGravity.allValues.count - 1)
        slider.isContinuous = true
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
    }

    @objc private func sliderValueChanged(_ sender: UISlider) {
        let rounded = sender.value.rounded()
        sender.setValue(rounded, animated: true)

        // contentsGravity will only have an effect on the CGImage whose contents property is set.
        let contentsGravity = CALayerContentsGravity.allValues[Int(rounded)]
        sampleView.layer.contentsGravity = contentsGravity
        label.text = contentsGravity.name
        print("layer: " + sampleView.layer.contentsScale.description)
        print("view: " + sampleView.contentScaleFactor.description)
        print("layer: " + contentsGravity.name)
        print("view: " + sampleView.contentMode.name)
    }
}

private class SampleView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        layer.contentsGravity = CALayerContentsGravity.allValues[0]
        layer.isGeometryFlipped = true
        layer.contents = UIImage(named: "sample_icon")?.cgImage
        layer.contentsScale = UIScreen.main.scale
    }
}
