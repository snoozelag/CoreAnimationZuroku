//
//  TransformViewController.swift
//  CoreAnimationZuroku
//
//  Created by teruto.yamasaki on 2021/10/17.
//

import UIKit

class TransformViewController: UIViewController {

    private let perspectiveView = PerspectiveView()
    private let parametersLabel = UILabel()

    private let eyePositionSlider = UISlider()
    private let eyePositionRange = 0...2000
    private var eyePosition: CGFloat = 500

    private let angleSlider = UISlider()
    private let angleRange = 0...360
    private var angle: CGFloat = 45

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "CATransformLayer"
        view.backgroundColor = .white
        
        perspectiveView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(perspectiveView)
        perspectiveView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        perspectiveView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        perspectiveView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        perspectiveView.updateTransformLayer(eyePosition: eyePosition, angle: angle)

        parametersLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(parametersLabel)
        parametersLabel.topAnchor.constraint(equalTo: perspectiveView.bottomAnchor, constant: 20).isActive = true
        parametersLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40).isActive = true
        parametersLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40).isActive = true
        parametersLabel.numberOfLines = 0

        eyePositionSlider.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(eyePositionSlider)
        eyePositionSlider.topAnchor.constraint(equalTo: parametersLabel.bottomAnchor, constant: 20).isActive = true
        eyePositionSlider.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 40).isActive = true
        eyePositionSlider.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -40).isActive = true
        eyePositionSlider.addTarget(self, action: #selector(eyePositionSliderValueChanged(_:)), for: .valueChanged)
        eyePositionSlider.minimumValue = Float(eyePositionRange.lowerBound)
        eyePositionSlider.maximumValue = Float(eyePositionRange.upperBound)
        eyePositionSlider.isContinuous = true
        eyePositionSlider.setValue(Float(eyePosition), animated: false)

        angleSlider.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(angleSlider)
        angleSlider.topAnchor.constraint(equalTo: eyePositionSlider.bottomAnchor, constant: 20).isActive = true
        angleSlider.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 40).isActive = true
        angleSlider.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -40).isActive = true
        angleSlider.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40).isActive = true
        angleSlider.addTarget(self, action: #selector(angleSliderValueChanged(_:)), for: .valueChanged)
        angleSlider.minimumValue = Float(angleRange.lowerBound)
        angleSlider.maximumValue = Float(angleRange.upperBound)
        angleSlider.isContinuous = true
        angleSlider.setValue(Float(angle), animated: false)

        updateParametersLabelText()
    }

    @objc private func eyePositionSliderValueChanged(_ sender: UISlider) {
        eyePosition = CGFloat(sender.value)
        perspectiveView.updateTransformLayer(eyePosition: eyePosition, angle: angle)
        updateParametersLabelText()
    }

    @objc private func angleSliderValueChanged(_ sender: UISlider) {
        angle = CGFloat(sender.value)
        perspectiveView.updateTransformLayer(eyePosition: eyePosition, angle: angle)
        updateParametersLabelText()
    }

    private func updateParametersLabelText() {
        parametersLabel.text = "perspective m34: -(1 / \(eyePositionSlider.value))\nangle: \(angleSlider.value)"
    }
}

private class PerspectiveView: UIView {

    private let redLayer = CALayer()
    private let greenLayer = CALayer()
    private let blueLayer = CALayer()

    override class var layerClass: AnyClass {
        return CATransformLayer.self
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        [redLayer, greenLayer, blueLayer].forEach { $0.position = CGPoint(x: bounds.size.width / 2 + 80, y: bounds.size.height / 2 ) }
    }

    private func setup() {
        setupLayerOfColor(redLayer, color: .red, zPosition: 0)
        setupLayerOfColor(greenLayer, color: .green, zPosition: 20)
        setupLayerOfColor(blueLayer, color: .blue, zPosition: 40)
        layer.addSublayer(redLayer)
        layer.addSublayer(greenLayer)
        layer.addSublayer(blueLayer)

        updateTransformLayer(eyePosition: 500, angle: 45)
    }

    private func setupLayerOfColor(_ colorLayer: CALayer, color: UIColor, zPosition: CGFloat) {
        colorLayer.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        colorLayer.backgroundColor = color.cgColor
        colorLayer.zPosition = zPosition
        colorLayer.opacity = 0.5
    }

    func updateTransformLayer(eyePosition: CGFloat, angle: CGFloat) {
        var perspective = CATransform3DIdentity
        perspective.m34 = -(1 / eyePosition)
        layer.transform = CATransform3DRotate(perspective, angle * CGFloat.pi / 180, 0, 1, 0)
    }
}

