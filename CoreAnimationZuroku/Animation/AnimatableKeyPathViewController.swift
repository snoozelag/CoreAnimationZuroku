//
//  AnimatableKeyPathViewController.swift
//  CoreAnimationZuroku
//
//  Created by teruto.yamasaki on 2021/10/17.
//

import UIKit

class AnimatableKeyPathViewController: UIViewController {

    private let sampleView = SampleView()
    private let presentationLabel = UILabel()
    private let label = UILabel()
    private let picker = UIPickerView()

    private let labelFormat = "keyPath: %@\nfromValue: %@\ntoValue: %@\nduration: %.1f"
    private let labelFormatForKeyframeAnim = "keyPath: %@\nkeyTimes: %@\nvalues: %@\nduration: %.1f"
    private var didStopHandler: (() -> Void)?
    private var presentationLabelTimer: Timer?

    /// CALayer Animatable Properties
    /// https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/CoreAnimation_guide/AnimatableProperties/AnimatableProperties.html
    private let animatablePropertyKeyPaths = [
        "----",
        "anchorPoint",
        "backgroundColor",
        // "backgroundFilters", // This property is not supported on layers in iOS.
        "borderColor",
        "borderWidth",
        "bounds",
        "bounds.size",
        // "compositingFilter", // This property is not supported on layers in iOS.
        "contents",
        "contentsRect",
        "cornerRadius",
        "doubleSided",
        // "filters", // This property is not supported on layers in iOS.
        // "frame", // The frame property is not directly animatable. See https://developer.apple.com/documentation/quartzcore/calayer/1410779-frame
        "hidden",
        "mask",
        // "masksToBounds", // I tried, but it doesn't work.
        "opacity",
        "position",
        "shadowColor",
        "shadowOffset",
        "shadowOpacity",
        "shadowPath",
        "shadowRadius",
        "sublayers",
        "sublayerTransform",
        "transform",
        "zPosition"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Animatable KeyPaths"
        view.backgroundColor = .systemGray5

        sampleView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sampleView)
        sampleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 11).isActive = true
        sampleView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        sampleView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        sampleView.widthAnchor.constraint(equalToConstant: 250).isActive = true

        presentationLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(presentationLabel)
        presentationLabel.topAnchor.constraint(equalTo: sampleView.bottomAnchor, constant:  11).isActive = true
        presentationLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 11).isActive = true
        presentationLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -11).isActive = true
        presentationLabel.backgroundColor = .systemGray5
        presentationLabel.numberOfLines = 0

        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        label.topAnchor.constraint(equalTo: presentationLabel.bottomAnchor, constant:  11).isActive = true
        label.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 11).isActive = true
        label.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -11).isActive = true
        label.backgroundColor = .systemGray5
        label.numberOfLines = 0

        picker.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(picker)
        picker.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        picker.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        picker.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        picker.dataSource = self
        picker.delegate = self
    }

    // MARK: - Common

    private func startBasicAnimation(keyPath: String, fromValue: Any?, toValue: Any?, duration: CFTimeInterval, didStopHandler: (() -> Void)? = nil) {
        let animation = CABasicAnimation(keyPath: keyPath)
        animation.fromValue = fromValue
        animation.toValue = toValue
        animation.duration = duration
        animation.repeatCount = .greatestFiniteMagnitude
        self.didStopHandler = didStopHandler
        animation.delegate = self
        sampleView.subLayer.add(animation, forKey: animation.keyPath)
    }

    private func startKeyFrameAnimation(keyPath: String, keyTimes: [NSNumber]?, values: [Any]?, duration: CFTimeInterval, didStopHandler: (() -> Void)? = nil) {
        let keyframeAnimation = CAKeyframeAnimation(keyPath: keyPath)
        keyframeAnimation.calculationMode = .discrete
        keyframeAnimation.repeatCount = .greatestFiniteMagnitude
        keyframeAnimation.keyTimes = keyTimes
        keyframeAnimation.values = values
        keyframeAnimation.duration = duration
        self.didStopHandler = didStopHandler
        keyframeAnimation.delegate = self
        sampleView.subLayer.add(keyframeAnimation, forKey: keyframeAnimation.keyPath)
    }

    private func stopAnimationAndResetLabel() {
        sampleView.subLayer.removeAllAnimations()
        sampleView.subLayer.mask?.removeAllAnimations()
        sampleView.layer.removeAllAnimations()
        presentationLabel.text = ""
        presentationLabelTimer?.invalidate()
        presentationLabelTimer = nil
    }

    // MARK: - Animations

    private func animateAnchorPoint() {
        let keyPath = #keyPath(CALayer.anchorPoint)
        let fromValue = CGPoint(x: 0.5, y: 0.5)
        let toValue = CGPoint(x: 0.7, y: 0.85)
        let duration: CFTimeInterval = 1
        label.text = String(format: labelFormat, keyPath, fromValue.debugDescription, toValue.debugDescription, duration)
        startBasicAnimation(keyPath: keyPath, fromValue: fromValue, toValue: toValue, duration: duration)
    }

    private func animateBackgroundColor() {
        let keyPath = #keyPath(CALayer.backgroundColor)
        let fromValue = UIColor.blue.cgColor
        let toValue = UIColor.yellow.cgColor
        let duration: CFTimeInterval = 2
        label.text = String(format: labelFormat, keyPath, "blue", "yellow", duration)
        startBasicAnimation(keyPath: keyPath, fromValue: fromValue, toValue: toValue, duration: duration)
    }

    private func animateBorderColor() {
        let keyPath = #keyPath(CALayer.borderColor)
        let fromValue = UIColor.black.cgColor
        let toValue = UIColor.red.cgColor
        let duration: CFTimeInterval = 2
        label.text = String(format: labelFormat, keyPath, "black", "red", duration)
        startBasicAnimation(keyPath: keyPath, fromValue: fromValue, toValue: toValue, duration: duration)
    }

    private func animateBorderWidth() {
        let keyPath = #keyPath(CALayer.borderWidth)
        let fromValue = 3
        let toValue = 20
        let duration: CFTimeInterval = 2
        label.text = String(format: labelFormat, keyPath, "\(fromValue)", "\(toValue)", duration)
        startBasicAnimation(keyPath: keyPath, fromValue: fromValue, toValue: toValue, duration: duration)
    }

    private func animateBounds() {
        let keyPath = #keyPath(CALayer.bounds)
        let currentBounds = sampleView.subLayer.bounds
        let fromValue = currentBounds
        let toValue = CGRect.zero
        let duration: CFTimeInterval = 2
        label.text = String(format: labelFormat, keyPath, fromValue.debugDescription, toValue.debugDescription, duration)
        startBasicAnimation(keyPath: keyPath, fromValue: fromValue, toValue: toValue, duration: duration)
    }

    private func animateBoundsSize() {
        let keyPath = "bounds.size"
        let fromValue = sampleView.subLayer.bounds.size
        let toValue = CGSize(width: 150, height: 150)
        let duration: CFTimeInterval = 2
        label.text = String(format: labelFormat, keyPath, fromValue.debugDescription, toValue.debugDescription, duration)
        startBasicAnimation(keyPath: keyPath, fromValue: fromValue, toValue: toValue, duration: duration)
    }

    private func animateContents() {
        let subLayer = sampleView.subLayer
        subLayer.backgroundColor = UIColor.white.cgColor

        let keyPath = #keyPath(CALayer.contents)
        let fromValue = UIImage(systemName: "figure.wave")!.cgImage!
        let toValue = UIImage(systemName: "person.icloud")!.cgImage!
        let duration: CFTimeInterval = 2
        label.text = String(format: labelFormat, keyPath, "figure.wave", "person.icloud", duration)
        startBasicAnimation(keyPath: keyPath, fromValue: fromValue, toValue: toValue, duration: duration, didStopHandler: {
            subLayer.backgroundColor = UIColor.blue.cgColor
        })
    }

    private func animateContentsRect() {
        let subLayer = sampleView.subLayer
        subLayer.contents = UIImage(named: "sample_icon")!.cgImage
        subLayer.contentsScale = UIScreen.main.scale

        let keyPath = #keyPath(CALayer.contentsRect)
        let currentContentsRect = sampleView.subLayer.contentsRect
        let fromValue = currentContentsRect
        let toValue = CGRect.zero
        let duration: CFTimeInterval = 2
        label.text = String(format: labelFormat, keyPath, fromValue.debugDescription, toValue.debugDescription, duration)
        startBasicAnimation(keyPath: keyPath, fromValue: fromValue, toValue: toValue, duration: duration, didStopHandler: {
            subLayer.contents = nil
        })
    }

    private func animateCornerRadius() {
        let keyPath = #keyPath(CALayer.cornerRadius)
        let currentCornerRadius = sampleView.subLayer.cornerRadius
        let fromValue = currentCornerRadius
        let toValue: CGFloat = 400
        let duration: CFTimeInterval = 2
        label.text = String(format: labelFormat, keyPath, "\(fromValue)", "\(toValue)", duration)
        startBasicAnimation(keyPath: keyPath, fromValue: fromValue, toValue: toValue, duration: duration)
    }

    /// If isDoubleSided is set to false, the CALayer object will not be visible when it is flipped over.
    /// On keyframes that are false, you can see the animation of the layer being transparent.
    private func animateDoubleSided() {
        // When the value in isDoubleSided property is false, the layer hides its content when it faces away from the viewer. The default value of this property is true.

        let doubleSidedAnimation: CAAnimation = {
            let keyPath = #keyPath(CALayer.isDoubleSided)
            let keyframeAnimation = CAKeyframeAnimation(keyPath: keyPath)
            keyframeAnimation.calculationMode = .discrete
            keyframeAnimation.repeatCount = .greatestFiniteMagnitude
            keyframeAnimation.keyTimes = [0, 0.5, 1]
            keyframeAnimation.values = [true, false]
            keyframeAnimation.duration = 0.5
            return keyframeAnimation
        }()

        let flipAnimation: CAAnimation = {
            let keyPath = "transform.rotation.x"
            let animation = CABasicAnimation(keyPath: keyPath)
            animation.fromValue = 0
            animation.toValue = CGFloat.pi
            return animation
        }()

        let duration: CFTimeInterval = 6
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [flipAnimation, doubleSidedAnimation]
        animationGroup.repeatCount = .greatestFiniteMagnitude
        animationGroup.duration = duration
        animationGroup.delegate = self

        sampleView.subLayer.add(animationGroup, forKey: "FlipAndDoubleSided")
        label.text = String(format: labelFormat, "doubleSided, transform.rotation.x", "flip 0\nkeyTimes: [0, 0.8, 1]", "pi\nvalues: [true, false]", duration)
    }

    private func animateHidden() {
        // The "hidden" key path animation is simply used in CAKeyframeAnimation. This way, you can make it blink at any time you want.
        // Use the "opacity" keypath if you want an effect such as the layer gradually becoming lighter.
        let keyPath = #keyPath(CALayer.isHidden) // "hidden"

        // The number of elements in the values array in discrete calculation mode is one less than the number of elements in the keyTimes array.
        let keyTimes: [NSNumber] = [0, 0.2, 0.3, 0.9, 1]
        let values = [false, true, false, true]
        let duration: CFTimeInterval = 4
        // Since hidden keyPath animations do not change smoothly, discrete calculation mode can be specified.
        startKeyFrameAnimation(keyPath: keyPath, keyTimes: keyTimes, values: values, duration: duration)
        label.text = String(format: labelFormatForKeyframeAnim, keyPath, "[false, true, false, true]", "[0, 0.2, 0.3, 0.9, 1]", duration)
    }

    private func animateMask() {
        let subLayerBounds = sampleView.subLayer.bounds

        let fromValue: CGMutablePath = {
            let path = CGMutablePath()
            path.addEllipse(in: subLayerBounds)
            return path
        }()

        let toValue: CGMutablePath = {
            let path = CGMutablePath()
            let radius: CGFloat = 10 / 2
            path.addEllipse(in: CGRect(origin: CGPoint(x: subLayerBounds.midX - radius, y: subLayerBounds.midY - radius), size: CGSize(width: radius * 2, height: radius * 2)))
            return path
        }()

        sampleView.subLayer.mask = {
            let maskLayer = CAShapeLayer()
            maskLayer.path = fromValue
            return maskLayer
        }()

        let keyPath = #keyPath(CAShapeLayer.path)
        let duration: CFTimeInterval = 2
        let animation = CABasicAnimation(keyPath: keyPath)
        animation.fromValue = fromValue
        animation.toValue = toValue
        animation.duration = duration
        animation.repeatCount = .greatestFiniteMagnitude
        self.didStopHandler = { [weak self] in
            self?.sampleView.subLayer.mask = nil
        }
        animation.delegate = self

        sampleView.subLayer.mask?.add(animation, forKey: animation.keyPath)
        label.text = String(format: labelFormat, keyPath, "200 size circle", "10 size circle", duration)
    }

    /// This keyPath doesn't work?
    /// https://stackoverflow.com/a/55287197
//    private func animateMasksToBounds() {
//        let maskedLayer = CALayer()
//        maskedLayer.borderWidth = 2
//        maskedLayer.frame = sampleView.subLayer.bounds.offsetBy(dx: 20, dy: 20)
//        maskedLayer.backgroundColor = UIColor.red.cgColor
//        sampleView.subLayer.addSublayer(maskedLayer)
//
//        let keyPath = #keyPath(CALayer.masksToBounds"
//        let keyTimes: [NSNumber] = [0, 0.2, 0.3, 0.9, 1]
//        let values = [false, true, false, true]
//        let duration: CFTimeInterval = 4
//
//        // Since masksToBounds keyPath animations do not change smoothly, discrete calculation mode can be specified.
//        startKeyFrameAnimation(keyPath: keyPath, keyTimes: keyTimes, values: values, duration: duration, didStopHandler: { [weak self] in
//            self?.sampleView.subLayer.sublayers?.forEach { $0.removeFromSuperlayer() }
//        })
//        label.text = String(format: labelFormatForKeyfameAnim, keyPath, "[false, true, false, true]", "[0, 0.2, 0.3, 0.9, 1]", duration)
//    }

    private func animateOpacity() {
        let keyPath = #keyPath(CALayer.opacity)
        let fromValue = 1
        let toValue = 0
        let duration: CFTimeInterval = 1
        label.text = String(format: labelFormat, keyPath, "\(fromValue)", "\(toValue)", duration)
        startBasicAnimation(keyPath: keyPath, fromValue: fromValue, toValue: toValue, duration: duration)
    }

    private func animatePosition() {
        let keyPath = #keyPath(CALayer.position)
        let currentPosition = sampleView.subLayer.position
        let fromValue = CGPoint(x: currentPosition.x - 20, y: currentPosition.y - 20)
        let toValue = CGPoint(x: currentPosition.x + 20, y: currentPosition.y + 20)
        let duration: CFTimeInterval = 1
        label.text = String(format: labelFormat, keyPath, fromValue.debugDescription, toValue.debugDescription, duration)
        startBasicAnimation(keyPath: keyPath, fromValue: fromValue, toValue: toValue, duration: duration)
    }

    private func animateShadowColor() {
        let subLayer = sampleView.subLayer
        subLayer.shadowRadius = 5
        subLayer.shadowOpacity = 1
        subLayer.shadowPath = {
            let shadowSize: CGFloat = 20
            let shadowRect = CGRect(x: -shadowSize,
                              y: subLayer.bounds.height,
                              width: subLayer.bounds.width + shadowSize * 2,
                              height: shadowSize)
            return CGPath(ellipseIn: shadowRect, transform: nil)
        }()

        let keyPath = #keyPath(CALayer.shadowColor)
        let fromValue = UIColor.red.cgColor
        let toValue = UIColor.yellow.cgColor
        let duration: CFTimeInterval = 2
        label.text = String(format: labelFormat, keyPath, "red", "yellow", duration)
        startBasicAnimation(keyPath: keyPath, fromValue: fromValue, toValue: toValue, duration: duration, didStopHandler: {
            subLayer.shadowOpacity = 0
            subLayer.shadowPath = nil
        })
    }

    private func animateShadowOffset() {
        let subLayer = sampleView.subLayer
        subLayer.shadowRadius = 5
        subLayer.shadowOpacity = 1
        subLayer.shadowPath = {
            let shadowSize: CGFloat = 20
            let shadowRect = CGRect(x: -shadowSize,
                                    y: subLayer.bounds.height,
                                    width: subLayer.bounds.width + shadowSize * 2,
                                    height: shadowSize)
            return CGPath(ellipseIn: shadowRect, transform: nil)
        }()

        let keyPath = #keyPath(CALayer.shadowOffset)
        let fromValue = CGSize(width: subLayer.shadowOffset.width - 20, height: subLayer.shadowOffset.height - 20)
        let toValue = CGSize(width: subLayer.shadowOffset.width + 20, height: subLayer.shadowOffset.height + 20)
        let duration: CFTimeInterval = 2
        label.text = String(format: labelFormat, keyPath, fromValue.debugDescription, toValue.debugDescription, duration)
        startBasicAnimation(keyPath: keyPath, fromValue: fromValue, toValue: toValue, duration: duration, didStopHandler: {
            subLayer.shadowOpacity = 0
            subLayer.shadowPath = nil
        })
    }

    private func animateShadowOpacity() {
        let subLayer = sampleView.subLayer
        subLayer.shadowRadius = 5
        subLayer.shadowOpacity = 1
        subLayer.shadowPath = {
            let shadowSize: CGFloat = 20
            let shadowRect = CGRect(x: -shadowSize,
                                    y: subLayer.bounds.height,
                                    width: subLayer.bounds.width + shadowSize * 2,
                                    height: shadowSize)
            return CGPath(ellipseIn: shadowRect, transform: nil)
        }()

        let keyPath = #keyPath(CALayer.shadowOpacity)
        let fromValue = 1
        let toValue = 0
        let duration: CFTimeInterval = 2
        label.text = String(format: labelFormat, keyPath, "\(fromValue)", "\(toValue)", duration)
        startBasicAnimation(keyPath: keyPath, fromValue: fromValue, toValue: toValue, duration: duration, didStopHandler: {
            subLayer.shadowOpacity = 0
            subLayer.shadowPath = nil
        })
    }

    private func animateShadowPath() {
        let subLayer = sampleView.subLayer
        subLayer.shadowRadius = 5
        subLayer.shadowOpacity = 1

        let fromValue: CGPath = {
            let shadowSize: CGFloat = 20
            let shadowRect = CGRect(x: -shadowSize,
                                    y: subLayer.bounds.height,
                                    width: subLayer.bounds.width + shadowSize * 2,
                                    height: shadowSize)
            return CGPath(ellipseIn: shadowRect, transform: nil)
        }()

        let toValue: CGPath = {
            let shadowSize: CGFloat = 10
            let shadowRect = CGRect(x: -shadowSize,
                                    y: subLayer.bounds.height + 30,
                                    width: subLayer.bounds.width + shadowSize * 2,
                                    height: shadowSize)
            return CGPath(ellipseIn: shadowRect, transform: nil)
        }()

        subLayer.shadowPath = fromValue

        let keyPath = #keyPath(CALayer.shadowPath)
        let duration: CFTimeInterval = 2
        label.text = String(format: labelFormat, keyPath, "shadowSize 20", "shadowSize 10, y += 30", duration)
        startBasicAnimation(keyPath: keyPath, fromValue: fromValue, toValue: toValue, duration: duration, didStopHandler: {
            subLayer.shadowOpacity = 0
            subLayer.shadowPath = nil
        })
    }

    private func animateShadowRadius() {
        let subLayer = sampleView.subLayer
        subLayer.shadowRadius = 5
        subLayer.shadowOpacity = 1
        subLayer.shadowPath = {
            let shadowSize: CGFloat = 20
            let shadowRect = CGRect(x: -shadowSize,
                                    y: subLayer.bounds.height,
                                    width: subLayer.bounds.width + shadowSize * 2,
                                    height: shadowSize)
            return CGPath(ellipseIn: shadowRect, transform: nil)
        }()

        let keyPath = #keyPath(CALayer.shadowRadius)
        let fromValue: CGFloat = 20
        let toValue: CGFloat = 0
        let duration: CFTimeInterval = 2
        label.text = String(format: labelFormat, keyPath, "\(fromValue)", "\(toValue)", duration)
        startBasicAnimation(keyPath: keyPath, fromValue: fromValue, toValue: toValue, duration: duration, didStopHandler: {
            subLayer.shadowOpacity = 0
            subLayer.shadowPath = nil
        })
    }

    private func animateSublayers() {
        let size = CGSize(width: 30, height: 30)

        let redLayer = CALayer()
        redLayer.name = "red"
        redLayer.frame = CGRect(origin: .zero, size: size)
        redLayer.backgroundColor = UIColor.red.cgColor
        redLayer.borderWidth = 3

        let yellowLayer = CALayer()
        yellowLayer.name = "yellow"
        yellowLayer.frame = CGRect(origin: CGPoint(x: 20, y: 40), size: size)
        yellowLayer.backgroundColor = UIColor.yellow.cgColor
        yellowLayer.borderWidth = 3

        sampleView.subLayer.addSublayer(redLayer)
        sampleView.subLayer.addSublayer(yellowLayer)

        // By using the sublayers key path, you can add animation to blueLayer and direct it to redLayer.
        do {
            let keyPath = "sublayers.red.position"
            let fromValue = redLayer.position
            let toValue = CGPoint(x: 85, y: 85)
            let duration: CFTimeInterval = 2
            startBasicAnimation(keyPath: keyPath, fromValue: fromValue, toValue: toValue, duration: duration)
        }

        // By using the sublayers key path, you can add animation to blueLayer and direct it to yellowLayer.
        do {
            let keyPath = "sublayers.yellow.opacity"
            let fromValue = 1
            let toValue = 0
            let duration: CFTimeInterval = 2
            startBasicAnimation(keyPath: keyPath, fromValue: fromValue, toValue: toValue, duration: duration, didStopHandler: {
                redLayer.removeFromSuperlayer()
                yellowLayer.removeFromSuperlayer()
            })
        }

        label.text = String(format: labelFormat, "sublayers.red.position, sublayers.yellow.opacity", "\(CGPoint(x: 15, y: 15)), 1", "\(CGPoint(x: 85, y: 85)), 0", 2)
    }

    private func animateSublayerTransform() {
        let redLayer = CALayer()
        redLayer.frame = CGRect(origin: CGPoint(x: -10, y: -20), size: sampleView.subLayer.bounds.size)
        redLayer.backgroundColor = UIColor.red.cgColor
        redLayer.borderWidth = 3
        sampleView.subLayer.addSublayer(redLayer)

        let keyPath = #keyPath(CALayer.sublayerTransform)
        let fromValue = CATransform3DMakeAffineTransform(.identity.scaledBy(x: 0.5, y: 0.5))
        let toValue = CATransform3DMakeAffineTransform(.identity.scaledBy(x: 1.5, y: 1.75))
        let duration: CFTimeInterval = 2
        label.text = String(format: labelFormat, keyPath, "scaledBy(x: 0.5, y: 0.5)", "scaledBy(x: 1.5, y: 1.75)", duration)
        startBasicAnimation(keyPath: keyPath, fromValue: fromValue, toValue: toValue, duration: duration, didStopHandler: {
            redLayer.removeFromSuperlayer()
        })
    }

    private func animateTransform() {
        let keyPath = #keyPath(CALayer.transform)
        let fromValue = CATransform3DMakeAffineTransform(.identity.scaledBy(x: 0.5, y: 0.5))
        let toValue = CATransform3DMakeAffineTransform(.identity.scaledBy(x: 1.5, y: 1.75))
        let duration: CFTimeInterval = 2
        label.text = String(format: labelFormat, keyPath, "scaledBy(x: 0.5, y: 0.5)", "scaledBy(x: 1.5, y: 1.75)", duration)
        startBasicAnimation(keyPath: keyPath, fromValue: fromValue, toValue: toValue, duration: duration)
    }

    private func animateZPosition() {
        // Since this is a 2D viewpoint with no depth, it is treated as a range of values between 0.0 and 1.0 for convenience.
        // The zPosition is the same point-based coordinate system as x and y.

        let redLayer = CALayer()
        redLayer.frame = sampleView.subLayer.frame.offsetBy(dx: -20, dy: -20)
        redLayer.borderWidth = 3
        redLayer.backgroundColor = UIColor.red.cgColor
        redLayer.zPosition = 0.2

        let yellowLayer = CALayer()
        yellowLayer.frame = sampleView.subLayer.frame.offsetBy(dx: 20, dy: 20)
        yellowLayer.borderWidth = 3
        yellowLayer.backgroundColor = UIColor.yellow.cgColor
        yellowLayer.zPosition = 0.7

        sampleView.layer.insertSublayer(redLayer, below: sampleView.subLayer)
        sampleView.layer.addSublayer(yellowLayer)

        let keyPath = #keyPath(CALayer.zPosition)
        // The default value of zPosition property is 0.
        let keyTimes: [NSNumber] = [0, 0.3, 0.6, 1]
        let values: [CGFloat] = [0, 0.5, 1]
        let duration: CFTimeInterval = 2
        label.text = String(format: labelFormatForKeyframeAnim, keyPath, "[0, 0.3, 0.6, 1]", "[0, 0.5, 1]", duration)
        startKeyFrameAnimation(keyPath: keyPath, keyTimes: keyTimes, values: values, duration: duration, didStopHandler: {
            redLayer.removeFromSuperlayer()
            yellowLayer.removeFromSuperlayer()
        })

        presentationLabelTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { [weak self] timer in
            guard let self = self else { return }
            guard let presentation = self.sampleView.subLayer.presentation() else { return }
            self.presentationLabel.text = "blue zPosition: " + presentation.zPosition.description
        })
    }
}

extension AnimatableKeyPathViewController: CAAnimationDelegate {

    func animationDidStop(_ animation: CAAnimation, finished flag: Bool) {
        didStopHandler?()
    }
}

extension AnimatableKeyPathViewController: UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return animatablePropertyKeyPaths.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        // stop animations
        stopAnimationAndResetLabel()
        return animatablePropertyKeyPaths[row]
    }
}

extension AnimatableKeyPathViewController: UIPickerViewDelegate {

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch row {
        case 0:
            label.text = ""
        case 1:
            animateAnchorPoint()
        case 2:
            animateBackgroundColor()
        case 3:
            animateBorderColor()
        case 4:
            animateBorderWidth()
        case 5:
            animateBounds()
        case 6:
            animateBoundsSize()
        case 7:
            animateContents()
        case 8:
            animateContentsRect()
        case 9:
            animateCornerRadius()
        case 10:
            animateDoubleSided()
        case 11:
            animateHidden()
        case 12:
            animateMask()
        case 13:
            animateOpacity()
        case 14:
            animatePosition()
        case 15:
            animateShadowColor()
        case 16:
            animateShadowOffset()
        case 17:
            animateShadowOpacity()
        case 18:
            animateShadowPath()
        case 19:
            animateShadowRadius()
        case 20:
            animateSublayers()
        case 21:
            animateSublayerTransform()
        case 22:
            animateTransform()
        case 23:
            animateZPosition()
        default:
            preconditionFailure()
        }
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        subLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
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
}

private class MultiLayerView: UIView {
    
    let redLayer = CALayer()
    let yellowLayer = CALayer()
    let blueLayer = CALayer()
    
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
        
        layer.addSublayer(redLayer)
        layer.addSublayer(yellowLayer)
        layer.addSublayer(blueLayer)
        
        let size = CGSize(width: 100, height: 100)
        redLayer.frame.size = size
        redLayer.backgroundColor = UIColor.red.cgColor
        yellowLayer.frame.size = size
        yellowLayer.backgroundColor = UIColor.yellow.cgColor
        blueLayer.frame.size = size
        blueLayer.backgroundColor = UIColor.blue.cgColor
        
        blueLayer.borderWidth = 2
        blueLayer.contentsGravity = .center
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        redLayer.position = CGPoint(x: bounds.midX - 10, y: bounds.midY - 10)
        yellowLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
        blueLayer.position = CGPoint(x: bounds.midX + 10, y: bounds.midY + 10)
    }
}

