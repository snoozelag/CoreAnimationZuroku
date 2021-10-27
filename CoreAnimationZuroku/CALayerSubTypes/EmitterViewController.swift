//
//  EmitterViewController.swift
//  CoreAnimationZuroku
//
//  Created by teruto.yamasaki on 2021/10/17.
//

import UIKit

class EmitterViewController: UIViewController {

    private let label = UILabel()
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    private let birthRateSliderRange: ClosedRange<Float> = 5...120
    private let birthRateSlider = UISlider()
    private let lifetimeSliderRange: ClosedRange<Float> = 0.5...20
    private let lifetimeSlider = UISlider()
    private let velocitySliderRange: ClosedRange<Float> = 10...90
    private let velocitySlider = UISlider()
    private let scaleSliderRange: ClosedRange<Float> = 0...4
    private let scaleSlider = UISlider()

    private let emitterLayer = CAEmitterLayer()
    private let myCell: CAEmitterCell = {
        // 放出されるパーティクルの初期設定
        let cell = CAEmitterCell()
        cell.birthRate = 20
        cell.lifetime = 4
        cell.velocity = 30
        cell.scale = 1
        cell.spin = .pi * 2.0 / 3 // 3秒に1回転
        cell.emissionRange = CGFloat.pi * 2.0
        cell.contents = UIImage(systemName: "snow")!.cgImage
        cell.contentsScale = UIScreen.main.scale
        return cell
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "CAEmitterLayer"
        view.backgroundColor = .black

        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        label.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 11).isActive = true
        label.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -11).isActive = true
        label.numberOfLines = 0
        label.textColor = .white

        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20).isActive = true
        stackView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 44).isActive = true
        stackView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -44).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -44).isActive = true
        stackView.axis = .vertical

        birthRateSlider.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(birthRateSlider)
        birthRateSlider.minimumValue = birthRateSliderRange.lowerBound
        birthRateSlider.maximumValue = birthRateSliderRange.upperBound
        birthRateSlider.setValue(myCell.birthRate, animated: false)
        birthRateSlider.isContinuous = true
        birthRateSlider.addTarget(self, action: #selector(birthRateSliderValueChanged(_:)), for: .valueChanged)

        lifetimeSlider.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(lifetimeSlider)
        lifetimeSlider.minimumValue = lifetimeSliderRange.lowerBound
        lifetimeSlider.maximumValue = lifetimeSliderRange.upperBound
        lifetimeSlider.setValue(myCell.lifetime, animated: false)
        lifetimeSlider.isContinuous = true
        lifetimeSlider.addTarget(self, action: #selector(lifetimeSliderValueChanged(_:)), for: .valueChanged)

        velocitySlider.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(velocitySlider)
        velocitySlider.minimumValue = velocitySliderRange.lowerBound
        velocitySlider.maximumValue = velocitySliderRange.upperBound
        velocitySlider.setValue(Float(myCell.velocity), animated: false)
        velocitySlider.isContinuous = true
        velocitySlider.addTarget(self, action: #selector(velocitySliderValueChanged(_:)), for: .valueChanged)

        scaleSlider.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(scaleSlider)
        scaleSlider.minimumValue = scaleSliderRange.lowerBound
        scaleSlider.maximumValue = scaleSliderRange.upperBound
        scaleSlider.setValue(Float(myCell.scale), animated: false)
        scaleSlider.isContinuous = true
        scaleSlider.addTarget(self, action: #selector(scaleSliderValueChanged(_:)), for: .valueChanged)

        emitterLayer.emitterPosition = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height * 2/5)
        emitterLayer.emitterCells = [myCell]

        view.layer.addSublayer(emitterLayer)

        updateLabel()
    }

    @objc private func birthRateSliderValueChanged(_ sender: UISlider) {
        myCell.birthRate = sender.value
        // イニシャライズずるか、オブジェクトを新たにする必要があるようだ
        let updateCell = myCell.copy() as! CAEmitterCell
        emitterLayer.emitterCells = [updateCell]
        updateLabel()
    }

    @objc private func lifetimeSliderValueChanged(_ sender: UISlider) {
        myCell.lifetime = sender.value
        let updateCell = myCell.copy() as! CAEmitterCell
        emitterLayer.emitterCells = [updateCell]
        updateLabel()
    }

    @objc private func velocitySliderValueChanged(_ sender: UISlider) {
        myCell.velocity = CGFloat(sender.value)
        let updateCell = myCell.copy() as! CAEmitterCell
        emitterLayer.emitterCells = [updateCell]
        updateLabel()
    }

    @objc private func scaleSliderValueChanged(_ sender: UISlider) {
        myCell.scale = CGFloat(sender.value)
        let updateCell = myCell.copy() as! CAEmitterCell
        emitterLayer.emitterCells = [updateCell]
        updateLabel()
    }

    private func updateLabel() {
        label.text = String(format:
        """
        birthRate: %.1f
        lifetime: %.1f
        velocity: %.1f
        scale: %.1f
        """,
                            birthRateSlider.value,
                            lifetimeSlider.value,
                            velocitySlider.value,
                            scaleSlider.value
        )
    }
}
