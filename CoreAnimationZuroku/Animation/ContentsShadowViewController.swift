//
//  ContentsShadowViewController.swift
//  CoreAnimationZuroku
//
//  Created by teruto.yamasaki on 2021/10/17.
//

import UIKit

class ContentsShadowViewController: UIViewController {

    private let shadowView = ShadowView(image: UIImage(named: "caz"))
    private let label = UILabel()
    private let stackView = UIStackView()
    private let cornerRadiusRange: ClosedRange<Float> = 0...250
    private let cornerRadiusSlider = UISlider()
    private let shadowOpacityRange: ClosedRange<Float> = 0...1
    private let shadowOpacitySlider = UISlider()
    private let shadowRadiusRange: ClosedRange<Float> = 0...100
    private let shadowRadiusSlider = UISlider()
    private let shadowOffsetHeightRange: ClosedRange<Float> = -150...150
    private let shadowOffsetHeightSlider = UISlider()
    private let shadowOffsetWidthRange: ClosedRange<Float> = -150...150
    private let shadowOffsetWidthSlider = UISlider()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Contents with Shadow"
        view.backgroundColor = .systemBackground

        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(container)
        container.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        container.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        container.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true

        shadowView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(shadowView)
        shadowView.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        shadowView.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        shadowView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        shadowView.heightAnchor.constraint(equalToConstant: 200).isActive = true

        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        label.topAnchor.constraint(equalTo: container.bottomAnchor, constant: 20).isActive = true
        label.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 11).isActive = true
        label.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -11).isActive = true
        label.numberOfLines = 0

        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20).isActive = true
        stackView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 44).isActive = true
        stackView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -44).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -44).isActive = true
        stackView.axis = .vertical

        cornerRadiusSlider.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(cornerRadiusSlider)
        cornerRadiusSlider.minimumValue = cornerRadiusRange.lowerBound
        cornerRadiusSlider.maximumValue = cornerRadiusRange.upperBound
        cornerRadiusSlider.setValue(cornerRadiusRange.upperBound / 4, animated: false)
        cornerRadiusSlider.isContinuous = true
        cornerRadiusSlider.addTarget(self, action: #selector(cornerRadiusSliderValueChanged(_:)), for: .valueChanged)
        shadowView.layer.cornerRadius = CGFloat(cornerRadiusRange.upperBound / 4)

        shadowOpacitySlider.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(shadowOpacitySlider)
        shadowOpacitySlider.minimumValue = shadowOpacityRange.lowerBound
        shadowOpacitySlider.maximumValue = shadowOpacityRange.upperBound
        shadowOpacitySlider.setValue(shadowOpacityRange.upperBound / 2, animated: false)
        shadowOpacitySlider.isContinuous = true
        shadowOpacitySlider.addTarget(self, action: #selector(shadowOpacitySliderValueChanged(_:)), for: .valueChanged)
        shadowView.layer.shadowOpacity = shadowOpacityRange.upperBound / 2

        shadowRadiusSlider.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(shadowRadiusSlider)
        shadowRadiusSlider.minimumValue = shadowRadiusRange.lowerBound
        shadowRadiusSlider.maximumValue = shadowRadiusRange.upperBound
        shadowRadiusSlider.setValue(shadowRadiusRange.upperBound / 10, animated: false)
        shadowRadiusSlider.isContinuous = true
        shadowRadiusSlider.addTarget(self, action: #selector(shadowRadiusSliderValueChanged(_:)), for: .valueChanged)
        shadowView.layer.cornerRadius = CGFloat(shadowRadiusRange.upperBound / 4)

        shadowOffsetWidthSlider.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(shadowOffsetWidthSlider)
        shadowOffsetWidthSlider.minimumValue = shadowOffsetWidthRange.lowerBound
        shadowOffsetWidthSlider.maximumValue = shadowOffsetWidthRange.upperBound
        shadowOffsetWidthSlider.setValue(shadowOffsetWidthRange.upperBound / 10, animated: false)
        shadowOffsetWidthSlider.isContinuous = true
        shadowOffsetWidthSlider.addTarget(self, action: #selector(shadowOffsetWidthSliderValueChanged(_:)), for: .valueChanged)
        shadowView.layer.cornerRadius = CGFloat(shadowOffsetWidthRange.upperBound / 4)
        
        shadowOffsetHeightSlider.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(shadowOffsetHeightSlider)
        shadowOffsetHeightSlider.minimumValue = shadowOffsetHeightRange.lowerBound
        shadowOffsetHeightSlider.maximumValue = shadowOffsetHeightRange.upperBound
        shadowOffsetHeightSlider.setValue(shadowOffsetHeightRange.upperBound / 10, animated: false)
        shadowOffsetHeightSlider.isContinuous = true
        shadowOffsetHeightSlider.addTarget(self, action: #selector(shadowOffsetHeightSliderValueChanged(_:)), for: .valueChanged)
        shadowView.layer.cornerRadius = CGFloat(shadowOffsetHeightRange.upperBound / 4)

        updateLabel()
    }

    @objc private func cornerRadiusSliderValueChanged(_ sender: UISlider) {
        shadowView.layer.cornerRadius = CGFloat(sender.value)

        CATransaction.begin()
        // Remove Implicitly Animation
        CATransaction.setDisableActions(true)
        shadowView.contentsLayer.cornerRadius = CGFloat(sender.value)
        CATransaction.commit()
        updateLabel()
    }

    @objc private func shadowOpacitySliderValueChanged(_ sender: UISlider) {
        shadowView.layer.shadowOpacity = sender.value
        updateLabel()
    }

    @objc private func shadowRadiusSliderValueChanged(_ sender: UISlider) {
        shadowView.layer.shadowRadius = CGFloat(sender.value)
        updateLabel()
    }

    @objc private func shadowOffsetWidthSliderValueChanged(_ sender: UISlider) {
        shadowView.layer.shadowOffset = CGSize(width: CGFloat(sender.value), height: CGFloat(shadowOffsetHeightSlider.value))
        updateLabel()
    }

    @objc private func shadowOffsetHeightSliderValueChanged(_ sender: UISlider) {
        shadowView.layer.shadowOffset = CGSize(width: CGFloat(shadowOffsetWidthSlider.value), height: CGFloat(sender.value))
        updateLabel()
    }

    private func updateLabel() {
        label.text = String(format:
        """
        cornerRadius: %.1f
        shadowOpacity: %.2f
        shadowRadius: %.1f
        shadowOffsetWidth: %.1f
        shadowOffsetHeight: %.1f
        """,
                            cornerRadiusSlider.value,
                            shadowOpacitySlider.value,
                            shadowRadiusSlider.value,
                            shadowOffsetWidthSlider.value,
                            shadowOffsetHeightSlider.value
        )
    }
}

private class ShadowView: UIView {

    let contentsLayer = CALayer()

    var image: UIImage? {
        didSet {
            contentsLayer.contents = image?.cgImage
        }
    }

    init(image: UIImage?) {
        super.init(frame: .zero)
        setup(image: image)
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
        contentsLayer.frame = bounds
    }

    private func setup(image: UIImage? = nil) {
        let cornerRadius: CGFloat = 20
        // コンテンツレイヤー（コンテンツを含み、masksToBoundsが有効。シャドーレイヤーと同サイズ）
        contentsLayer.cornerRadius = cornerRadius
        contentsLayer.masksToBounds = true
        contentsLayer.contents = image?.cgImage
        contentsLayer.contentsScale = UIScreen.main.scale

        // シャドウレイヤー（シャドウ効果を有効。コンテンツレイヤーと同サイズ）
        layer.cornerRadius = cornerRadius
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 10
        layer.shadowOffset = .zero
        layer.addSublayer(contentsLayer)
    }
}
