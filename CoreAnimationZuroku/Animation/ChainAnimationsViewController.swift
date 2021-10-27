//
//  ChainAnimationsViewController.swift
//  CoreAnimationZuroku
//
//  Created by teruto.yamasaki on 2021/10/17.
//

import UIKit

class ChainAnimationsViewController: UIViewController {

    private let sampleView = SampleView()
    private let startButton = UIButton()
    private let stopButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Chain Animations"
        view.backgroundColor = .systemGray5

        sampleView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sampleView)
        sampleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 11).isActive = true
        sampleView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        sampleView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        sampleView.widthAnchor.constraint(equalToConstant: 250).isActive = true

        stopButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stopButton)
        stopButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stopButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40).isActive = true
        stopButton.setTitleColor(.label, for: .normal)
        stopButton.setTitle("⏹", for: .normal)
        stopButton.titleLabel?.font = .systemFont(ofSize: 60)
        stopButton.addTarget(self, action: #selector(stopButtonDidTouchUp(_:)), for: .touchUpInside)

        startButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(startButton)
        startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        startButton.bottomAnchor.constraint(equalTo: stopButton.topAnchor, constant: -40).isActive = true
        startButton.setTitleColor(.label, for: .normal)
        startButton.setTitle("▶️", for: .normal)
        startButton.titleLabel?.font = .systemFont(ofSize: 60)
        startButton.addTarget(self, action: #selector(startButtonDidTouchUp(_:)), for: .touchUpInside)
    }

    @objc private func startButtonDidTouchUp(_ sender: UIButton) {
        let isAnimating = sampleView.subLayer.animation(forKey: "MyChainAnimation") != nil
        if isAnimating {
            let isPause = sampleView.subLayer.speed == 0
            if isPause {
                resumeAnimation()
                startButton.setTitle("⏸", for: .normal)
            } else {
                pauseAnimation()
                startButton.setTitle("⏯", for: .normal)
            }
        } else {
            resetLayerProperties()
            startAnimation()
        }
    }

    @objc private func stopButtonDidTouchUp(_ sender: UIButton) {
        stopAnimation()
        resetLayerProperties()
    }

    private func pauseAnimation() {
        let layer = sampleView.subLayer
        let pausedTime = layer.convertTime(CACurrentMediaTime(), from: nil)
        layer.speed = 0.0
        layer.timeOffset = pausedTime
    }

    private func resumeAnimation() {
        let layer = sampleView.subLayer
        let pausedTime: CFTimeInterval = layer.timeOffset
        layer.speed = 1.0
        layer.timeOffset = 0.0
        layer.beginTime = 0.0 // 0をセットすることで、再びアクティブになったレイヤーをグローバル時間に一致させる
        let timeSincePause = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        layer.beginTime = timeSincePause // 再生開始のオフセットを一時停止した時に移動する
    }

    private func stopAnimation() {
        sampleView.subLayer.removeAnimation(forKey: "MyChainAnimation")
    }

    private func resetLayerProperties() {
        CATransaction.begin()
        // 暗黙的アニメーション化しない
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        sampleView.subLayer.position = CGPoint(x: sampleView.bounds.midX, y: sampleView.bounds.midY)
        sampleView.subLayer.opacity = 1
        CATransaction.commit()
    }

    private func startAnimation() {
        let animation1 = CABasicAnimation(keyPath: #keyPath(CALayer.position))
        let targetPosition = CGPoint(x: 60, y: 60)
        animation1.fromValue = sampleView.subLayer.position
        animation1.toValue = targetPosition
        animation1.duration = 2
        animation1.beginTime = 0
        var totalDuration = animation1.duration

        let animation2 = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
        let targetOpacity: Float = 0
        animation2.fromValue = 1
        animation2.toValue = targetOpacity
        animation2.duration = 2
        animation2.beginTime = animation2.duration
        animation2.fillMode = .backwards
        totalDuration += animation2.duration

        let group = CAAnimationGroup()
        group.duration = totalDuration
        group.animations = [animation1, animation2]
        group.delegate = self
        sampleView.subLayer.position = targetPosition
        sampleView.subLayer.opacity = targetOpacity
        sampleView.subLayer.add(group, forKey: "MyChainAnimation")
    }
}

extension ChainAnimationsViewController: CAAnimationDelegate {

    func animationDidStart(_ animation: CAAnimation) {
        startButton.setTitle("⏸", for: .normal)
    }

    func animationDidStop(_ animation: CAAnimation, finished: Bool) {
        startButton.setTitle("▶️", for: .normal)
    }
}

private class SampleView: UIView {

    let subLayer = CALayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        backgroundColor = .white
        layer.addSublayer(subLayer)

        let size = CGSize(width: 100, height: 100)
        subLayer.borderWidth = 3
        subLayer.frame.size = size
        subLayer.backgroundColor = UIColor.blue.cgColor
        subLayer.contentsGravity = .center
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        subLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
    }
}

