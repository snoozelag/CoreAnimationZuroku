//
//  LayerSubclassSampleViewController.swift
//  CoreAnimationZuroku
//
//  Created by teruto.yamasaki on 2021/10/17.
//

import UIKit

/// Providing a Layer’s Contents
/// Define a layer subclass and override one of its drawing methods to provide the layer contents yourself.
class LayerSubclassSampleViewController: UIViewController {

    private let sampleView = SampleView()
    private let drawView = DrawView()
    private let switchView = UISwitch()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Layer Subclass"
        view.backgroundColor = .systemBackground

        sampleView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sampleView)
        sampleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 11).isActive = true
        sampleView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        sampleView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        sampleView.heightAnchor.constraint(equalToConstant: 200).isActive = true

        drawView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(drawView)
        drawView.topAnchor.constraint(equalTo: sampleView.bottomAnchor, constant: 11).isActive = true
        drawView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 11).isActive = true
        drawView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -11).isActive = true
        drawView.heightAnchor.constraint(equalToConstant: 250).isActive = true

        switchView.translatesAutoresizingMaskIntoConstraints = false
        switchView.setOn(true, animated: false)
        view.addSubview(switchView)
        switchView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        switchView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40).isActive = true
        switchView.addTarget(self, action: #selector(switchViewValueChanged(_:)), for: .valueChanged)
    }

    @objc private func switchViewValueChanged(_ sender: UISwitch) {
        sampleView.showsImage = sender.isOn
        drawView.drawType = sender.isOn ? .square : .circle
    }
}

private class SampleView: UIView {

    private let subLayer = ImageLayer()

    var showsImage: Bool {
        get { subLayer.showsImage }
        set {
            if subLayer.showsImage != newValue {
                subLayer.showsImage = newValue
                // Call the display() method via setNeedsDisplay().
                subLayer.setNeedsDisplay()
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        layer.addSublayer(subLayer)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        subLayer.frame = bounds
    }
}

private class ImageLayer: CALayer {

    override init() {
        super.init()
        setup()
    }

    override init(layer: Any) {
        super.init(layer: layer)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        contents = UIImage(named: "caz")?.cgImage
        contentsScale = UIScreen.main.scale
    }

    var showsImage: Bool = true

    override func display() {
        // By simply updating the properties of the layer object, Core Animation will implicitly create an animation object and schedule it to perform the animation.
        if showsImage {
            opacity = 1
        } else {
            opacity = 0
        }
    }
}

private enum DrawType {
    case square
    case circle
}

private class DrawView: UIView {

    private let subLayer = DrawLayer()

    var drawType: DrawType {
        get { subLayer.drawType }
        set {
            if subLayer.drawType != newValue {
                subLayer.drawType = newValue
                // Call the draw(in:) method via setNeedsDisplay().
                subLayer.setNeedsDisplay()
            }
        }
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
        subLayer.frame = bounds
        subLayer.setNeedsDisplay()
    }

    private func setup() {
        layer.addSublayer(subLayer)
    }
}

private class DrawLayer: CALayer {

    var drawType: DrawType = .square

    // NOTE: If displayLayer: is implemented, the layer will only call the displayLayer: method. The implementation should be drawLayer:inContext: or only one of the methods.
    override func draw(in context: CGContext) {
        // By simply updating the properties of the layer object, Core Animation will implicitly create an animation object and schedule it to perform the animation.

        let lineWidth: CGFloat = 10
        context.setLineWidth(lineWidth)

        let halfLineWidth = lineWidth / 2
        let shortSideLength = min(bounds.size.height, bounds.size.width)
        let longSideLength = max(bounds.size.height, bounds.size.width)
        let rect = CGRect(x: longSideLength / 2 - shortSideLength / 2, y: 0, width: shortSideLength, height: shortSideLength).insetBy(dx: halfLineWidth, dy: halfLineWidth)

        switch drawType {
        case .square:
            context.addRect(rect)
            context.setStrokeColor(UIColor.blue.cgColor)
            context.setFillColor(UIColor.yellow.cgColor)
        case .circle:
            context.addEllipse(in: rect)
            context.setStrokeColor(UIColor.red.cgColor)
            context.setFillColor(UIColor.green.cgColor)
        }
        context.drawPath(using: .fillStroke)
    }
}
